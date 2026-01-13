import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

class CrewPage extends ConsumerWidget {
  const CrewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                pinned: true,
                title: const Text('크루'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person_search),
                    onPressed: () => context.push(AppRoutes.buddyFinder),
                    tooltip: '버디 찾기',
                  ),
                ],
                bottom: TabBar(
                  labelColor: AppColors.deepOceanBlue,
                  unselectedLabelColor: AppColors.grey500,
                  indicatorColor: AppColors.deepOceanBlue,
                  tabs: const [
                    Tab(text: '내 크루'),
                    Tab(text: '크루 찾기'),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              children: [
                _MyCrewsTab(),
                _DiscoverCrewsTab(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showCreateCrewDialog(context),
          backgroundColor: AppColors.deepOceanBlue,
          icon: const Icon(Icons.add, color: AppColors.white),
          label: const Text(
            '크루 만들기',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ),
    );
  }

  void _showCreateCrewDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '새 크루 만들기',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '크루 이름',
                hintText: '예: 제주 다이빙 크루',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '소개',
                hintText: '크루를 소개해주세요',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.grey500),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '크루는 5명 이상이면 Bronze, 20명 이상이면 Silver, 50명 이상이면 Gold 티어가 됩니다.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // TODO: Create crew
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('크루가 생성되었습니다')),
                );
              },
              child: const Text('크루 만들기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyCrewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 80,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '아직 가입한 크루가 없어요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '크루를 만들거나 다른 크루에 가입해보세요',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.buddyFinder),
            icon: const Icon(Icons.search),
            label: const Text('크루 찾아보기'),
          ),
        ],
      ),
    );
  }
}

class _DiscoverCrewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data
    final sampleCrews = [
      _SampleCrew(
        name: '제주 프리다이빙 크루',
        members: 23,
        tier: 'Silver',
        region: '제주도',
        description: '제주에서 함께 프리다이빙하는 크루입니다.',
      ),
      _SampleCrew(
        name: '부산 스쿠버',
        members: 15,
        tier: 'Bronze',
        region: '부산',
        description: '부산 해운대를 중심으로 활동하는 스쿠버 다이빙 크루입니다.',
      ),
      _SampleCrew(
        name: '서울 수중사진 동호회',
        members: 52,
        tier: 'Gold',
        region: '서울/경기',
        description: '수중 사진 촬영을 즐기는 다이버들의 모임',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sampleCrews.length,
      itemBuilder: (context, index) {
        final crew = sampleCrews[index];
        return _CrewCard(crew: crew);
      },
    );
  }
}

class _SampleCrew {
  final String name;
  final int members;
  final String tier;
  final String region;
  final String description;

  _SampleCrew({
    required this.name,
    required this.members,
    required this.tier,
    required this.region,
    required this.description,
  });
}

class _CrewCard extends StatelessWidget {
  final _SampleCrew crew;

  const _CrewCard({required this.crew});

  Color get tierColor {
    switch (crew.tier) {
      case 'Gold':
        return AppColors.crewGold;
      case 'Silver':
        return AppColors.crewSilver;
      default:
        return AppColors.crewBronze;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => context.push('${AppRoutes.crew}/detail'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: tierColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.groups,
                      color: tierColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                crew.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: tierColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                crew.tier,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.grey500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              crew.region,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.grey500,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.people_outline,
                              size: 14,
                              color: AppColors.grey500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${crew.members}명',
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
              const SizedBox(height: 12),
              Text(
                crew.description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Join crew
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('가입 신청이 전송되었습니다')),
                      );
                    },
                    child: const Text('가입 신청'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
