import 'package:flutter/material.dart';
import '../theme/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeController.instance.themeMode,
        builder: (context, mode, child) {
          final isDark = mode == ThemeMode.dark;
          
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: [
              _buildSettingTile(
                icon: Icons.brightness_6_outlined,
                title: 'Theme',
                trailing: Text(
                  isDark ? 'Dark' : 'Light',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              _buildSettingTile(
                icon: Icons.palette_outlined,
                title: 'Change Theme',
                subtitle: isDark ? 'Dark Mode' : 'Light Mode',
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    ThemeController.instance.toggleTheme(value);
                  },
                  activeColor: const Color(0xFF5146D8),
                ),
              ),
              _buildSettingTile(
                icon: Icons.info_outline,
                title: 'About App',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Contact Management App',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(
                      Icons.contacts,
                      color: Color(0xFF5146D8),
                      size: 40,
                    ),
                    children: const [
                      Text('A simple Flutter contact management app using SQLite local database.'),
                    ],
                  );
                },
                trailing: const Icon(Icons.chevron_right, size: 20),
              ),
              _buildSettingTile(
                icon: Icons.access_time,
                title: 'Version',
                trailing: Text(
                  '1.0.0',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
