import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../shared/widgets/ocean_widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

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
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.oceanBlue, AppColors.skyBlue],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.oceanBlue.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.water_drop,
                              size: 24,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'BlueNexus',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: AppColors.grey800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                '나만의 바다 이야기',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _AppBarIconButton(
                            icon: Icons.notifications_outlined,
                            onTap: () {},
                          ),
                          const SizedBox(width: 8),
                          _AppBarIconButton(
                            icon: Icons.settings_outlined,
                            onTap: () => context.push(AppRoutes.settings),
                          ),
                        ],
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
                    // Welcome Card with Character
                    currentUser.when(
                      data: (user) => _WelcomeCard(
                        nickname: user?.nickname ?? '다이버',
                        leafPoints: user?.leafPoints ?? 0,
                        totalDives: user?.totalDives ?? 0,
                      ),
                      loading: () => const _WelcomeCardSkeleton(),
                      error: (_, __) => const _WelcomeCard(
                        nickname: '다이버',
                        leafPoints: 0,
                        totalDives: 0,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    Row(
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
                        const Text(
                          '빠른 실행',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _QuickActionsGrid(),
                    const SizedBox(height: 28),

                    // Recent Activity Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                            const Text(
                              '최근 다이빙',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.grey800,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.dives),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.oceanBlue,
                          ),
                          child: const Row(
                            children: [
                              Text('전체보기'),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _RecentDivesSection(),
                    const SizedBox(height: 28),

                    // Eco Challenge Banner
                    _EcoChallengeBanner(),
                    const SizedBox(height: 20),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Character Avatar
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppColors.softOceanGradient,
                  borderRadius: BorderRadius.circular(24),
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
                child: const Center(
                  child: Text(
                    '🦭',
                    style: TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.paleBlue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        '오늘도 안전한 다이빙!',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.oceanBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '안녕하세요, $nickname님!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.grey800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.softOceanGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.eco,
                    label: '나뭇잎 포인트',
                    value: '$leafPoints',
                    iconColor: AppColors.ecoGreen,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.oceanBlue.withOpacity(0.2),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.scuba_diving,
                    label: '총 다이빙',
                    value: '$totalDives회',
                    iconColor: AppColors.oceanBlue,
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

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.grey800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey500,
            fontWeight: FontWeight.w500,
          ),
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
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickActionItem(
        icon: Icons.add_circle_outline,
        label: '다이브\n기록',
        gradient: const LinearGradient(
          colors: [AppColors.oceanBlue, AppColors.skyBlue],
        ),
        onTap: () => context.push('${AppRoutes.dives}/add'),
      ),
      _QuickActionItem(
        icon: Icons.camera_alt_outlined,
        label: '물고기\nAI',
        gradient: const LinearGradient(
          colors: [Color(0xFF67E8F9), Color(0xFF7DD3FC)],
        ),
        onTap: () => context.push(AppRoutes.fishId),
      ),
      _QuickActionItem(
        icon: Icons.eco_outlined,
        label: '쓰레기\n인증',
        gradient: const LinearGradient(
          colors: [AppColors.lightGreen, AppColors.ecoGreen],
        ),
        onTap: () => context.push('${AppRoutes.eco}/submit'),
      ),
      _QuickActionItem(
        icon: Icons.card_membership_outlined,
        label: '자격증\n지갑',
        gradient: const LinearGradient(
          colors: [AppColors.peach, AppColors.coral],
        ),
        onTap: () => context.push(AppRoutes.certWallet),
      ),
    ];

    return Row(
      children: actions
          .map((action) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: actions.indexOf(action) < 3 ? 12 : 0,
                  ),
                  child: action,
                ),
              ))
          .toList(),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.oceanBlue.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.oceanBlue.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: AppColors.white, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentDivesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.softOceanGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Text(
                '🐠',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '아직 기록된 다이빙이 없어요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 다이빙을 기록하고\n나만의 바다 이야기를 시작해보세요!',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.grey500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.push('${AppRoutes.dives}/add'),
            icon: const Icon(Icons.add),
            label: const Text('첫 다이빙 기록하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.oceanBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EcoChallengeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.ecoGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.ecoGreen.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    '굿다이빙 챌린지',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '바다를 지키며\n포인트를 받으세요!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push('${AppRoutes.eco}/submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.darkGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '참여하기',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Text(
                '🌊',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
