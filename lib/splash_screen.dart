import 'package:flutter/material.dart';
import 'diary_screen.dart';  // Import DiaryScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController for fade-in effect
    _controller = AnimationController(
      vsync: this,  // This ensures the animation controller is disposed properly
      duration: const Duration(seconds: 2),  // Duration of fade-in effect
    );

    // Create the fade-in animation (from opacity 0.0 to 1.0)
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation
    _controller.forward();

    // After 3 seconds, navigate to DiaryScreen
    _navigateToHome();
  }

  // Navigate to DiaryScreen after 3 seconds
  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3)); // Wait for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  DiaryScreen()), // Navigate to DiaryScreen
    );
  }

  @override 
  void dispose() {
    _controller.dispose();  // Dispose of the animation controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,  // Dark background for the hacker theme
        ),
        child: Stack(
          children: [
            // Centered Logo
            Center(
              child: FadeTransition(
                opacity: _logoAnimation,  // Link the fade-in animation to the logo
                child: Image.asset(
                  'assets/images/DiaryLogo.png',  // Path to your logo
                  width: 500,
                  height: 500,
                ),
              ),
            ),
            // Bottom-Centered Text Label
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'Diary By Mine',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 229, 231, 230),  // Neon green text for hacker theme
                    letterSpacing: 2,  // Adjust letter spacing for modern look
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.greenAccent,  // Green glow effect
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
