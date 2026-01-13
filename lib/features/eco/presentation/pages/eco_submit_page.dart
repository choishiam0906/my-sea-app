import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';

class EcoSubmitPage extends ConsumerStatefulWidget {
  const EcoSubmitPage({super.key});

  @override
  ConsumerState<EcoSubmitPage> createState() => _EcoSubmitPageState();
}

class _EcoSubmitPageState extends ConsumerState<EcoSubmitPage> {
  bool _isAnalyzing = false;
  bool _isAnalyzed = false;
  List<_DetectedItem> _detectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('쓰레기 인증'),
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
                  color: AppColors.ecoGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.ecoGreen.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.ecoGreen),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '수거한 쓰레기를 촬영하면 AI가 자동으로 분류하고 포인트를 계산해요!',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkGreen,
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
                onTap: _takePhoto,
              ),
              const SizedBox(height: 24),

              // Analysis Results
              if (_isAnalyzed) ...[
                _AnalysisResults(items: _detectedItems),
                const SizedBox(height: 24),
              ],

              // Trash Type Reference
              if (!_isAnalyzed) ...[
                const Text(
                  '포인트 기준',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _PointsReferenceCard(),
              ],

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isAnalyzed ? _submitEcoLog : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ecoGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isAnalyzed ? '인증 제출하기' : '사진을 촬영해주세요',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    // Simulate photo capture and AI analysis
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isAnalyzing = false;
      _isAnalyzed = true;
      _detectedItems = [
        _DetectedItem(type: '플라스틱 병', count: 2, points: 20, confidence: 0.95),
        _DetectedItem(type: '어망', count: 1, points: 50, confidence: 0.88),
        _DetectedItem(type: '비닐봉지', count: 3, points: 15, confidence: 0.92),
      ];
    });
  }

  void _submitEcoLog() {
    final totalPoints = _detectedItems.fold<int>(
      0,
      (sum, item) => sum + item.points,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 8),
            Text('인증 완료!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('굿다이빙 챌린지 참여 감사합니다!'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
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
                    '+$totalPoints 나뭇잎 포인트',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ecoGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
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
          color: isAnalyzed ? AppColors.ecoGreen.withOpacity(0.1) : AppColors.grey100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isAnalyzed
                ? AppColors.ecoGreen
                : AppColors.grey300,
            width: 2,
            style: isAnalyzed ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: Center(
          child: isAnalyzing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.ecoGreen),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'AI가 쓰레기를 분석 중...',
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
                          color: AppColors.ecoGreen,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '분석 완료!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ecoGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: onTap,
                          child: const Text('다시 촬영'),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 48,
                            color: AppColors.grey500,
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
                          '수거한 쓰레기를 한 곳에 모아서 촬영해주세요',
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

class _DetectedItem {
  final String type;
  final int count;
  final int points;
  final double confidence;

  _DetectedItem({
    required this.type,
    required this.count,
    required this.points,
    required this.confidence,
  });
}

class _AnalysisResults extends StatelessWidget {
  final List<_DetectedItem> items;

  const _AnalysisResults({required this.items});

  @override
  Widget build(BuildContext context) {
    final totalPoints = items.fold<int>(0, (sum, item) => sum + item.points);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AI 분석 결과',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.ecoGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.eco, size: 16, color: AppColors.ecoGreen),
                    const SizedBox(width: 4),
                    Text(
                      '+$totalPoints',
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
          const SizedBox(height: 16),
          ...items.map((item) => _DetectedItemRow(item: item)),
        ],
      ),
    );
  }
}

class _DetectedItemRow extends StatelessWidget {
  final _DetectedItem item;

  const _DetectedItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.ecoGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: AppColors.ecoGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.type} x${item.count}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '신뢰도: ${(item.confidence * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${item.points}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.ecoGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsReferenceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      {'name': '어망', 'points': '50', 'icon': Icons.waves},
      {'name': '플라스틱 병', 'points': '10', 'icon': Icons.local_drink},
      {'name': '캔', 'points': '10', 'icon': Icons.local_cafe},
      {'name': '비닐봉지', 'points': '5', 'icon': Icons.shopping_bag},
      {'name': '담배꽁초', 'points': '3', 'icon': Icons.smoking_rooms},
      {'name': '기타', 'points': '5', 'icon': Icons.category},
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
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items.map((item) {
          return Container(
            width: (MediaQuery.of(context).size.width - 56) / 3,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: AppColors.grey600,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '+${item['points']}점',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.ecoGreen,
                    fontWeight: FontWeight.w600,
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
