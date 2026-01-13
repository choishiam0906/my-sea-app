import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

class CertWalletPage extends ConsumerWidget {
  const CertWalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자격증 지갑'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () => _showQRCode(context),
            tooltip: 'QR 코드 보기',
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Instructions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.oceanBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.oceanBlue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.oceanBlue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '자격증 카드를 촬영하면 OCR로 자동 인식됩니다',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.deepOceanBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Certificates List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _EmptyCertCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('${AppRoutes.certWallet}/add'),
        backgroundColor: AppColors.deepOceanBlue,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text(
          '자격증 추가',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }

  void _showQRCode(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '내 자격증 QR 코드',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '다이빙 샵에서 자격증 확인 시 사용하세요',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_2,
                      size: 80,
                      color: AppColors.grey400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '자격증을 먼저 등록해주세요',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey500,
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

class _EmptyCertCard extends StatelessWidget {
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
            Icons.card_membership,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            '등록된 자격증이 없어요',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '자격증을 추가하여 디지털 지갑에 보관하세요',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.push('${AppRoutes.certWallet}/add'),
            icon: const Icon(Icons.add),
            label: const Text('자격증 추가'),
          ),
        ],
      ),
    );
  }
}

class _CertCard extends StatelessWidget {
  final String agency;
  final String level;
  final String certNumber;
  final String issueDate;
  final bool isVerified;

  const _CertCard({
    required this.agency,
    required this.level,
    required this.certNumber,
    required this.issueDate,
    this.isVerified = false,
  });

  Color get agencyColor {
    switch (agency.toUpperCase()) {
      case 'PADI':
        return const Color(0xFF003366);
      case 'SSI':
        return const Color(0xFF0066CC);
      case 'NAUI':
        return const Color(0xFF336699);
      case 'CMAS':
        return const Color(0xFF003399);
      default:
        return AppColors.deepOceanBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [agencyColor, agencyColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: agencyColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.waves,
              size: 120,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      agency,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    if (isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, size: 14, color: AppColors.white),
                            SizedBox(width: 4),
                            Text(
                              '인증됨',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  level,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '자격번호',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          certNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '발급일',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          issueDate,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
