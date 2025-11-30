import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/tasks/providers/task_provider.dart';
import 'features/tasks/presentation/pages/splash_screen.dart';
import 'features/tasks/models/task_model.dart';
import 'core/utils/app_colors.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register the TaskModel adapter
  Hive.registerAdapter(TaskAdapter());

  // Open the tasks box
  await Hive.openBox<Task>('tasks');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider())],
      child: MaterialApp(
        title: 'TaskLy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            surface: AppColors.background,
          ),
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,

          // Typography - Modern rounded-friendly fonts
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            ThemeData.light().textTheme,
          ),

          // AppBar Theme - PURPLE Header (Dominant)
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary, // Purple AppBar
            foregroundColor: AppColors.textInverse, // White text/icons
            elevation: 0,
            centerTitle: false,
            titleTextStyle: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textInverse, // White title
            ),
            iconTheme: const IconThemeData(
              color: AppColors.textInverse, // White icons
            ),
          ),

          // Elevated Button Theme - Pill-Shaped / Fully Rounded
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.charcoalBlack,
              foregroundColor: AppColors.textInverse,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: const StadiumBorder(),
              elevation: 2,
              textStyle: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Text Button Theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Input Decoration Theme - Rounded Borders
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.softGray,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.errorRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
            ),
            hintStyle: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            labelStyle: GoogleFonts.plusJakartaSans(
              color: AppColors.charcoalBlack,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Dialog Theme - Soft Rounded Corners
          dialogTheme: DialogThemeData(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titleTextStyle: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoalBlack,
            ),
            contentTextStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),

          // Card Theme - Rounded & Soft
          cardTheme: CardThemeData(
            color: AppColors.cardBackground,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(0),
          ),

          // Chip Theme
          chipTheme: ChipThemeData(
            backgroundColor: AppColors.softGray,
            selectedColor: AppColors.charcoalBlack,
            labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            secondaryLabelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textInverse,
            ),
            shape: const StadiumBorder(
              side: BorderSide(color: Colors.transparent),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),

          // FAB Theme - Circular / Rounded Squircle
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textInverse,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: const SplashScreen(), // Splash Screen sebagai entry point
      ),
    );
  }
}
