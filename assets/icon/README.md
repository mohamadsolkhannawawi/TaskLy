# TaskLy App Icons & Assets

## Folder Structure

```
assets/
└── icon/
    ├── logo_only.png          # Logo square icon (purple checkmark)
    ├── icon.png               # Full icon for launcher icons
    └── README.md              # This file
```

## Logo Files

### 1. `logo_only.png` (Required for Splash Screen)

-   **Purpose:** Purple rounded square with white checkmark for Splash Screen
-   **Size:** 512x512 px (recommended), 256x256 px (minimum)
-   **Format:** PNG with transparent background
-   **Color:**
    -   Background: `#A435F0` (Udemy Purple)
    -   Icon: White checkmark
    -   Rounded corners: 24px radius
-   **Location:** Used in `lib/features/tasks/presentation/pages/splash_screen.dart`

**How to replace the programmatic logo:**
If you have a custom PNG logo, update the Splash Screen code:

```dart
Image.asset(
  'assets/icon/logo_only.png',
  width: 100,
  height: 100,
)
```

### 2. `icon.png` (For App Launcher Icons)

-   **Purpose:** App icon shown on device home screen
-   **Size:** 1024x1024 px (recommended)
-   **Format:** PNG
-   **Usage:** Processed by flutter_launcher_icons package

**To generate launcher icons after adding icon.png:**

```bash
flutter pub run flutter_launcher_icons
```

This will automatically generate icons for all platforms:

-   Android (various resolutions)
-   iOS
-   Web
-   Windows
-   macOS
-   Linux

## Implementation Details

### Splash Screen Features

-   ✅ **Programmatic Layout:** Logo and text rendered separately (sharp quality)
-   ✅ **Animations:** Smooth fade-in and scale animations
-   ✅ **Duration:** 3 seconds display before navigating to HomePage
-   ✅ **Colors:** Uses AppColors constants for consistency
-   ✅ **Fonts:** Google Fonts Plus Jakarta Sans for modern look

### File Location in Code

```
lib/
└── features/
    └── tasks/
        └── presentation/
            └── pages/
                ├── splash_screen.dart  # Main splash implementation
                ├── home_page.dart
                └── ...
```

### Entry Point

The splash screen is set as the initial route in `main.dart`:

```dart
MaterialApp(
  home: const SplashScreen(), // Entry point
  ...
)
```

After 3 seconds, it automatically navigates to `HomePage()`.

## Customization

### Change Splash Screen Duration

In `splash_screen.dart`, modify the Timer duration:

```dart
Timer(const Duration(seconds: 5), () { // Change 5 to desired seconds
  Navigator.of(context).pushReplacement(...);
});
```

### Change Splash Screen Colors

The splash uses `AppColors` constants - modify `lib/core/utils/app_colors.dart`:

-   `AppColors.primary` - Purple logo background
-   `AppColors.charcoalBlack` - Text color
-   `AppColors.background` - Splash background

### Add Custom Logo PNG

1. Place your PNG in `assets/icon/logo_only.png`
2. The Splash Screen will automatically use it
3. Ensure PNG has transparent background for best results

## Color Reference

-   **Primary Purple:** `#A435F0`
-   **Charcoal Black:** `#2D2F31`
-   **White Background:** `#FFFFFF`

---

**Created for TaskLy App Rebranding - November 2025**
