import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../providers/auth_provider.dart';

class EcoPage extends ConsumerWidget {
  const EcoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            const SliverAppBar(
              floating: true,
              title: Text('굿다이빙'),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Leaf Points Card
                  currentUser.when(
                    data: (user) => _LeafPointsCard(
                      leafPoints: user?.leafPoints ?? 0,
                    ),
                    loading: () => const _LeafPointsCardSkeleton(),
                    error: (_, __) => const _LeafPointsCard(leafPoints: 0),
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.camera_alt,
                          title: '쓰레기 인증',
                          subtitle: '수거한 쓰레기 촬영',
                          color: AppColors.ecoGreen,
                          onTap: () => context.push('${AppRoutes.eco}/submit'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.card_giftcard,
                          title: '리워드 샵',
                          subtitle: '포인트 교환',
                          color: AppColors.warning,
                          onTap: () {
                            // TODO: Rewards shop
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('리워드 샵 준비 중')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // How It Works
                  _HowItWorksSection(),
                  const SizedBox(height: 24),

                  // Recent Activity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '나의 활동',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: View all activities
                        },
                        child: const Text('전체보기'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _EmptyActivityCard(),
                  const SizedBox(height: 24),

                  // Leaderboard Preview
                  _LeaderboardPreview(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeafPointsCard extends StatelessWidget {
  final int leafPoints;

  const _LeafPointsCard({required this.leafPoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.ecoGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.ecoGreen.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.eco, color: AppColors.white, size: 28),
                      const SizedBox(width: 8),
                      const Text(
                        '나뭇잎 포인트',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$leafPoints',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.park,
                  size: 48,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '이번 달 수거 횟수',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
                const Text(
                  '0회',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
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

class _LeafPointsCardSkeleton extends StatelessWidget {
  const _LeafPointsCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '굿다이빙 챌린지',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _StepItem(
            number: '1',
            title: '다이빙 중 쓰레기 수거',
            subtitle: '바다에서 쓰레기를 발견하면 수거하세요',
          ),
          _StepItem(
            number: '2',
            title: 'AI 인증 촬영',
            subtitle: '수거한 쓰레기를 촬영하면 AI가 자동 분류해요',
          ),
          _StepItem(
            number: '3',
            title: '나뭇잎 포인트 획득',
            subtitle: '쓰레기 종류별로 포인트가 적립돼요',
          ),
          _StepItem(
            number: '4',
            title: '리워드 교환',
            subtitle: '포인트로 다양한 혜택을 받으세요',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final bool isLast;

  const _StepItem({
    required this.number,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.ecoGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.ecoGreen.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.eco_outlined,
            size: 48,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 12),
          Text(
            '아직 활동 기록이 없어요',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 굿다이빙 챌린지에 참여해보세요!',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '이번 달 리더보드',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.emoji_events, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.leaderboard_outlined,
                  size: 40,
                  color: AppColors.grey400,
                ),
                const SizedBox(height: 8),
                Text(
                  '아직 참가자가 없습니다',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grey500,
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
