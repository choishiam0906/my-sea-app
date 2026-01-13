import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';

class AddDivePage extends ConsumerStatefulWidget {
  const AddDivePage({super.key});

  @override
  ConsumerState<AddDivePage> createState() => _AddDivePageState();
}

class _AddDivePageState extends ConsumerState<AddDivePage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Basic Info
  final _siteController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _diveDate = DateTime.now();
  TimeOfDay _entryTime = TimeOfDay.now();

  // Dive Details
  final _maxDepthController = TextEditingController();
  final _avgDepthController = TextEditingController();
  final _durationController = TextEditingController();
  final _waterTempController = TextEditingController();

  // Tank Info
  String _gasType = 'Air';
  final _tankSizeController = TextEditingController(text: '12');
  final _startPressureController = TextEditingController(text: '200');
  final _endPressureController = TextEditingController();

  // Conditions
  String _visibility = 'good';
  String _current = 'none';
  String _waves = 'calm';
  String _diveType = 'recreational';

  // Notes
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _siteController.dispose();
    _locationController.dispose();
    _maxDepthController.dispose();
    _avgDepthController.dispose();
    _durationController.dispose();
    _waterTempController.dispose();
    _tankSizeController.dispose();
    _startPressureController.dispose();
    _endPressureController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('다이브 기록'),
        actions: [
          TextButton(
            onPressed: _saveDive,
            child: const Text('저장'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 4) {
              setState(() => _currentStep++);
            } else {
              _saveDive();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          onStepTapped: (step) => setState(() => _currentStep = step),
          steps: [
            // Step 1: Basic Info
            Step(
              title: const Text('기본 정보'),
              subtitle: const Text('다이브 사이트 및 날짜'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: _BasicInfoStep(
                siteController: _siteController,
                locationController: _locationController,
                diveDate: _diveDate,
                entryTime: _entryTime,
                onDateChanged: (date) => setState(() => _diveDate = date),
                onTimeChanged: (time) => setState(() => _entryTime = time),
              ),
            ),

            // Step 2: Dive Details
            Step(
              title: const Text('다이브 정보'),
              subtitle: const Text('수심, 시간, 수온'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _DiveDetailsStep(
                maxDepthController: _maxDepthController,
                avgDepthController: _avgDepthController,
                durationController: _durationController,
                waterTempController: _waterTempController,
              ),
            ),

            // Step 3: Tank Info
            Step(
              title: const Text('탱크 정보'),
              subtitle: const Text('가스, 압력'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: _TankInfoStep(
                gasType: _gasType,
                tankSizeController: _tankSizeController,
                startPressureController: _startPressureController,
                endPressureController: _endPressureController,
                onGasTypeChanged: (type) => setState(() => _gasType = type),
              ),
            ),

            // Step 4: Conditions
            Step(
              title: const Text('다이빙 조건'),
              subtitle: const Text('시야, 해류, 파도'),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: _ConditionsStep(
                visibility: _visibility,
                current: _current,
                waves: _waves,
                diveType: _diveType,
                onVisibilityChanged: (v) => setState(() => _visibility = v),
                onCurrentChanged: (c) => setState(() => _current = c),
                onWavesChanged: (w) => setState(() => _waves = w),
                onDiveTypeChanged: (t) => setState(() => _diveType = t),
              ),
            ),

            // Step 5: Notes
            Step(
              title: const Text('노트'),
              subtitle: const Text('추가 메모'),
              isActive: _currentStep >= 4,
              state: StepState.indexed,
              content: _NotesStep(notesController: _notesController),
            ),
          ],
        ),
      ),
      // BLE Connection Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showBleConnectionDialog,
        backgroundColor: AppColors.oceanBlue,
        icon: const Icon(Icons.bluetooth, color: AppColors.white),
        label: const Text(
          '다이브 컴퓨터 연결',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }

  void _saveDive() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Save dive to Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('다이브가 저장되었습니다'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  void _showBleConnectionDialog() {
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
            const SizedBox(height: 20),
            const Text(
              '다이브 컴퓨터 연결',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'BLE 지원 다이브 컴퓨터를 검색합니다',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              '주변 장치를 검색 중...',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey500,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '지원 기기: Shearwater, Suunto, Garmin, Mares',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('취소'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BasicInfoStep extends StatelessWidget {
  final TextEditingController siteController;
  final TextEditingController locationController;
  final DateTime diveDate;
  final TimeOfDay entryTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const _BasicInfoStep({
    required this.siteController,
    required this.locationController,
    required this.diveDate,
    required this.entryTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: siteController,
          decoration: const InputDecoration(
            labelText: '다이브 사이트',
            hintText: '예: 문섬, 범섬',
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '다이브 사이트를 입력해주세요';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: locationController,
          decoration: const InputDecoration(
            labelText: '위치',
            hintText: '예: 제주도',
            prefixIcon: Icon(Icons.map),
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('다이브 날짜'),
          subtitle: Text(
            '${diveDate.year}년 ${diveDate.month}월 ${diveDate.day}일',
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: diveDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              onDateChanged(date);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('입수 시간'),
          subtitle: Text(entryTime.format(context)),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: entryTime,
            );
            if (time != null) {
              onTimeChanged(time);
            }
          },
        ),
      ],
    );
  }
}

class _DiveDetailsStep extends StatelessWidget {
  final TextEditingController maxDepthController;
  final TextEditingController avgDepthController;
  final TextEditingController durationController;
  final TextEditingController waterTempController;

  const _DiveDetailsStep({
    required this.maxDepthController,
    required this.avgDepthController,
    required this.durationController,
    required this.waterTempController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: maxDepthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '최대 수심',
                  suffixText: 'm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '필수';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: avgDepthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '평균 수심',
                  suffixText: 'm',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '다이빙 시간',
                  suffixText: '분',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '필수';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: waterTempController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '수온',
                  suffixText: '°C',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TankInfoStep extends StatelessWidget {
  final String gasType;
  final TextEditingController tankSizeController;
  final TextEditingController startPressureController;
  final TextEditingController endPressureController;
  final ValueChanged<String> onGasTypeChanged;

  const _TankInfoStep({
    required this.gasType,
    required this.tankSizeController,
    required this.startPressureController,
    required this.endPressureController,
    required this.onGasTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('가스 타입'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['Air', 'Nitrox 32', 'Nitrox 36'].map((type) {
            return ChoiceChip(
              label: Text(type),
              selected: gasType == type,
              onSelected: (selected) {
                if (selected) onGasTypeChanged(type);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: tankSizeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '탱크 크기',
            suffixText: 'L',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: startPressureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '시작 압력',
                  suffixText: 'bar',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: endPressureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '종료 압력',
                  suffixText: 'bar',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConditionsStep extends StatelessWidget {
  final String visibility;
  final String current;
  final String waves;
  final String diveType;
  final ValueChanged<String> onVisibilityChanged;
  final ValueChanged<String> onCurrentChanged;
  final ValueChanged<String> onWavesChanged;
  final ValueChanged<String> onDiveTypeChanged;

  const _ConditionsStep({
    required this.visibility,
    required this.current,
    required this.waves,
    required this.diveType,
    required this.onVisibilityChanged,
    required this.onCurrentChanged,
    required this.onWavesChanged,
    required this.onDiveTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ConditionSelector(
          label: '시야',
          value: visibility,
          options: const {
            'excellent': '매우 좋음',
            'good': '좋음',
            'moderate': '보통',
            'poor': '나쁨',
          },
          onChanged: onVisibilityChanged,
        ),
        const SizedBox(height: 16),
        _ConditionSelector(
          label: '해류',
          value: current,
          options: const {
            'none': '없음',
            'light': '약함',
            'moderate': '보통',
            'strong': '강함',
          },
          onChanged: onCurrentChanged,
        ),
        const SizedBox(height: 16),
        _ConditionSelector(
          label: '파도',
          value: waves,
          options: const {
            'calm': '잔잔함',
            'slight': '약함',
            'moderate': '보통',
            'rough': '거침',
          },
          onChanged: onWavesChanged,
        ),
        const SizedBox(height: 16),
        _ConditionSelector(
          label: '다이빙 유형',
          value: diveType,
          options: const {
            'recreational': '레크레이션',
            'training': '교육',
            'night': '야간',
            'drift': '드리프트',
            'wreck': '렉',
            'deep': '딥',
          },
          onChanged: onDiveTypeChanged,
        ),
      ],
    );
  }
}

class _ConditionSelector extends StatelessWidget {
  final String label;
  final String value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;

  const _ConditionSelector({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.entries.map((entry) {
            return ChoiceChip(
              label: Text(entry.value),
              selected: value == entry.key,
              onSelected: (selected) {
                if (selected) onChanged(entry.key);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _NotesStep extends StatelessWidget {
  final TextEditingController notesController;

  const _NotesStep({required this.notesController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: notesController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: '다이빙 노트',
            hintText: '이번 다이빙에서 특별했던 점이나 기억하고 싶은 것들을 기록해보세요',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),
        // Photo upload placeholder
        Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey300, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // TODO: Photo upload
            },
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 32, color: AppColors.grey400),
                  const SizedBox(height: 8),
                  Text(
                    '사진 추가',
                    style: TextStyle(color: AppColors.grey500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
