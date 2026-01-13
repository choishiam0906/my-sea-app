import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';

class CrewDetailPage extends ConsumerWidget {
  final String crewId;

  const CrewDetailPage({super.key, required this.crewId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('크루 상세'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.oceanGradient,
                ),
                child: Center(
                  child: Icon(
                    Icons.groups,
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
                  // TODO: Share crew
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  // TODO: Handle menu actions
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'report',
                    child: Text('신고하기'),
                  ),
                ],
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Crew Info Card
                _CrewInfoCard(),
                const SizedBox(height: 16),

                // Stats
                _CrewStatsCard(),
                const SizedBox(height: 16),

                // Members Section
                _SectionHeader(title: '멤버', actionText: '전체보기'),
                const SizedBox(height: 12),
                _MembersList(),
                const SizedBox(height: 24),

                // Recent Activity
                _SectionHeader(title: '최근 활동'),
                const SizedBox(height: 12),
                _RecentActivityCard(),
                const SizedBox(height: 24),

                // Badges Section
                _SectionHeader(title: '크루 배지'),
                const SizedBox(height: 12),
                _BadgesSection(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('가입 신청이 전송되었습니다')),
            );
          },
          child: const Text('크루 가입하기'),
        ),
      ),
    );
  }
}

class _CrewInfoCard extends StatelessWidget {
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
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.crewSilver.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.groups,
                  color: AppColors.crewSilver,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '제주 프리다이빙 크루',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.crewSilver,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Silver',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.grey500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '제주도',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '제주에서 함께 프리다이빙하는 크루입니다. 매주 주말에 함께 다이빙하고 있어요!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.grey500),
              const SizedBox(width: 4),
              Text(
                '2024년 3월 창설',
                style: TextStyle(fontSize: 13, color: AppColors.grey500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CrewStatsCard extends StatelessWidget {
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
          _StatItem(label: '멤버', value: '23'),
          Container(height: 40, width: 1, color: AppColors.white.withOpacity(0.3)),
          _StatItem(label: '총 다이빙', value: '156'),
          Container(height: 40, width: 1, color: AppColors.white.withOpacity(0.3)),
          _StatItem(label: '나뭇잎 포인트', value: '2,450'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;

  const _SectionHeader({required this.title, this.actionText});

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
            onPressed: () {},
            child: Text(actionText!),
          ),
      ],
    );
  }
}

class _MembersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final members = [
      {'name': '김다이버', 'role': '크루장', 'dives': 45},
      {'name': '이프리', 'role': '운영진', 'dives': 32},
      {'name': '박바다', 'role': '멤버', 'dives': 28},
      {'name': '최스쿠버', 'role': '멤버', 'dives': 21},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
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
        children: members.map((member) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.oceanBlue.withOpacity(0.2),
                  child: Text(
                    (member['name'] as String).substring(0, 1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.oceanBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${member['dives']}회 다이빙',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: member['role'] == '크루장'
                        ? AppColors.warning.withOpacity(0.1)
                        : AppColors.grey100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    member['role'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: member['role'] == '크루장'
                          ? AppColors.warning
                          : AppColors.grey600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.timeline_outlined,
            size: 40,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 12),
          Text(
            '최근 활동이 없습니다',
            style: TextStyle(
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final badges = [
      {'name': '첫 크루 다이빙', 'icon': Icons.scuba_diving, 'earned': true},
      {'name': '환경 지킴이', 'icon': Icons.eco, 'earned': true},
      {'name': '10회 달성', 'icon': Icons.stars, 'earned': false},
      {'name': '야간 다이빙', 'icon': Icons.nightlight, 'earned': false},
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
                        ? AppColors.deepOceanBlue.withOpacity(0.1)
                        : AppColors.grey200,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: earned ? AppColors.deepOceanBlue : AppColors.grey300,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    badge['icon'] as IconData,
                    color: earned ? AppColors.deepOceanBlue : AppColors.grey400,
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
