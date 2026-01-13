import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';

class EncyclopediaPage extends ConsumerStatefulWidget {
  const EncyclopediaPage({super.key});

  @override
  ConsumerState<EncyclopediaPage> createState() => _EncyclopediaPageState();
}

class _EncyclopediaPageState extends ConsumerState<EncyclopediaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.skyGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: AppColors.grey700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        '해양 도감',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.grey800,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 22,
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.oceanBlue.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.oceanBlue, AppColors.skyBlue],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.oceanBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.grey500,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: '전체 도감'),
                    Tab(text: '내 컬렉션'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Category Filter
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 20),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryChip(
                      label: '전체',
                      icon: '🌊',
                      isSelected: _selectedCategory == 'all',
                      onTap: () => setState(() => _selectedCategory = 'all'),
                    ),
                    _CategoryChip(
                      label: '어류',
                      icon: '🐟',
                      isSelected: _selectedCategory == 'fish',
                      onTap: () => setState(() => _selectedCategory = 'fish'),
                    ),
                    _CategoryChip(
                      label: '갑각류',
                      icon: '🦀',
                      isSelected: _selectedCategory == 'crust',
                      onTap: () => setState(() => _selectedCategory = 'crust'),
                    ),
                    _CategoryChip(
                      label: '연체동물',
                      icon: '🐙',
                      isSelected: _selectedCategory == 'mollusc',
                      onTap: () => setState(() => _selectedCategory = 'mollusc'),
                    ),
                    _CategoryChip(
                      label: '산호',
                      icon: '🪸',
                      isSelected: _selectedCategory == 'coral',
                      onTap: () => setState(() => _selectedCategory = 'coral'),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _AllSpeciesGrid(),
                    _MyCollectionGrid(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.oceanBlue : AppColors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.oceanBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AllSpeciesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final species = [
      _SpeciesItem(
        name: '흰동가리',
        icon: '🐠',
        rarity: 'common',
        isCollected: true,
      ),
      _SpeciesItem(
        name: '노랑가오리',
        icon: '🦈',
        rarity: 'uncommon',
        isCollected: true,
      ),
      _SpeciesItem(
        name: '쥐가오리',
        icon: '🐋',
        rarity: 'rare',
        isCollected: false,
      ),
      _SpeciesItem(
        name: '고래상어',
        icon: '🦭',
        rarity: 'legendary',
        isCollected: false,
      ),
      _SpeciesItem(
        name: '바다거북',
        icon: '🐢',
        rarity: 'uncommon',
        isCollected: false,
      ),
      _SpeciesItem(
        name: '해파리',
        icon: '🪼',
        rarity: 'common',
        isCollected: true,
      ),
      _SpeciesItem(
        name: '문어',
        icon: '🐙',
        rarity: 'common',
        isCollected: false,
      ),
      _SpeciesItem(
        name: '랍스터',
        icon: '🦞',
        rarity: 'uncommon',
        isCollected: false,
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: species.length,
      itemBuilder: (context, index) {
        return _SpeciesCard(species: species[index]);
      },
    );
  }
}

class _SpeciesItem {
  final String name;
  final String icon;
  final String rarity;
  final bool isCollected;

  _SpeciesItem({
    required this.name,
    required this.icon,
    required this.rarity,
    required this.isCollected,
  });
}

class _SpeciesCard extends StatelessWidget {
  final _SpeciesItem species;

  const _SpeciesCard({required this.species});

  Color get rarityColor {
    switch (species.rarity) {
      case 'legendary':
        return AppColors.rarityLegendary;
      case 'rare':
        return AppColors.rarityRare;
      case 'uncommon':
        return AppColors.rarityUncommon;
      default:
        return AppColors.rarityCommon;
    }
  }

  String get rarityLabel {
    switch (species.rarity) {
      case 'legendary':
        return '전설';
      case 'rare':
        return '희귀';
      case 'uncommon':
        return '특별';
      default:
        return '일반';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showSpeciesDetail(context),
        borderRadius: BorderRadius.circular(24),
        child: Container(
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
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: rarityColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        species.icon,
                        style: TextStyle(
                          fontSize: 44,
                          color: species.isCollected ? null : Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    species.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: rarityColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      rarityLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: rarityColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (species.isCollected)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.ecoGreen, AppColors.lightGreen],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSpeciesDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: rarityColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Center(
                            child: Text(
                              species.icon,
                              style: const TextStyle(fontSize: 56),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                species.name,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.grey800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Amphiprion ocellaris',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.grey500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: rarityColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  rarityLabel,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      '설명',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '산호초 주변에서 흔히 발견되는 아름다운 열대어입니다. 말미잘과 공생하며 살아가는 것으로 유명합니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey600,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _InfoGrid(),
                    const SizedBox(height: 24),
                    if (!species.isCollected)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.paleBlue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'AI로 이 생물을 촬영하여 도감에 추가해보세요!',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.oceanBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _InfoItem(icon: '🏠', label: '서식지', value: '산호초')),
              Expanded(child: _InfoItem(icon: '📏', label: '크기', value: '최대 11cm')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _InfoItem(icon: '🌊', label: '수심', value: '1-15m')),
              Expanded(child: _InfoItem(icon: '🛡️', label: '보전', value: 'LC')),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.grey800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MyCollectionGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppColors.softOceanGradient,
              borderRadius: BorderRadius.circular(36),
            ),
            child: const Center(
              child: Text(
                '🎣',
                style: TextStyle(fontSize: 56),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '아직 수집한 해양 생물이 없어요',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI로 해양 생물을 식별하여\n도감을 채워보세요!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
