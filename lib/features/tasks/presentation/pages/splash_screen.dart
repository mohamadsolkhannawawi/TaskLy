// lib/features/tasks/presentation/pages/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'home_page.dart';
import '../../../../core/utils/app_colors.dart';

/// Splash Screen with Logo + TaskLy Text
/// Professional Programmatic Layout (Logo & Text Separate)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations for smooth appearance
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    // Navigate to Home after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // White background
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. LOGO ICON (Using PNG asset)
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: AppColors.primary.withValues(alpha: 0.15),
                    //     blurRadius: 6,
                    //     spreadRadius: -1,
                    //     offset: const Offset(0, 2),
                    //   ),
                    // ],
                  ),
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 8), // Space between logo and text
                // 2. TASKLY TEXT (Charcoal Gray)
                Text(
                  'TaskLy',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoalBlack, // Charcoal Gray
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 8),

                // 3. TAGLINE (Subtle Gray)
                Text(
                  'Stay Productive',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
