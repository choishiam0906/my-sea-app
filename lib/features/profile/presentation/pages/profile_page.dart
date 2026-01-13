import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              title: const Text('프로필'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push(AppRoutes.settings),
                ),
              ],
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile Header
                  currentUser.when(
                    data: (user) => _ProfileHeader(
                      nickname: user?.nickname ?? 'Diver',
                      email: user?.email ?? '',
                      certLevel: user?.certLevel ?? 'Open Water',
                      profileImageUrl: user?.profileImageUrl,
                    ),
                    loading: () => const _ProfileHeaderSkeleton(),
                    error: (_, __) => const _ProfileHeader(
                      nickname: 'Diver',
                      email: '',
                      certLevel: 'Open Water',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats Cards
                  currentUser.when(
                    data: (user) => _StatsSection(
                      totalDives: user?.totalDives ?? 0,
                      leafPoints: user?.leafPoints ?? 0,
                      speciesCount: user?.speciesCollected.length ?? 0,
                      badgeCount: user?.badges.length ?? 0,
                    ),
                    loading: () => const _StatsSectionSkeleton(),
                    error: (_, __) => const _StatsSection(
                      totalDives: 0,
                      leafPoints: 0,
                      speciesCount: 0,
                      badgeCount: 0,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Badges Section
                  _SectionHeader(
                    title: '배지',
                    actionText: '전체보기',
                    onAction: () {
                      // TODO: Navigate to badges page
                    },
                  ),
                  const SizedBox(height: 12),
                  _BadgesPreview(),
                  const SizedBox(height: 24),

                  // Menu Items
                  _MenuSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String nickname;
  final String email;
  final String certLevel;
  final String? profileImageUrl;

  const _ProfileHeader({
    required this.nickname,
    required this.email,
    required this.certLevel,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.oceanGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOceanBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: AppColors.white, width: 3),
            ),
            child: profileImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      profileImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.white,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.white,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickname,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.card_membership,
                        size: 14,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        certLevel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.white),
            onPressed: () {
              // TODO: Edit profile
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderSkeleton extends StatelessWidget {
  const _ProfileHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final int totalDives;
  final int leafPoints;
  final int speciesCount;
  final int badgeCount;

  const _StatsSection({
    required this.totalDives,
    required this.leafPoints,
    required this.speciesCount,
    required this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.scuba_diving,
            label: '다이빙',
            value: '$totalDives',
            color: AppColors.oceanBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.eco,
            label: '나뭇잎',
            value: '$leafPoints',
            color: AppColors.ecoGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.catching_pokemon,
            label: '도감',
            value: '$speciesCount',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.military_tech,
            label: '배지',
            value: '$badgeCount',
            color: AppColors.crewGold,
          ),
        ),
      ],
    );
  }
}

class _StatsSectionSkeleton extends StatelessWidget {
  const _StatsSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        return Expanded(
          child: Container(
            height: 80,
            margin: EdgeInsets.only(right: index < 3 ? 12 : 0),
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionText!),
          ),
      ],
    );
  }
}

class _BadgesPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample badges data
    final badges = [
      {'name': '첫 다이빙', 'icon': Icons.pool, 'earned': true},
      {'name': '환경 지킴이', 'icon': Icons.eco, 'earned': true},
      {'name': '야간 탐험가', 'icon': Icons.nightlight, 'earned': false},
      {'name': '딥다이버', 'icon': Icons.arrow_downward, 'earned': false},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          final earned = badge['earned'] as bool;

          return Container(
            width: 80,
            margin: EdgeInsets.only(right: index < badges.length - 1 ? 12 : 0),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: earned
                        ? AppColors.crewGold.withOpacity(0.2)
                        : AppColors.grey200,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: earned ? AppColors.crewGold : AppColors.grey300,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    badge['icon'] as IconData,
                    color: earned ? AppColors.crewGold : AppColors.grey400,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  badge['name'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: earned ? AppColors.grey700 : AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.card_membership,
            title: '자격증 지갑',
            onTap: () => context.push(AppRoutes.certWallet),
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.history,
            title: '활동 기록',
            onTap: () {
              // TODO: Activity history
            },
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.notifications_outlined,
            title: '알림 설정',
            onTap: () {
              // TODO: Notification settings
            },
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.help_outline,
            title: '도움말',
            onTap: () {
              // TODO: Help
            },
          ),
          const Divider(height: 1),
          _MenuItem(
            icon: Icons.info_outline,
            title: '앱 정보',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'BlueNexus',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 BlueNexus. All rights reserved.',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey600),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey400),
      onTap: onTap,
    );
  }
}
