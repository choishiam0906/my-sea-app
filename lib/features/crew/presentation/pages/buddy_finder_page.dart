import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';

class BuddyFinderPage extends ConsumerStatefulWidget {
  const BuddyFinderPage({super.key});

  @override
  ConsumerState<BuddyFinderPage> createState() => _BuddyFinderPageState();
}

class _BuddyFinderPageState extends ConsumerState<BuddyFinderPage> {
  String _selectedRegion = '전체';
  String _selectedCertLevel = '전체';
  bool _showOnlineOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('버디 찾기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '닉네임으로 검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.grey100,
              ),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: _selectedRegion,
                  icon: Icons.location_on_outlined,
                  onTap: () => _showRegionPicker(),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: _selectedCertLevel,
                  icon: Icons.card_membership,
                  onTap: () => _showCertLevelPicker(),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('온라인만'),
                  selected: _showOnlineOnly,
                  onSelected: (value) {
                    setState(() => _showOnlineOnly = value);
                  },
                  avatar: Icon(
                    Icons.circle,
                    size: 12,
                    color: _showOnlineOnly ? AppColors.success : AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Buddy List
          Expanded(
            child: _BuddyList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreatePostDialog,
        backgroundColor: AppColors.deepOceanBlue,
        icon: const Icon(Icons.edit, color: AppColors.white),
        label: const Text(
          '버디 구하기',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              '필터',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '지역',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['전체', '제주', '부산', '서울/경기', '강원', '기타']
                  .map((region) => ChoiceChip(
                        label: Text(region),
                        selected: _selectedRegion == region,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedRegion = region);
                          }
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              '자격 레벨',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['전체', 'OW', 'AOW', 'Rescue', 'Divemaster', 'Instructor']
                  .map((level) => ChoiceChip(
                        label: Text(level),
                        selected: _selectedCertLevel == level,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCertLevel = level);
                          }
                        },
                      ))
                  .toList(),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedRegion = '전체';
                        _selectedCertLevel = '전체';
                        _showOnlineOnly = false;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('초기화'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('적용'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRegionPicker() {
    // Quick region picker
  }

  void _showCertLevelPicker() {
    // Quick cert level picker
  }

  void _showCreatePostDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
              '버디 구하기',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                hintText: '예: 제주 문섬 버디 구합니다',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: '상세 내용',
                hintText: '다이빙 날짜, 장소, 필요한 경력 등을 적어주세요',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('다이빙 날짜'),
              subtitle: Text(
                '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  // Update date
                }
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('버디 모집글이 등록되었습니다')),
                );
              },
              child: const Text('등록하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.grey600),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.grey700,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 16, color: AppColors.grey600),
          ],
        ),
      ),
    );
  }
}

class _BuddyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buddyPosts = [
      _BuddyPost(
        title: '제주 문섬 버디 구합니다',
        author: '김다이버',
        region: '제주',
        date: '2024-04-20',
        certLevel: 'AOW',
        description: '4월 20일 제주 문섬에서 함께 다이빙하실 버디 구합니다. AOW 이상 경력자 환영합니다!',
        isOnline: true,
      ),
      _BuddyPost(
        title: '부산 해운대 나이트 다이빙',
        author: '이프리',
        region: '부산',
        date: '2024-04-25',
        certLevel: 'Rescue',
        description: '4월 25일 해운대에서 나이트 다이빙 함께하실 분 구합니다. 경험자만 지원해주세요.',
        isOnline: false,
      ),
    ];

    if (buddyPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              '등록된 버디 모집글이 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: buddyPosts.length,
      itemBuilder: (context, index) {
        return _BuddyPostCard(post: buddyPosts[index]);
      },
    );
  }
}

class _BuddyPost {
  final String title;
  final String author;
  final String region;
  final String date;
  final String certLevel;
  final String description;
  final bool isOnline;

  _BuddyPost({
    required this.title,
    required this.author,
    required this.region,
    required this.date,
    required this.certLevel,
    required this.description,
    required this.isOnline,
  });
}

class _BuddyPostCard extends StatelessWidget {
  final _BuddyPost post;

  const _BuddyPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to post detail
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.oceanBlue.withOpacity(0.2),
                    child: Text(
                      post.author.substring(0, 1),
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
                        Row(
                          children: [
                            Text(
                              post.author,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            if (post.isOnline)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          post.certLevel,
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
                      color: AppColors.oceanBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      post.region,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.oceanBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post.description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.grey500),
                  const SizedBox(width: 4),
                  Text(
                    post.date,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('버디 신청이 전송되었습니다')),
                      );
                    },
                    child: const Text('버디 신청'),
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
