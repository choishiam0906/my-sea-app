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
  String _searchQuery = '';
  String _selectedRarity = 'all';

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
      appBar: AppBar(
        title: const Text('해양 도감'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.deepOceanBlue,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.deepOceanBlue,
          tabs: const [
            Tab(text: '전체 도감'),
            Tab(text: '내 컬렉션'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: '해양 생물 검색',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.grey100,
                  ),
                ),
                const SizedBox(height: 12),
                // Rarity Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _RarityChip(
                        label: '전체',
                        value: 'all',
                        selected: _selectedRarity == 'all',
                        onSelected: () => setState(() => _selectedRarity = 'all'),
                      ),
                      const SizedBox(width: 8),
                      _RarityChip(
                        label: '일반',
                        value: 'common',
                        color: AppColors.rarityCommon,
                        selected: _selectedRarity == 'common',
                        onSelected: () => setState(() => _selectedRarity = 'common'),
                      ),
                      const SizedBox(width: 8),
                      _RarityChip(
                        label: '특별',
                        value: 'uncommon',
                        color: AppColors.rarityUncommon,
                        selected: _selectedRarity == 'uncommon',
                        onSelected: () => setState(() => _selectedRarity = 'uncommon'),
                      ),
                      const SizedBox(width: 8),
                      _RarityChip(
                        label: '희귀',
                        value: 'rare',
                        color: AppColors.rarityRare,
                        selected: _selectedRarity == 'rare',
                        onSelected: () => setState(() => _selectedRarity = 'rare'),
                      ),
                      const SizedBox(width: 8),
                      _RarityChip(
                        label: '전설',
                        value: 'legendary',
                        color: AppColors.rarityLegendary,
                        selected: _selectedRarity == 'legendary',
                        onSelected: () => setState(() => _selectedRarity = 'legendary'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

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
    );
  }
}

class _RarityChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool selected;
  final VoidCallback onSelected;

  const _RarityChip({
    required this.label,
    required this.value,
    this.color,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: color?.withOpacity(0.2) ?? AppColors.grey200,
      checkmarkColor: color ?? AppColors.grey700,
      labelStyle: TextStyle(
        color: selected ? (color ?? AppColors.grey700) : AppColors.grey600,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _AllSpeciesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample data
    final species = [
      _SpeciesItem(
        name: '클라운피쉬',
        scientificName: 'Amphiprion ocellaris',
        rarity: 'common',
        imageIcon: Icons.catching_pokemon,
      ),
      _SpeciesItem(
        name: '노랑가오리',
        scientificName: 'Taeniura lymma',
        rarity: 'uncommon',
        imageIcon: Icons.water,
      ),
      _SpeciesItem(
        name: '쥐가오리',
        scientificName: 'Mobula birostris',
        rarity: 'rare',
        imageIcon: Icons.waves,
      ),
      _SpeciesItem(
        name: '고래상어',
        scientificName: 'Rhincodon typus',
        rarity: 'legendary',
        imageIcon: Icons.sailing,
      ),
      _SpeciesItem(
        name: '바다거북',
        scientificName: 'Cheloniidae',
        rarity: 'uncommon',
        imageIcon: Icons.shield,
      ),
      _SpeciesItem(
        name: '해파리',
        scientificName: 'Aurelia aurita',
        rarity: 'common',
        imageIcon: Icons.blur_circular,
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
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
  final String scientificName;
  final String rarity;
  final IconData imageIcon;
  final bool isCollected;

  _SpeciesItem({
    required this.name,
    required this.scientificName,
    required this.rarity,
    required this.imageIcon,
    this.isCollected = false,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showSpeciesDetail(context),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image placeholder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: rarityColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        species.imageIcon,
                        size: 64,
                        color: rarityColor.withOpacity(0.5),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: rarityColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    if (species.isCollected)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    species.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    species.scientificName,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: AppColors.grey500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: rarityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            species.imageIcon,
                            size: 40,
                            color: rarityColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                species.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                species.scientificName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.grey500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: rarityColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  species.rarity.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),

                    // Description
                    const Text(
                      '설명',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '이 해양 생물에 대한 자세한 설명입니다. 서식지, 행동 패턴, 특징 등의 정보가 표시됩니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats
                    const Text(
                      '정보',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(label: '서식지', value: '산호초'),
                    _InfoRow(label: '수심', value: '1-30m'),
                    _InfoRow(label: '최대 크기', value: '25cm'),
                    _InfoRow(label: '보전 상태', value: 'LC (관심 대상)'),
                    const SizedBox(height: 24),

                    // Sighting locations
                    const Text(
                      '주요 관찰 지역',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['제주도', '필리핀', '인도네시아', '몰디브']
                          .map((location) => Chip(
                                label: Text(location),
                                backgroundColor: AppColors.grey100,
                              ))
                          .toList(),
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
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
          Icon(
            Icons.collections_bookmark_outlined,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '아직 수집한 해양 생물이 없어요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI로 해양 생물을 식별하여 도감을 채워보세요!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}
