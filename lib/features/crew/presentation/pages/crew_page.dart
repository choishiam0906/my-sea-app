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
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE3F2FD),
                Color(0xFFBBDEFB),
                Colors.white,
              ],
              stops: [0.0, 0.3, 0.6],
            ),
          ),
          child: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  pinned: true,
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
                              color: AppColors.primaryBlue.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('🐋', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '크루',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepOceanBlue,
                            ),
                          ),
                          Text(
                            '함께 다이빙해요!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64B5F6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Text('🔍', style: TextStyle(fontSize: 20)),
                        onPressed: () => context.push(AppRoutes.buddyFinder),
                        tooltip: '버디 찾기',
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: AppColors.grey500,
                        indicator: BoxDecoration(
                          gradient: AppColors.oceanGradient,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        tabs: const [
                          Tab(text: '내 크루'),
                          Tab(text: '크루 찾기'),
                        ],
                      ),
                    ),
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
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: AppColors.oceanGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => _showCreateCrewDialog(context),
            backgroundColor: Colors.transparent,
            elevation: 0,
            icon: const Text('➕', style: TextStyle(fontSize: 18)),
            label: const Text(
              '크루 만들기',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
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
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text('🚀', style: TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '새 크루 만들기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepOceanBlue,
                      ),
                    ),
                    Text(
                      '함께 다이빙할 친구를 모아봐요!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64B5F6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),
            _buildInputField(
              controller: nameController,
              label: '크루 이름',
              hint: '예: 제주 다이빙 크루',
              icon: '🏷️',
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: descController,
              label: '소개',
              hint: '크루를 소개해주세요',
              icon: '📝',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '5명 이상 Bronze, 20명 이상 Silver, 50명 이상 Gold 티어가 돼요!',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.oceanGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('크루가 생성되었어요! 🎉'),
                      backgroundColor: AppColors.primaryBlue,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '크루 만들기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('🐳', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.grey400),
            filled: true,
            fillColor: AppColors.grey100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _MyCrewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🐡', style: TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '아직 가입한 크루가 없어요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.deepOceanBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '크루를 만들거나 다른 크루에 가입해보세요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryBlue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextButton.icon(
                onPressed: () => context.push(AppRoutes.buddyFinder),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                icon: const Text('🔍', style: TextStyle(fontSize: 18)),
                label: const Text(
                  '크루 찾아보기',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverCrewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sampleCrews = [
      _SampleCrew(
        name: '제주 프리다이빙 크루',
        members: 23,
        tier: 'Silver',
        region: '제주도',
        description: '제주에서 함께 프리다이빙하는 크루예요. 매주 토요일 정기 다이빙!',
        emoji: '🌺',
      ),
      _SampleCrew(
        name: '부산 스쿠버',
        members: 15,
        tier: 'Bronze',
        region: '부산',
        description: '부산 해운대를 중심으로 활동하는 스쿠버 다이빙 크루예요.',
        emoji: '🦑',
      ),
      _SampleCrew(
        name: '서울 수중사진 동호회',
        members: 52,
        tier: 'Gold',
        region: '서울/경기',
        description: '수중 사진 촬영을 즐기는 다이버들의 모임이에요!',
        emoji: '📸',
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 70, 16, 100),
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
  final String emoji;

  _SampleCrew({
    required this.name,
    required this.members,
    required this.tier,
    required this.region,
    required this.description,
    required this.emoji,
  });
}

class _CrewCard extends StatelessWidget {
  final _SampleCrew crew;

  const _CrewCard({required this.crew});

  Color get tierColor {
    switch (crew.tier) {
      case 'Gold':
        return const Color(0xFFFFB300);
      case 'Silver':
        return const Color(0xFF90A4AE);
      default:
        return const Color(0xFFCD7F32);
    }
  }

  String get tierEmoji {
    switch (crew.tier) {
      case 'Gold':
        return '🥇';
      case 'Silver':
        return '🥈';
      default:
        return '🥉';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => context.push('${AppRoutes.crew}/detail'),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            tierColor.withOpacity(0.2),
                            tierColor.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: tierColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          crew.emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
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
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepOceanBlue,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: tierColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: tierColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      tierEmoji,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      crew.tier,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: tierColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text('📍', style: TextStyle(fontSize: 13)),
                              const SizedBox(width: 4),
                              Text(
                                crew.region,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.grey600,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Text('👥', style: TextStyle(fontSize: 13)),
                              const SizedBox(width: 4),
                              Text(
                                '${crew.members}명',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.grey600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  crew.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey600,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryBlue,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('가입 신청을 보냈어요! 🙌'),
                                backgroundColor: AppColors.primaryBlue,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            '가입 신청하기',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
