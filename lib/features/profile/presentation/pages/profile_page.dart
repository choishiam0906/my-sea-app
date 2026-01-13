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
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.skyGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '프로필',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.grey800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      _AppBarIconButton(
                        icon: Icons.settings_outlined,
                        onTap: () => context.push(AppRoutes.settings),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Profile Header Card
                    currentUser.when(
                      data: (user) => _ProfileHeader(
                        nickname: user?.nickname ?? '다이버',
                        email: user?.email ?? '',
                        certLevel: user?.certLevel ?? 'Open Water',
                        profileImageUrl: user?.profileImageUrl,
                      ),
                      loading: () => const _ProfileHeaderSkeleton(),
                      error: (_, __) => const _ProfileHeader(
                        nickname: '다이버',
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
                    _SectionHeader(title: '배지'),
                    const SizedBox(height: 12),
                    _BadgesPreview(),
                    const SizedBox(height: 24),

                    // Menu Items
                    _MenuSection(),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 22, color: AppColors.grey700),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: AppColors.softOceanGradient,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.oceanBlue.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: profileImageUrl != null
                      ? Image.network(
                          profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text(
                              '🐬',
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text(
                            '🐬',
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.oceanBlue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickname,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.grey800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                if (email.isNotEmpty)
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grey500,
                    ),
                  ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.softOceanGradient,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.card_membership,
                        size: 16,
                        color: AppColors.oceanBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        certLevel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.oceanBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(28),
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
            icon: '🤿',
            label: '다이빙',
            value: '$totalDives',
            gradient: const LinearGradient(
              colors: [AppColors.lightBlue, AppColors.skyBlue],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: '🌿',
            label: '나뭇잎',
            value: '$leafPoints',
            gradient: const LinearGradient(
              colors: [AppColors.lightGreen, AppColors.ecoGreen],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: '🐠',
            label: '도감',
            value: '$speciesCount',
            gradient: const LinearGradient(
              colors: [AppColors.peach, AppColors.coral],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: '🏅',
            label: '배지',
            value: '$badgeCount',
            gradient: LinearGradient(
              colors: [Color(0xFFFFE082), Color(0xFFFFD54F)],
            ),
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
            height: 100,
            margin: EdgeInsets.only(right: index < 3 ? 12 : 0),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Gradient gradient;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.grey800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.grey500,
            ),
          ),
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
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.oceanBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.grey800,
          ),
        ),
      ],
    );
  }
}

class _BadgesPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final badges = [
      {'name': '첫 다이빙', 'icon': '🏊', 'earned': true},
      {'name': '환경 지킴이', 'icon': '🌊', 'earned': true},
      {'name': '야간 탐험가', 'icon': '🌙', 'earned': false},
      {'name': '딥다이버', 'icon': '⬇️', 'earned': false},
      {'name': '사진작가', 'icon': '📷', 'earned': false},
    ];

    return Container(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          final earned = badge['earned'] as bool;

          return Container(
            width: 80,
            margin: EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: earned
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: earned
                          ? AppColors.warning
                          : AppColors.grey300,
                      width: 2,
                    ),
                    boxShadow: earned
                        ? [
                            BoxShadow(
                              color: AppColors.warning.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      badge['icon'] as String,
                      style: TextStyle(
                        fontSize: 28,
                        color: earned ? null : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  badge['name'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: earned ? AppColors.grey700 : AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _MenuItem(
            icon: '💳',
            title: '자격증 지갑',
            onTap: () => context.push(AppRoutes.certWallet),
          ),
          _MenuDivider(),
          _MenuItem(
            icon: '📊',
            title: '활동 기록',
            onTap: () {},
          ),
          _MenuDivider(),
          _MenuItem(
            icon: '🔔',
            title: '알림 설정',
            onTap: () {},
          ),
          _MenuDivider(),
          _MenuItem(
            icon: '❓',
            title: '도움말',
            onTap: () {},
          ),
          _MenuDivider(),
          _MenuItem(
            icon: 'ℹ️',
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
  final String icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey700,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.grey400,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.grey200.withOpacity(0.5),
    );
  }
}
