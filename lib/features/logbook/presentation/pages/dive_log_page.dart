import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

class DiveLogPage extends ConsumerWidget {
  const DiveLogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              title: const Text('다이브 로그'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // TODO: Filter options
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // TODO: Search
                  },
                ),
              ],
            ),

            // Stats Summary
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _DiveStatsSummary(),
              ),
            ),

            // Dive List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // TODO: Replace with real data
                    return _EmptyDiveList();
                  },
                  childCount: 1,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('${AppRoutes.dives}/add'),
        backgroundColor: AppColors.deepOceanBlue,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text(
          '다이브 기록',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}

class _DiveStatsSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.oceanGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(label: '총 다이빙', value: '0'),
          Container(
            height: 40,
            width: 1,
            color: AppColors.white.withOpacity(0.3),
          ),
          _StatColumn(label: '총 시간', value: '0분'),
          Container(
            height: 40,
            width: 1,
            color: AppColors.white.withOpacity(0.3),
          ),
          _StatColumn(label: '최대 수심', value: '0m'),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _EmptyDiveList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.scuba_diving,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '아직 기록된 다이빙이 없어요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 다이빙을 기록해보세요!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.push('${AppRoutes.dives}/add'),
            icon: const Icon(Icons.add),
            label: const Text('다이브 기록하기'),
          ),
        ],
      ),
    );
  }
}
