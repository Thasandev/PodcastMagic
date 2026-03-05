import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/pickers.dart';
import '../../auth/data/repositories/auth_repository.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _darkMode = true;
  bool _offlineMode = false;
  bool _notificationsEnabled = true;
  bool _streakReminders = true;
  bool _friendActivity = true;
  double _playbackSpeed = 1.0;
  String _audioQuality = 'High';

  // Mock states for pickers
  Set<String> _selectedLanguages = {'en', 'hi'};
  Set<String> _selectedInterests = {'tech', 'business'};
  double _commuteDuration = 45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Account
          const _SectionHeader(title: 'Account'),
          _SettingsTile(
            icon: Icons.person, 
            title: 'Edit Profile', 
            onTap: () => context.push('/edit-profile'),
          ),
          _SettingsTile(
            icon: Icons.language, 
            title: 'Language Preferences', 
            subtitle: _selectedLanguages.join(', ').toUpperCase(), 
            onTap: () => _showLanguagePicker(),
          ),
          _SettingsTile(
            icon: Icons.interests, 
            title: 'Interest Topics', 
            subtitle: '${_selectedInterests.length} topics selected', 
            onTap: () => _showInterestPicker(),
          ),
          _SettingsTile(
            icon: Icons.commute, 
            title: 'Commute Duration', 
            subtitle: '${_commuteDuration.round()} minutes', 
            onTap: () => _showCommutePicker(),
          ),

          // Playback
          const _SectionHeader(title: 'Playback'),
          ListTile(
            leading: const Icon(Icons.speed, color: AppColors.primary),
            title: const Text('Default Playback Speed'),
            subtitle: Text('${_playbackSpeed}x'),
            trailing: DropdownButton<double>(
              value: _playbackSpeed,
              dropdownColor: const Color(0xFF252A32),
              items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0]
                  .map((s) => DropdownMenuItem(value: s, child: Text('${s}x', style: const TextStyle(color: Colors.white))))
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
              dropdownColor: const Color(0xFF252A32),
              items: ['Low (32kbps)', 'Medium (64kbps)', 'High (128kbps)']
                  .map((q) => DropdownMenuItem(
                        value: q.split(' ').first, 
                        child: Text(q, style: const TextStyle(color: Colors.white)),
                      ))
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
          const _SectionHeader(title: 'Appearance'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode, color: AppColors.primary),
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),

          // Notifications
          const _SectionHeader(title: 'Notifications'),
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
          const _SectionHeader(title: 'Integrations'),
          _SettingsTile(icon: Icons.note, title: 'Connect Notion', subtitle: 'Export saves to Notion', onTap: () => _mockConnect('Notion')),
          _SettingsTile(icon: Icons.book, title: 'Connect Readwise', onTap: () => _mockConnect('Readwise')),
          _SettingsTile(icon: Icons.source, title: 'Connect Obsidian', onTap: () => _mockConnect('Obsidian')),

          // About
          const _SectionHeader(title: 'About'),
          _SettingsTile(icon: Icons.privacy_tip, title: 'Privacy Policy', onTap: () {}),
          _SettingsTile(icon: Icons.description, title: 'Terms of Service', onTap: () {}),
          _SettingsTile(icon: Icons.info, title: 'App Version', subtitle: '1.0.0', onTap: () {}),
          _SettingsTile(
            icon: Icons.logout, 
            title: 'Log Out', 
            titleColor: AppColors.error, 
            onTap: () => _handleLogout(),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    showDialog(
      context: context,
      builder: (context) => LanguagePickerDialog(
        initialLanguages: _selectedLanguages,
        onSaved: (langs) => setState(() => _selectedLanguages = langs),
      ),
    );
  }

  void _showInterestPicker() {
    showDialog(
      context: context,
      builder: (context) => InterestPickerDialog(
        initialInterests: _selectedInterests,
        onSaved: (interests) => setState(() => _selectedInterests = interests),
      ),
    );
  }

  void _showCommutePicker() {
    showDialog(
      context: context,
      builder: (context) => CommuteDurationDialog(
        initialDuration: _commuteDuration,
        onSaved: (dur) => setState(() => _commuteDuration = dur),
      ),
    );
  }

  void _mockConnect(String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connecting to $platform... (Mock flow)')),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1E24),
        title: const Text('Log Out', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to log out?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Log Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authRepositoryProvider).signOut();
      if (mounted) context.go('/login');
    }
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
