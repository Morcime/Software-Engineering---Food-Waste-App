import 'package:flutter/material.dart';
import '../services/auth/login_or_register.dart'; // Halaman login/register

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Kurangi Sampah, Berbagi Makanan, Selamatkan Dunia",
      "description": "Setiap makanan yang terselamatkan adalah langkah menuju dunia yang lebih baik. Dengan berbagi makanan berlebih, kita bisa mengurangi limbah makanan dan membantu mereka yang membutuhkan.",
      "image": "lib/images/background/splashscreen.png", // Ganti dengan gambar Anda
    },
    {
      "title": "Dari Sisa Jadi Berkah – Bantu Sesama, Selamatkan Bumi",
      "description": "Makanan berlebih bukan berarti harus terbuang. Dengan aplikasi ini, Anda bisa mengubah makanan menjadi berkah bagi orang lain sekaligus menjaga lingkungan dari limbah berlebih.",
      "image": "lib/images/background/splashscreen.png", // Ganti dengan gambar Anda
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(onboardingData[index]["image"]!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        onboardingData[index]["title"]!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        onboardingData[index]["description"]!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < onboardingData.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginOrRegister()),
                  );
                }
              },
              child: Text(_currentPage == onboardingData.length - 1 ? "Mulai" : "Lanjut"),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}