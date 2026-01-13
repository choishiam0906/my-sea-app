import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../providers/auth_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _darkMode = false;
  String _depthUnit = 'm';
  String _tempUnit = '°C';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _SectionTitle(title: '계정'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.person_outline,
                  title: '프로필 수정',
                  onTap: () {
                    // TODO: Edit profile
                  },
                ),
                _SettingsTile(
                  icon: Icons.lock_outline,
                  title: '비밀번호 변경',
                  onTap: () {
                    // TODO: Change password
                  },
                ),
                _SettingsTile(
                  icon: Icons.link,
                  title: '연결된 계정',
                  subtitle: 'Google, Apple',
                  onTap: () {
                    // TODO: Linked accounts
                  },
                ),
              ],
            ),

            // Notifications Section
            _SectionTitle(title: '알림'),
            _SettingsGroup(
              children: [
                _SettingsSwitch(
                  icon: Icons.notifications_outlined,
                  title: '푸시 알림',
                  value: _pushNotifications,
                  onChanged: (value) => setState(() => _pushNotifications = value),
                ),
                _SettingsSwitch(
                  icon: Icons.email_outlined,
                  title: '이메일 알림',
                  value: _emailNotifications,
                  onChanged: (value) => setState(() => _emailNotifications = value),
                ),
              ],
            ),

            // Display Section
            _SectionTitle(title: '표시'),
            _SettingsGroup(
              children: [
                _SettingsSwitch(
                  icon: Icons.dark_mode_outlined,
                  title: '다크 모드',
                  value: _darkMode,
                  onChanged: (value) => setState(() => _darkMode = value),
                ),
                _SettingsDropdown(
                  icon: Icons.straighten,
                  title: '수심 단위',
                  value: _depthUnit,
                  options: const ['m', 'ft'],
                  onChanged: (value) => setState(() => _depthUnit = value),
                ),
                _SettingsDropdown(
                  icon: Icons.thermostat_outlined,
                  title: '온도 단위',
                  value: _tempUnit,
                  options: const ['°C', '°F'],
                  onChanged: (value) => setState(() => _tempUnit = value),
                ),
              ],
            ),

            // Data Section
            _SectionTitle(title: '데이터'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.cloud_download_outlined,
                  title: '데이터 백업',
                  subtitle: '마지막 백업: 없음',
                  onTap: () {
                    // TODO: Backup data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('백업 기능 준비 중')),
                    );
                  },
                ),
                _SettingsTile(
                  icon: Icons.cloud_upload_outlined,
                  title: '데이터 복원',
                  onTap: () {
                    // TODO: Restore data
                  },
                ),
                _SettingsTile(
                  icon: Icons.file_download_outlined,
                  title: '데이터 내보내기',
                  subtitle: 'CSV, JSON 형식',
                  onTap: () {
                    // TODO: Export data
                  },
                ),
              ],
            ),

            // Support Section
            _SectionTitle(title: '지원'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: '도움말',
                  onTap: () {
                    // TODO: Help center
                  },
                ),
                _SettingsTile(
                  icon: Icons.feedback_outlined,
                  title: '피드백 보내기',
                  onTap: () {
                    // TODO: Send feedback
                  },
                ),
                _SettingsTile(
                  icon: Icons.star_outline,
                  title: '앱 평가하기',
                  onTap: () {
                    // TODO: Rate app
                  },
                ),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: '이용약관',
                  onTap: () {
                    // TODO: Terms of service
                  },
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: '개인정보 처리방침',
                  onTap: () {
                    // TODO: Privacy policy
                  },
                ),
              ],
            ),

            // Danger Zone
            _SectionTitle(title: '계정 관리'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.logout,
                  title: '로그아웃',
                  iconColor: AppColors.warning,
                  titleColor: AppColors.warning,
                  onTap: () => _showLogoutDialog(context),
                ),
                _SettingsTile(
                  icon: Icons.delete_forever,
                  title: '계정 삭제',
                  iconColor: AppColors.error,
                  titleColor: AppColors.error,
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ],
            ),

            // App Info
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'BlueNexus',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '버전 1.0.0',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).signOut();
              if (mounted) {
                context.go(AppRoutes.login);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 삭제'),
        content: const Text(
          '계정을 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없으며, 모든 데이터가 영구적으로 삭제됩니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete account
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('계정 삭제 기능 준비 중')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.grey500,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index < children.length - 1)
                Divider(
                  height: 1,
                  indent: 56,
                  color: AppColors.grey200,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.grey600),
      title: Text(
        title,
        style: TextStyle(color: titleColor),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey400),
      onTap: onTap,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey600),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.deepOceanBlue,
      ),
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _SettingsDropdown({
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey600),
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}
