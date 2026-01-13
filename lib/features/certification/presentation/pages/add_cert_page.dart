import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';

class AddCertPage extends ConsumerStatefulWidget {
  const AddCertPage({super.key});

  @override
  ConsumerState<AddCertPage> createState() => _AddCertPageState();
}

class _AddCertPageState extends ConsumerState<AddCertPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedAgency = 'PADI';
  String _selectedLevel = 'Open Water Diver';
  final _certNumberController = TextEditingController();
  DateTime _issueDate = DateTime.now();
  bool _isScanning = false;
  bool _isScanned = false;

  final _agencies = ['PADI', 'SSI', 'NAUI', 'CMAS', 'SDI/TDI', '기타'];
  final _padiLevels = [
    'Open Water Diver',
    'Advanced Open Water Diver',
    'Rescue Diver',
    'Divemaster',
    'Open Water Scuba Instructor',
    'Master Scuba Diver Trainer',
    'IDC Staff Instructor',
    'Master Instructor',
    'Course Director',
  ];

  @override
  void dispose() {
    _certNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자격증 추가'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // OCR Scan Card
                _ScanCard(
                  isScanning: _isScanning,
                  isScanned: _isScanned,
                  onTap: _scanCertificate,
                ),
                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '또는 직접 입력',
                        style: TextStyle(color: AppColors.grey500),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Agency Selection
                const Text(
                  '단체',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _agencies.map((agency) {
                    return ChoiceChip(
                      label: Text(agency),
                      selected: _selectedAgency == agency,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedAgency = agency);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Level Selection
                DropdownButtonFormField<String>(
                  value: _selectedLevel,
                  decoration: const InputDecoration(
                    labelText: '자격 레벨',
                    prefixIcon: Icon(Icons.military_tech),
                  ),
                  items: _padiLevels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedLevel = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Cert Number
                TextFormField(
                  controller: _certNumberController,
                  decoration: const InputDecoration(
                    labelText: '자격 번호',
                    hintText: 'PADI: 12345678',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '자격 번호를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Issue Date
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('발급일'),
                  subtitle: Text(
                    '${_issueDate.year}년 ${_issueDate.month}월 ${_issueDate.day}일',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _issueDate,
                      firstDate: DateTime(1970),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _issueDate = date);
                    }
                  },
                ),
                const SizedBox(height: 32),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.security, size: 20, color: AppColors.grey600),
                          const SizedBox(width: 8),
                          Text(
                            '자격증 인증 안내',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• 등록된 자격증은 해당 단체 API를 통해 검증됩니다\n'
                        '• 인증 완료 시 자격증에 인증 배지가 표시됩니다\n'
                        '• 허위 정보 등록 시 서비스 이용이 제한될 수 있습니다',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.grey600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _saveCertificate,
                  child: const Text('자격증 등록'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _scanCertificate() async {
    setState(() => _isScanning = true);

    // Simulate OCR scanning
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isScanning = false;
      _isScanned = true;
      // Simulate OCR result
      _selectedAgency = 'PADI';
      _selectedLevel = 'Advanced Open Water Diver';
      _certNumberController.text = '1234567890';
      _issueDate = DateTime(2023, 6, 15);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('자격증 정보가 인식되었습니다. 내용을 확인해주세요.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _saveCertificate() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Save to Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('자격증이 등록되었습니다'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }
}

class _ScanCard extends StatelessWidget {
  final bool isScanning;
  final bool isScanned;
  final VoidCallback onTap;

  const _ScanCard({
    required this.isScanning,
    required this.isScanned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isScanning ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: isScanned
              ? AppColors.success.withOpacity(0.1)
              : AppColors.deepOceanBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isScanned ? AppColors.success : AppColors.deepOceanBlue,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: isScanning
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'OCR로 자격증 인식 중...',
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              : isScanned
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 64,
                          color: AppColors.success,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '인식 완료!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: onTap,
                          child: const Text('다시 스캔'),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.deepOceanBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.document_scanner,
                            size: 48,
                            color: AppColors.deepOceanBlue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '자격증 카드 스캔',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepOceanBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '자격증 카드를 촬영하면 자동으로 정보를 인식해요',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.grey500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
