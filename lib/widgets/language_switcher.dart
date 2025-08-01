import 'package:flutter/material.dart';
import '../services/language_service.dart';

class LanguageSwitcher extends StatefulWidget {
  final VoidCallback? onLanguageChanged;
  
  const LanguageSwitcher({
    super.key,
    this.onLanguageChanged,
  });

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  String _currentLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final language = await LanguageService.getCurrentLanguage();
    setState(() {
      _currentLanguage = language;
    });
  }

  Future<void> _toggleLanguage() async {
    await LanguageService.toggleLanguage();
    await _loadCurrentLanguage();
    if (widget.onLanguageChanged != null) {
      widget.onLanguageChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleLanguage,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  size: 18,
                  color: Colors.blue[700],
                ),
                const SizedBox(width: 6),
                Text(
                  _currentLanguage == 'ar' ? 'العربية' : 'English',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: Colors.blue[700],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 