import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _offlineMode = false;
  bool _notificationsEnabled = true;
  bool _streakReminders = true;
  bool _friendActivity = true;
  double _playbackSpeed = 1.0;
  String _audioQuality = 'High';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Account
          _SectionHeader(title: 'Account'),
          _SettingsTile(icon: Icons.person, title: 'Edit Profile', onTap: () {}),
          _SettingsTile(icon: Icons.language, title: 'Language Preferences', subtitle: 'English, Hindi, Hinglish', onTap: () {}),
          _SettingsTile(icon: Icons.interests, title: 'Interest Topics', subtitle: '4 selected', onTap: () {}),
          _SettingsTile(icon: Icons.commute, title: 'Commute Duration', subtitle: '45 minutes', onTap: () {}),

          // Playback
          _SectionHeader(title: 'Playback'),
          ListTile(
            leading: const Icon(Icons.speed, color: AppColors.primary),
            title: const Text('Default Playback Speed'),
            subtitle: Text('${_playbackSpeed}x'),
            trailing: DropdownButton<double>(
              value: _playbackSpeed,
              items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0]
                  .map((s) => DropdownMenuItem(value: s, child: Text('${s}x')))
                  .toList(),
              onChanged: (val) => setState(() => _playbackSpeed = val ?? 1.0),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.high_quality, color: AppColors.primary),
            title: const Text('Audio Quality'),
            subtitle: Text(_audioQuality),
            trailing: DropdownButton<String>(
              value: _audioQuality,
              items: ['Low (32kbps)', 'Medium (64kbps)', 'High (128kbps)']
                  .map((q) => DropdownMenuItem(value: q.split(' ').first, child: Text(q)))
                  .toList(),
              onChanged: (val) => setState(() => _audioQuality = val ?? 'High'),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.download_for_offline, color: AppColors.primary),
            title: const Text('Offline Mode'),
            subtitle: const Text('Download content for commute'),
            value: _offlineMode,
            onChanged: (val) => setState(() => _offlineMode = val),
          ),

          // Appearance
          _SectionHeader(title: 'Appearance'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode, color: AppColors.primary),
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),

          // Notifications
          _SectionHeader(title: 'Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications, color: AppColors.primary),
            title: const Text('Push Notifications'),
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.local_fire_department, color: AppColors.primary),
            title: const Text('Streak Reminders'),
            subtitle: const Text('Remind before streak breaks'),
            value: _streakReminders,
            onChanged: (val) => setState(() => _streakReminders = val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.people, color: AppColors.primary),
            title: const Text('Friend Activity'),
            subtitle: const Text('When friends save or reflect'),
            value: _friendActivity,
            onChanged: (val) => setState(() => _friendActivity = val),
          ),

          // Integrations
          _SectionHeader(title: 'Integrations'),
          _SettingsTile(icon: Icons.note, title: 'Connect Notion', subtitle: 'Export saves to Notion', onTap: () {}),
          _SettingsTile(icon: Icons.book, title: 'Connect Readwise', onTap: () {}),
          _SettingsTile(icon: Icons.source, title: 'Connect Obsidian', onTap: () {}),

          // About
          _SectionHeader(title: 'About'),
          _SettingsTile(icon: Icons.privacy_tip, title: 'Privacy Policy', onTap: () {}),
          _SettingsTile(icon: Icons.description, title: 'Terms of Service', onTap: () {}),
          _SettingsTile(icon: Icons.info, title: 'App Version', subtitle: '1.0.0', onTap: () {}),
          _SettingsTile(icon: Icons.logout, title: 'Log Out', titleColor: AppColors.error, onTap: () {}),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.title, this.subtitle, this.titleColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: TextStyle(color: titleColor)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey400),
      onTap: onTap,
    );
  }
}
