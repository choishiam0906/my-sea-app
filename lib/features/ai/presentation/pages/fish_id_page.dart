import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

class FishIdPage extends ConsumerStatefulWidget {
  const FishIdPage({super.key});

  @override
  ConsumerState<FishIdPage> createState() => _FishIdPageState();
}

class _FishIdPageState extends ConsumerState<FishIdPage> {
  bool _isAnalyzing = false;
  bool _isAnalyzed = false;
  _IdentifiedSpecies? _identifiedSpecies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('물고기 AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () => context.push(AppRoutes.encyclopedia),
            tooltip: '도감',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.oceanBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.oceanBlue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: AppColors.oceanBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '해양 생물 사진을 촬영하면 AI가 종을 식별하고 정보를 알려드려요!',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.deepOceanBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Photo Upload Area
              _PhotoUploadArea(
                isAnalyzing: _isAnalyzing,
                isAnalyzed: _isAnalyzed,
                onTap: _capturePhoto,
              ),
              const SizedBox(height: 24),

              // Analysis Result
              if (_isAnalyzed && _identifiedSpecies != null) ...[
                _SpeciesResultCard(species: _identifiedSpecies!),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Add to collection
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('도감에 추가되었습니다')),
                          );
                        },
                        icon: const Icon(Icons.bookmark_add),
                        label: const Text('도감에 추가'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Add to dive log
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('다이브 로그에 추가'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Recent Identifications
              if (!_isAnalyzed) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '최근 식별',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.encyclopedia),
                      child: const Text('도감 보기'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _EmptyRecentIdentifications(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _capturePhoto() async {
    setState(() {
      _isAnalyzing = true;
      _isAnalyzed = false;
    });

    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isAnalyzing = false;
      _isAnalyzed = true;
      _identifiedSpecies = _IdentifiedSpecies(
        koreanName: '노랑가오리',
        scientificName: 'Taeniura lymma',
        englishName: 'Blue-spotted Stingray',
        confidence: 0.94,
        rarity: 'uncommon',
        description:
            '노랑가오리는 인도태평양 해역에서 발견되는 가오리로, 푸른 점박이 무늬가 특징입니다. 주로 산호초 주변의 모래 바닥에서 서식합니다.',
        habitat: '산호초, 모래 바닥',
        maxSize: '35cm',
        depth: '1-30m',
        conservationStatus: 'VU (취약)',
        points: 15,
      );
    });
  }
}

class _PhotoUploadArea extends StatelessWidget {
  final bool isAnalyzing;
  final bool isAnalyzed;
  final VoidCallback onTap;

  const _PhotoUploadArea({
    required this.isAnalyzing,
    required this.isAnalyzed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAnalyzing ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          gradient: isAnalyzed
              ? LinearGradient(
                  colors: [
                    AppColors.oceanBlue.withOpacity(0.2),
                    AppColors.deepOceanBlue.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isAnalyzed ? null : AppColors.grey100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isAnalyzed ? AppColors.oceanBlue : AppColors.grey300,
            width: 2,
          ),
        ),
        child: Center(
          child: isAnalyzing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.oceanBlue),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'AI가 해양 생물을 분석 중...',
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              : isAnalyzed
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 64,
                          color: AppColors.oceanBlue,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '분석 완료!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.oceanBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: onTap,
                          child: const Text('다른 사진 분석하기'),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.oceanBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 48,
                            color: AppColors.oceanBlue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '탭하여 사진 촬영',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '해양 생물을 촬영하면 AI가 종을 식별해드려요',
                          style: TextStyle(
                            fontSize: 13,
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

class _IdentifiedSpecies {
  final String koreanName;
  final String scientificName;
  final String englishName;
  final double confidence;
  final String rarity;
  final String description;
  final String habitat;
  final String maxSize;
  final String depth;
  final String conservationStatus;
  final int points;

  _IdentifiedSpecies({
    required this.koreanName,
    required this.scientificName,
    required this.englishName,
    required this.confidence,
    required this.rarity,
    required this.description,
    required this.habitat,
    required this.maxSize,
    required this.depth,
    required this.conservationStatus,
    required this.points,
  });
}

class _SpeciesResultCard extends StatelessWidget {
  final _IdentifiedSpecies species;

  const _SpeciesResultCard({required this.species});

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          species.koreanName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                            rarityLabel,
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
                    Text(
                      species.scientificName,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      '${(species.confidence * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                    const Text(
                      '정확도',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            species.description,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _InfoChip(icon: Icons.home, label: '서식지', value: species.habitat),
              _InfoChip(icon: Icons.straighten, label: '최대 크기', value: species.maxSize),
              _InfoChip(icon: Icons.water, label: '수심', value: species.depth),
              _InfoChip(
                icon: Icons.shield,
                label: '보전 상태',
                value: species.conservationStatus,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.ecoGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.eco, color: AppColors.ecoGreen),
                const SizedBox(width: 8),
                Text(
                  '+${species.points} 도감 포인트 획득!',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ecoGreen,
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.grey500),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.grey500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EmptyRecentIdentifications extends StatelessWidget {
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
            Icons.photo_camera_outlined,
            size: 48,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 12),
          Text(
            '아직 식별한 해양 생물이 없어요',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '사진을 촬영하여 해양 생물을 식별해보세요!',
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
