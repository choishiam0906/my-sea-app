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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFFC8E6C9),
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.6],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                title: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ecoGreen.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🌿', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '굿다이빙',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        Text(
                          '바다를 깨끗하게!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF66BB6A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                    const SizedBox(height: 20),

                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: _ActionCard(
                            emoji: '📸',
                            title: '쓰레기 인증',
                            subtitle: '수거한 쓰레기 촬영하기',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                            ),
                            onTap: () => context.push('${AppRoutes.eco}/submit'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionCard(
                            emoji: '🎁',
                            title: '리워드 샵',
                            subtitle: '포인트 교환하기',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('곧 오픈해요! 🎉'),
                                  backgroundColor: AppColors.warning,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
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

                    // Recent Activity Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🏄', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            const Text(
                              '나의 활동',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF66BB6A),
                          ),
                          child: const Text('전체보기'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _EmptyActivityCard(),
                    const SizedBox(height: 24),

                    // Leaderboard Preview
                    _LeaderboardPreview(),
                    const SizedBox(height: 24),
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

class _LeafPointsCard extends StatelessWidget {
  final int leafPoints;

  const _LeafPointsCard({required this.leafPoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF43A047),
            Color(0xFF66BB6A),
            Color(0xFF81C784),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF43A047).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🍃', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 6),
                        Text(
                          '나뭇잎 포인트',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$leafPoints',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8, left: 4),
                        child: Text(
                          'P',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // 귀여운 지구 캐릭터
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🌍', style: TextStyle(fontSize: 42)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('🗓️', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      '이번 달 수거 횟수',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '0회',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14,
                    ),
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
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF66BB6A),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
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
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
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
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('🐢', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '굿다이빙 챌린지',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  Text(
                    '이렇게 참여해요!',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF66BB6A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _StepItem(
            emoji: '🤿',
            number: '1',
            title: '다이빙 중 쓰레기 수거',
            subtitle: '바다에서 쓰레기를 발견하면 수거해요',
          ),
          _StepItem(
            emoji: '📱',
            number: '2',
            title: 'AI 인증 촬영',
            subtitle: '수거한 쓰레기를 촬영하면 AI가 자동 분류해요',
          ),
          _StepItem(
            emoji: '🌱',
            number: '3',
            title: '나뭇잎 포인트 획득',
            subtitle: '쓰레기 종류별로 포인트가 적립돼요',
          ),
          _StepItem(
            emoji: '🎁',
            number: '4',
            title: '리워드 교환',
            subtitle: '포인트로 다양한 혜택을 받아요',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String emoji;
  final String number;
  final String title;
  final String subtitle;
  final bool isLast;

  const _StepItem({
    required this.emoji,
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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF43A047).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF66BB6A).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
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
    );
  }
}

class _EmptyActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🐙', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '아직 활동 기록이 없어요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 굿다이빙 챌린지에 참여해보세요!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF43A047).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '시작하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('🏆', style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이번 달 리더보드',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        '상위 다이버를 확인해요',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFFFB300),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 빈 리더보드 상태
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RankBadge(rank: 2, emoji: '🥈', size: 50),
                    const SizedBox(width: 8),
                    _RankBadge(rank: 1, emoji: '🥇', size: 65),
                    const SizedBox(width: 8),
                    _RankBadge(rank: 3, emoji: '🥉', size: 50),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '아직 참가자가 없어요',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '첫 번째 우승자가 되어보세요!',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFFFB300),
                    fontWeight: FontWeight.w500,
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

class _RankBadge extends StatelessWidget {
  final int rank;
  final String emoji;
  final double size;

  const _RankBadge({
    required this.rank,
    required this.emoji,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFFE082),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}
