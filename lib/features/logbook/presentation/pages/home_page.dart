import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

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
              title: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: AppColors.oceanGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.water,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'BlueNexus',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // TODO: Notifications
                  },
                ),
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
                  // Welcome Section
                  currentUser.when(
                    data: (user) => _WelcomeCard(
                      nickname: user?.nickname ?? 'Diver',
                      leafPoints: user?.leafPoints ?? 0,
                      totalDives: user?.totalDives ?? 0,
                    ),
                    loading: () => const _WelcomeCardSkeleton(),
                    error: (_, __) => const _WelcomeCard(
                      nickname: 'Diver',
                      leafPoints: 0,
                      totalDives: 0,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions
                  const Text(
                    '빠른 실행',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _QuickActionsGrid(),
                  const SizedBox(height: 24),

                  // Recent Activity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '최근 다이빙',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.dives),
                        child: const Text('전체보기'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _RecentDivesSection(),
                  const SizedBox(height: 24),

                  // Eco Rewards Banner
                  _EcoRewardsBanner(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String nickname;
  final int leafPoints;
  final int totalDives;

  const _WelcomeCard({
    required this.nickname,
    required this.leafPoints,
    required this.totalDives,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '안녕하세요, $nickname님!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '오늘도 안전한 다이빙 하세요',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _StatItem(
                icon: Icons.eco,
                label: '나뭇잎 포인트',
                value: '$leafPoints',
                color: AppColors.ecoGreen,
              ),
              const SizedBox(width: 24),
              _StatItem(
                icon: Icons.scuba_diving,
                label: '총 다이빙',
                value: '$totalDives회',
                color: AppColors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.white.withOpacity(0.7),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WelcomeCardSkeleton extends StatelessWidget {
  const _WelcomeCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.add_circle,
        label: '다이브 기록',
        color: AppColors.deepOceanBlue,
        onTap: () => context.push('${AppRoutes.dives}/add'),
      ),
      _QuickAction(
        icon: Icons.camera_alt,
        label: '물고기 AI',
        color: AppColors.oceanBlue,
        onTap: () => context.push(AppRoutes.fishId),
      ),
      _QuickAction(
        icon: Icons.eco,
        label: '쓰레기 인증',
        color: AppColors.ecoGreen,
        onTap: () => context.push('${AppRoutes.eco}/submit'),
      ),
      _QuickAction(
        icon: Icons.card_membership,
        label: '자격증',
        color: AppColors.warning,
        onTap: () => context.push(AppRoutes.certWallet),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) => actions[index],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentDivesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Implement with real data
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.scuba_diving,
            size: 48,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 12),
          Text(
            '아직 기록된 다이빙이 없어요',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.push('${AppRoutes.dives}/add'),
            child: const Text('첫 다이빙 기록하기'),
          ),
        ],
      ),
    );
  }
}

class _EcoRewardsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.ecoGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '굿다이빙 챌린지',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '바다 쓰레기를 수거하고\n나뭇잎 포인트를 받으세요!',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.push('${AppRoutes.eco}/submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.darkGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('참여하기'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.eco,
              size: 48,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
