import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/shared_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _autoDownload = false;
  bool _pushNotifications = true;
  bool _streakReminder = true;
  double _playbackSpeed = 1.0;
  String _audioQuality = 'high';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        children: [
          // ── Account ──
          _SectionLabel('ACCOUNT'),
          _SettingsTile(
            icon: Icons.person_outlined,
            title: 'Edit Profile',
            subtitle: 'Name, bio, avatar',
            onTap: () => context.push('/editProfile'),
          ),
          _SettingsTile(
            icon: Icons.language_rounded,
            title: 'Languages',
            subtitle: 'English, Hindi',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.category_outlined,
            title: 'Interests',
            subtitle: 'Technology, Business, AI',
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // ── Playback ──
          _SectionLabel('PLAYBACK'),
          _DropdownTile(
            icon: Icons.speed_rounded,
            title: 'Playback Speed',
            value: '${_playbackSpeed}x',
            items: ['0.5x', '0.75x', '1.0x', '1.25x', '1.5x', '2.0x', '3.0x'],
            onChanged: (val) {
              setState(() {
                _playbackSpeed = double.parse(val.replaceAll('x', ''));
              });
            },
          ),
          _DropdownTile(
            icon: Icons.high_quality_rounded,
            title: 'Audio Quality',
            value: _audioQuality == 'high' ? 'High' : (_audioQuality == 'medium' ? 'Medium' : 'Low'),
            items: ['High', 'Medium', 'Low'],
            onChanged: (val) => setState(() => _audioQuality = val.toLowerCase()),
          ),
          _SwitchTile(
            icon: Icons.download_rounded,
            title: 'Auto Download',
            subtitle: 'Download on Wi-Fi',
            value: _autoDownload,
            onChanged: (val) => setState(() => _autoDownload = val),
          ),

          const SizedBox(height: 20),

          // ── Appearance ──
          _SectionLabel('APPEARANCE'),
          _SwitchTile(
            icon: Icons.dark_mode_rounded,
            title: 'Dark Mode',
            subtitle: 'Optimized for AMOLED',
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),

          const SizedBox(height: 20),

          // ── Notifications ──
          _SectionLabel('NOTIFICATIONS'),
          _SwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'New episodes, updates',
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          _SwitchTile(
            icon: Icons.local_fire_department_rounded,
            title: 'Streak Reminder',
            subtitle: 'Daily at 8 PM',
            value: _streakReminder,
            onChanged: (val) => setState(() => _streakReminder = val),
          ),

          const SizedBox(height: 20),

          // ── Integrations ──
          _SectionLabel('INTEGRATIONS'),
          _SettingsTile(
            icon: Icons.edit_note_rounded,
            title: 'Notion',
            subtitle: 'Sync notes & highlights',
            trailing: _ConnectedBadge(connected: false),
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.psychology_rounded,
            title: 'Readwise',
            subtitle: 'Export quotes & clips',
            trailing: _ConnectedBadge(connected: true),
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // ── About ──
          _SectionLabel('ABOUT'),
          _SettingsTile(
            icon: Icons.info_outlined,
            title: 'About Kaan',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // ── Danger zone ──
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Sign Out',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.error),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Delete Account',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.grey600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4, left: 4),
      child: Text(text, style: AppTextStyles.overline.copyWith(color: AppColors.grey500)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.title, this.subtitle, this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return KCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.grey400, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                if (subtitle != null) Text(subtitle!, style: AppTextStyles.caption),
              ],
            ),
          ),
          trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.grey600, size: 20),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({required this.icon, required this.title, this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return KCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.grey400, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                if (subtitle != null) Text(subtitle!, style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            inactiveTrackColor: AppColors.darkDivider,
            inactiveThumbColor: AppColors.grey600,
          ),
        ],
      ),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownTile({required this.icon, required this.title, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return KCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.grey400, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleSmall)),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.grey500),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => onChanged(val!),
          ),
        ],
      ),
    );
  }
}

class _ConnectedBadge extends StatelessWidget {
  final bool connected;
  const _ConnectedBadge({required this.connected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: connected ? AppColors.success.withValues(alpha: 0.12) : AppColors.grey700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        connected ? 'Connected' : 'Connect',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: connected ? AppColors.success : AppColors.grey400,
        ),
      ),
    );
  }
}
