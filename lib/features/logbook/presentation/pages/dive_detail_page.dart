import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';

class DiveDetailPage extends ConsumerWidget {
  final String diveId;

  const DiveDetailPage({super.key, required this.diveId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with gradient
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('다이브 #$diveId'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.oceanGradient,
                ),
                child: Center(
                  child: Icon(
                    Icons.scuba_diving,
                    size: 80,
                    color: AppColors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: Share dive log
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    // TODO: Edit dive
                  } else if (value == 'delete') {
                    _showDeleteDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('수정'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('삭제', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Dive Details
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Stats
                _QuickStatsCard(),
                const SizedBox(height: 16),

                // Dive Conditions
                _SectionCard(
                  title: '다이빙 조건',
                  child: _DiveConditionsContent(),
                ),
                const SizedBox(height: 16),

                // Tank Info
                _SectionCard(
                  title: '탱크 정보',
                  child: _TankInfoContent(),
                ),
                const SizedBox(height: 16),

                // Notes
                _SectionCard(
                  title: '노트',
                  child: const Text(
                    '다이빙 노트가 없습니다.',
                    style: TextStyle(color: AppColors.grey500),
                  ),
                ),
                const SizedBox(height: 16),

                // Depth Profile Placeholder
                _SectionCard(
                  title: '수심 프로파일',
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.show_chart,
                            size: 40,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '다이브 컴퓨터 연동 시 표시됩니다',
                            style: TextStyle(
                              color: AppColors.grey500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('다이브 삭제'),
        content: const Text('이 다이브 기록을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
              // TODO: Delete dive
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

class _QuickStatsCard extends StatelessWidget {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickStatItem(icon: Icons.timer, label: '시간', value: '--분'),
          _QuickStatItem(icon: Icons.arrow_downward, label: '최대수심', value: '--m'),
          _QuickStatItem(icon: Icons.water, label: '평균수심', value: '--m'),
          _QuickStatItem(icon: Icons.thermostat, label: '수온', value: '--°C'),
        ],
      ),
    );
  }
}

class _QuickStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuickStatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.deepOceanBlue, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey500,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _DiveConditionsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(label: '다이브 사이트', value: '--'),
        _InfoRow(label: '시야', value: '--'),
        _InfoRow(label: '파도', value: '--'),
        _InfoRow(label: '해류', value: '--'),
      ],
    );
  }
}

class _TankInfoContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(label: '탱크 크기', value: '--L'),
        _InfoRow(label: '시작 압력', value: '--bar'),
        _InfoRow(label: '종료 압력', value: '--bar'),
        _InfoRow(label: '가스 타입', value: 'Air'),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.grey600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
