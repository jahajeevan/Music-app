import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/color_tokens.dart';
import '../../../../app/app.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../player/presentation/providers/player_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final quality = ref.watch(audioQualityProvider);

    return Scaffold(
      backgroundColor: WaveColors.bg,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: WaveColors.bg,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          // Profile section
          _SectionHeader(title: 'Account'),
          _SettingsTile(
            icon: Icons.person_rounded,
            title: 'Profile',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.workspace_premium_rounded,
            title: 'Subscription',
            subtitle: 'Free plan',
            onTap: () {},
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: WaveColors.gradientPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Upgrade',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),

          // Audio section
          _SectionHeader(title: 'Audio'),
          _SettingsDropdownTile<StreamingQuality>(
            icon: Icons.high_quality_rounded,
            title: 'Streaming Quality',
            value: quality,
            items: const [
              DropdownMenuItem(
                  value: StreamingQuality.normal, child: Text('Normal (128 kbps)')),
              DropdownMenuItem(
                  value: StreamingQuality.high, child: Text('High (256 kbps)')),
              DropdownMenuItem(
                  value: StreamingQuality.veryHigh, child: Text('Very High (320 kbps)')),
              DropdownMenuItem(
                  value: StreamingQuality.lossless, child: Text('Lossless (FLAC)')),
              DropdownMenuItem(
                  value: StreamingQuality.hiResLossless,
                  child: Text('Hi-Res Lossless')),
            ],
            onChanged: (v) {
              if (v != null)
                ref.read(audioQualityProvider.notifier).state = v;
            },
          ),
          _SettingsTile(
            icon: Icons.equalizer_rounded,
            title: 'Equalizer',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.shuffle_on_rounded,
            title: 'Crossfade',
            subtitle: '5 seconds',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.volume_up_rounded,
            title: 'Volume Normalization',
            onTap: () {},
            trailing: Switch(
              value: true,
              onChanged: (_) {},
            ),
          ),
          _SettingsTile(
            icon: Icons.spatial_audio_rounded,
            title: 'Spatial Audio',
            onTap: () {},
            trailing: Switch(
              value: false,
              onChanged: (_) {},
            ),
          ),

          // Downloads
          _SectionHeader(title: 'Downloads'),
          _SettingsTile(
            icon: Icons.download_rounded,
            title: 'Download Quality',
            subtitle: 'Very High',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.storage_rounded,
            title: 'Storage Used',
            subtitle: '2.3 GB of 10 GB',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.wifi_rounded,
            title: 'Download on Wi-Fi Only',
            onTap: () {},
            trailing: Switch(value: true, onChanged: (_) {}),
          ),

          // Appearance
          _SectionHeader(title: 'Appearance'),
          _SettingsDropdownTile<ThemeMode>(
            icon: Icons.dark_mode_rounded,
            title: 'Theme',
            value: themeMode,
            items: const [
              DropdownMenuItem(
                  value: ThemeMode.dark, child: Text('Dark')),
              DropdownMenuItem(
                  value: ThemeMode.light, child: Text('Light')),
              DropdownMenuItem(
                  value: ThemeMode.system, child: Text('System')),
            ],
            onChanged: (v) {
              if (v != null)
                ref.read(themeModeProvider.notifier).state = v;
            },
          ),

          // Haptics
          _SectionHeader(title: 'Experience'),
          _SettingsTile(
            icon: Icons.vibration_rounded,
            title: 'Haptic Beat Sync',
            subtitle: 'Vibrate to the beat',
            onTap: () {},
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          _SettingsTile(
            icon: Icons.translate_rounded,
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.public_rounded,
            title: 'Region',
            subtitle: 'United States',
            onTap: () {},
          ),

          // Privacy
          _SectionHeader(title: 'Privacy'),
          _SettingsTile(
            icon: Icons.visibility_rounded,
            title: 'Public Profile',
            onTap: () {},
            trailing: Switch(value: true, onChanged: (_) {}),
          ),
          _SettingsTile(
            icon: Icons.history_rounded,
            title: 'Listening History',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.data_usage_rounded,
            title: 'Data Saver',
            onTap: () {},
            trailing: Switch(value: false, onChanged: (_) {}),
          ),

          // Support
          _SectionHeader(title: 'Support'),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About Wavelength',
            subtitle: 'v1.0.0',
            onTap: () {},
          ),

          // Sign out
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) context.go('/login');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: WaveColors.error,
                side: const BorderSide(color: WaveColors.error),
              ),
              child: const Text('Sign Out'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: WaveColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: WaveColors.surfaceCard,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: WaveColors.textSecondary, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(
              color: WaveColors.textPrimary, fontSize: 15)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: const TextStyle(
                  color: WaveColors.textMuted, fontSize: 12))
          : null,
      trailing: trailing ??
          const Icon(Icons.chevron_right_rounded,
              color: WaveColors.textMuted, size: 20),
      onTap: onTap,
    );
  }
}

class _SettingsDropdownTile<T> extends StatelessWidget {
  const _SettingsDropdownTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: WaveColors.surfaceCard,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: WaveColors.textSecondary, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(
              color: WaveColors.textPrimary, fontSize: 15)),
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        dropdownColor: WaveColors.surfaceCard,
        underline: const SizedBox.shrink(),
        style: const TextStyle(color: WaveColors.textMuted, fontSize: 13),
        icon: const Icon(Icons.expand_more_rounded,
            color: WaveColors.textMuted, size: 18),
      ),
    );
  }
}
