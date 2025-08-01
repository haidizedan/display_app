import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/language_switcher.dart';
import 'devices_screen.dart';
import 'products_screen.dart';
import 'settings_screen.dart';
import 'control_screen.dart';
import 'display_screen.dart';

class MainScreen extends StatefulWidget {
  final void Function(String langCode)? setLocale;
  const MainScreen({super.key, this.setLocale});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String _selectedLanguage = 'ar';

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
    _screens.addAll([
      const DevicesScreen(),
      const ProductsScreen(),
      const ControlScreen(),
      const DisplayScreen(),
      SettingsScreen(setLocale: widget.setLocale),
    ]);
  }

  Future<void> _loadCurrentLanguage() async {
    final language = await LanguageService.getCurrentLanguage();
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Language Switcher at the top
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
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
            child: _screens[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 0 ? Icons.devices : Icons.devices_outlined),
            label: _selectedLanguage == 'ar' ? 'الأجهزة' : 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 1 ? Icons.shopping_bag : Icons.shopping_bag_outlined),
            label: _selectedLanguage == 'ar' ? 'المنتجات' : 'Goods',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 2 ? Icons.control_camera : Icons.control_camera_outlined),
            label: _selectedLanguage == 'ar' ? 'التحكم' : 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 3 ? Icons.tv : Icons.tv_outlined),
            label: _selectedLanguage == 'ar' ? 'العرض' : 'Display',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentIndex == 4 ? Icons.settings : Icons.settings_outlined),
            label: _selectedLanguage == 'ar' ? 'الإعدادات' : 'Settings',
          ),
        ],
      ),
    );
  }
} 