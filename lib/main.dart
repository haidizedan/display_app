import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/auth_service.dart';
import 'services/data_service.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  print('App started');
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase...');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase initialized');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar');

  @override
  void initState() {
    super.initState();
    print('Building MyApp');
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('app_language') ?? 'ar';
    setState(() {
      _locale = Locale(lang);
    });
  }

  void setLocale(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', langCode);
    setState(() {
      _locale = Locale(langCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building MyApp Widget');
    return MaterialApp(
      title: 'Display App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        cardTheme: CardThemeData(  // ← تم التعديل هنا
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      locale: _locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AuthWrapper(setLocale: setLocale),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  final void Function(String langCode) setLocale;
  const AuthWrapper({super.key, required this.setLocale});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    print('Building AuthWrapper');
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      print('Checking Auth Status...');
      final isLoggedIn = await AuthService.isLoggedIn();
      print('Auth Status: $isLoggedIn');
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
    } catch (e) {
      print('Auth Status Error: $e');
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building AuthWrapper Widget');
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return _isLoggedIn
        ? MainScreen(setLocale: widget.setLocale)
        : const LoginScreen();
  }
}

