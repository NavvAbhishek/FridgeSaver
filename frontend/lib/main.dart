import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before calling async code.
  WidgetsFlutterBinding.ensureInitialized();
  // Check if a user token exists to decide the initial route.
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwt_token');

  runApp(FridgeSaverApp(initialRoute: token == null ? '/' : '/home'));
}

class FridgeSaverApp extends StatelessWidget {
  final String initialRoute;

  const FridgeSaverApp({Key? key, required this.initialRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FridgeSaver',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32), // A deep green color
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF66BB6A), // A lighter, friendly green
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF2E7D32), // Button text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor:
              const Color(0xFFF1F8E9), // Light green fill for text fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
      // --- Route Management ---
      // Defines the navigation routes for the app.
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
