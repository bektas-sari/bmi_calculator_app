import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BMICalculatorApp());
}

/// Ana uygulama widget'ı. Tema ve yönlendirme için temel yapılandırmayı içerir.
class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Hesaplayıcı',
      theme: ThemeData(
        // Uygulama genelinde mavi ve beyaz tonları kullanıyoruz
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.blue),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
          ),
        ),
      ),
      home: const BMIScreen(),
    );
  }
}

/// BMI hesaplayıcı ekranı. Kullanıcı girdilerini alır ve sonuçları animasyonlarla gösterir.
class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? _bmi;
  String? _category;
  String? _interpretation;
  bool _showResult = false;

  /// Kullanıcının girdiği boy ve kiloya göre BMI hesaplar ve sonuçları ayarlar.
  void _calculateBMI() {
    final double? weight = double.tryParse(_weightController.text.replaceAll(',', '.'));
    final double? heightCm = double.tryParse(_heightController.text.replaceAll(',', '.'));
    if (weight == null || heightCm == null || weight <= 0 || heightCm <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli bir boy ve kilo değeri girin.')),
      );
      return;
    }
    final double heightM = heightCm / 100;
    final double bmi = weight / pow(heightM, 2);
    String category;
    String interpretation;
    if (bmi < 18.5) {
      category = 'Zayıf';
      interpretation = 'Biraz kilo alabilirsiniz.';
    } else if (bmi < 25) {
      category = 'Normal';
      interpretation = 'Kilonuz normal, böyle devam!';
    } else if (bmi < 30) {
      category = 'Fazla Kilolu';
      interpretation = 'Sağlıklı bir diyet ve egzersiz uygulayın.';
    } else {
      category = 'Obez';
      interpretation = 'Bir doktor ile görüşüp kilo vermeyi düşünebilirsiniz.';
    }
    setState(() {
      _bmi = bmi;
      _category = category;
      _interpretation = interpretation;
      _showResult = true;
    });
  }

  /// Hesaplamayı sıfırlar ve kullanıcıya yeni girişler yapma imkanı tanır.
  void _reset() {
    setState(() {
      _showResult = false;
      _bmi = null;
      _category = null;
      _interpretation = null;
      _heightController.clear();
      _weightController.clear();
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tam ekran kaydırma için kullanılır
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Hafif beyaz opaklık ile arka planı yumuşatın
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'BMI Hesaplayıcı',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 32,
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Boy girişi
                  TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Boy (cm)',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/height_icon.png',
                          width: 24,
                          height: 24,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Kilo girişi
                  TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Kilo (kg)',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/weight_icon.png',
                          width: 24,
                          height: 24,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Hesapla butonu
                  ElevatedButton(
                    onPressed: _calculateBMI,
                    child: const Text(
                      'Hesapla',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sonuç alanı; AnimatedSwitcher ile basit bir animasyon sağlanır
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _showResult ? _buildResultCard() : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Sonuç kartını oluşturan yardımcı metod. BMI değerini ve yorumları içerir.
  Widget _buildResultCard() {
    final bmiValue = _bmi ?? 0;
    final normalized = bmiValue / 40; // 40 en yüksek kabul edilen değer
    return Column(
      key: const ValueKey('resultCard'),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  'Sonuç',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // BMI animasyonlu gösterge
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: normalized.clamp(0.0, 1.0)),
                  duration: const Duration(milliseconds: 1200),
                  builder: (context, value, child) {
                    return SizedBox(
                      width: 180,
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: value,
                            strokeWidth: 12,
                            backgroundColor: Colors.blue.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade500),
                          ),
                          Text(
                            bmiValue.toStringAsFixed(1),
                            style: GoogleFonts.roboto(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  _category ?? '',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _interpretation ?? '',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: _reset,
          child: const Text(
            'Yeni bir hesaplama yap',
            style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}