import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';
import '../l10n/app_localizations.dart';
import 'login_screen.dart';
import 'templates_screen.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  final void Function(String langCode)? setLocale;
  const SettingsScreen({super.key, this.setLocale});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'ar';
  String _appVersion = '1.1.2';
  String _localWifi = '<unknown ssid>';
  String _localIp = '192.168.1.100';
  Uint8List? _logoBytes;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadLogo();
  }

  Future<void> _loadSettings() async {
    // Load settings from SharedPreferences
    // For now, using default values
  }

  Future<void> _loadLogo() async {
    final prefs = await SharedPreferences.getInstance();
    final logoBase64 = prefs.getString('app_logo');
    if (logoBase64 != null) {
      setState(() {
        _logoBytes = base64Decode(logoBase64);
      });
    }
  }

  Future<void> _pickLogo() async {
    if (kIsWeb) {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('app_logo', base64Encode(bytes));
        setState(() {
          _logoBytes = bytes;
        });
      }
    } else {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('app_logo', base64Encode(bytes));
        setState(() {
          _logoBytes = bytes;
        });
      }
    }
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logout_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.logout,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[400]!, Colors.purple[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  l10n.settings,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                // Logo picker section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _logoBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              _logoBytes!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.image, color: Colors.white, size: 36),
                          ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _pickLogo,
                      icon: Icon(Icons.upload, color: Colors.white),
                      label: Text('تغيير اللوجو', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Settings Cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Display Card
                _buildSettingsCard(
                  title: l10n.display,
                  gradient: [Color(0xFF7C3AED), Color(0xFF7C3AED)],
                  children: [
                    _buildSettingsItem(
                      icon: Icons.dashboard,
                      title: l10n.templates,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TemplatesScreen()),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // About Card
                _buildSettingsCard(
                  title: l10n.about,
                  gradient: [Colors.orange[400]!, Colors.orange[600]!],
                  children: [
                    _buildSettingsItem(
                      icon: Icons.info,
                      title: l10n.app_version,
                      subtitle: _appVersion,
                      onTap: () {},
                    ),
                    const Divider(color: Colors.white24),
                    _buildSettingsItem(
                      icon: Icons.wifi,
                      title: l10n.local_wifi,
                      subtitle: _localWifi,
                      onTap: () {},
                    ),
                    const Divider(color: Colors.white24),
                    _buildSettingsItem(
                      icon: Icons.computer,
                      title: l10n.local_ip,
                      subtitle: _localIp,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Language Card
                _buildSettingsCard(
                  title: l10n.language,
                  gradient: [Colors.purple[400]!, Colors.purple[600]!],
                  children: [
                    _buildSettingsItem(
                      icon: Icons.language,
                      title: l10n.arabic,
                      isSelected: _selectedLanguage == 'ar',
                      onTap: () {
                        setState(() {
                          _selectedLanguage = 'ar';
                        });
                        if (widget.setLocale != null) {
                          widget.setLocale!('ar');
                        }
                      },
                    ),
                    const Divider(color: Colors.white24),
                    _buildSettingsItem(
                      icon: Icons.language,
                      title: l10n.english,
                      isSelected: _selectedLanguage == 'en',
                      onTap: () {
                        setState(() {
                          _selectedLanguage = 'en';
                        });
                        if (widget.setLocale != null) {
                          widget.setLocale!('en');
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Logout Card
                _buildSettingsCard(
                  title: l10n.account,
                  gradient: [Colors.red[400]!, Colors.red[600]!],
                  children: [
                    _buildSettingsItem(
                      icon: Icons.logout,
                      title: l10n.logout,
                      onTap: _logout,
                      isDestructive: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Color> gradient,
    required List<Widget> children,
  }) {
    final purple = Color(0xFF7C3AED);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: purple.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool isSelected = false,
    bool isDestructive = false,
  }) {
    final purple = Color(0xFF7C3AED);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: purple.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red[100] : purple,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red[100] : purple,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: subtitle != null ? Text(
        subtitle,
        style: TextStyle(
          color: purple.withOpacity(0.7),
        ),
      ) : null,
      trailing: onTap != null ? Icon(
        Icons.arrow_forward_ios,
        color: purple.withOpacity(0.7),
        size: 16,
      ) : null,
      onTap: onTap,
    );
  }
} 