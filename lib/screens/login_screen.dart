import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/language_switcher.dart';
import 'main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedLanguage = 'ar';

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _usernameController.text = 'admin';
    _loadCurrentLanguage();
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLanguage() async {
    final language = await LanguageService.getCurrentLanguage();
    setState(() {
      _selectedLanguage = language;
    });
  }

  Future<bool> _firebaseLogin(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A1B9A), // Deep Purple
              Color(0xFF8E24AA), // Purple
              Color(0xFFAB47BC), // Light Purple
              Color(0xFFCE93D8), // Very Light Purple
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Language Switcher at the top
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LanguageSwitcher(
                      onLanguageChanged: () {
                        _loadCurrentLanguage();
                      },
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.black.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.grey[50]!,
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // App Icon with pulse animation
                                      AnimatedBuilder(
                                        animation: _pulseAnimation,
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale: _pulseAnimation.value,
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFF6A1B9A),
                                                    Color(0xFF8E24AA),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0xFF6A1B9A).withOpacity(0.3),
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 10),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.display_settings,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 32),
                                      
                                      // Title
                                      Text(
                                        l10n.login,
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6A1B9A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.welcome,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 40),
                                      
                                      // Username Field
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: _usernameController,
                                          decoration: InputDecoration(
                                            labelText: _selectedLanguage == 'ar' ? 'اسم المستخدم' : 'Username',
                                            prefixIcon: const Icon(Icons.person, color: Color(0xFF6A1B9A)),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return l10n.enter_username;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      
                                      // Password Field
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          decoration: InputDecoration(
                                            labelText: _selectedLanguage == 'ar' ? 'كلمة المرور' : 'Password',
                                            prefixIcon: const Icon(Icons.lock, color: Color(0xFF6A1B9A)),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                                color: const Color(0xFF6A1B9A),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscurePassword = !_obscurePassword;
                                                });
                                              },
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return l10n.enter_password;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      
                                      // Login Button
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: _isLoading
                                              ? null
                                              : () async {
                                                  if (_formKey.currentState!.validate()) {
                                                    setState(() => _isLoading = true);
                                                    final success = await _firebaseLogin(
                                                      _usernameController.text.trim(),
                                                      _passwordController.text.trim(),
                                                    );
                                                    setState(() => _isLoading = false);
                                                    if (success) {
                                                      if (mounted) {
                                                        Navigator.of(context).pushReplacement(
                                                          PageRouteBuilder(
                                                            pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
                                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                              return FadeTransition(opacity: animation, child: child);
                                                            },
                                                            transitionDuration: const Duration(milliseconds: 500),
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      if (mounted) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text(l10n.login_failed),
                                                            backgroundColor: Colors.red,
                                                            behavior: SnackBarBehavior.floating,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF6A1B9A),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            elevation: 8,
                                            shadowColor: const Color(0xFF6A1B9A).withOpacity(0.3),
                                          ),
                                          child: _isLoading
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                )
                                              : Text(
                                                  l10n.login,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      
                                      // Subtle hint
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6A1B9A).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: const Color(0xFF6A1B9A).withOpacity(0.2),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              size: 16,
                                              color: const Color(0xFF6A1B9A).withOpacity(0.7),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              l10n.use_default_credentials,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: const Color(0xFF6A1B9A).withOpacity(0.7),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      // زر الانتقال إلى شاشة التسجيل
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            l10n.dont_have_account ?? 'ليس لديك حساب؟',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final result = await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => const SignUpScreen(),
                                                ),
                                              );
                                              // إذا تم التسجيل بنجاح، أظهر رسالة نجاح
                                              if (result == true && mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(l10n.sign_up_success ?? 'تم إنشاء الحساب بنجاح!'),
                                                    backgroundColor: Colors.green,
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              l10n.sign_up ?? 'سجل حساب جديد',
                                              style: const TextStyle(
                                                color: Color(0xFF6A1B9A),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 