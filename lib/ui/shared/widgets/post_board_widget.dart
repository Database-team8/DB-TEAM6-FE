import 'dart:io';

import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';
import 'package:ajoufinder/domain/repository/location_repository.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostBoardWidget extends StatefulWidget{
  final String lostCategory;
  const PostBoardWidget({super.key, required this.lostCategory});

  @override
  State<PostBoardWidget> createState() => _PostBoardWidgetState();
}

class _PostBoardWidgetState extends State<PostBoardWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _detailedLocationController;
  late TextEditingController _contentController;

  File? _selectedImage;
  DateTime? _selectedDate;
  ItemType? _selectedItemType;
  Location? _selectedLocation;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _detailedLocationController = TextEditingController();
    _contentController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailedLocationController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    //구현 필요
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025).add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitBoard() async {
    if (_formKey.currentState!.validate()) {
      try {
        final boardViewModel = Provider.of<BoardViewModel>(context, listen: false);
        await boardViewModel.addBoard(/** 파라미터 추후 구현*/);

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // 추후 구현
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePickerSection(),
              const SizedBox(height: 20),
              _buildTitleTextField(),
              const SizedBox(height: 16),
              _buildLocationDropdown(),
              const SizedBox(height: 16),
              _buildDetailedLocationTextField(),
              const SizedBox(height: 16),
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildStatusDropdown(),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildContentTextField(),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitBoard, 
        label: Text('제출'),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImagePickerSection() {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceTint,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: theme.dividerColor, width: 1.0),
        ),
        alignment: Alignment.center,
        child: _selectedImage != null
        ? Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_rounded, size: 60, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text('사진을 첨부해주세요', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    final theme = Theme.of(context);

    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: '제목을 입력해주세요.',
        border: UnderlineInputBorder(),
        hintStyle: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant)
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '제목을 입력해주세요.';
        return null;
      },
    );
  }

  Widget _buildLocationDropdown() {
    final theme = Theme.of(context);
    final locationRepository = getIt<LocationRepository>();

    return FutureBuilder(
      future: locationRepository.getAllLocations(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text('위치 목록을 불러오지 못했습니다.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
          );
        } else if (snapshot.hasData) {
          final locations = snapshot.data!;

           return DropdownButtonFormField<Location>(
            value: locations.any((loc) => loc == _selectedLocation) ? _selectedLocation : null,
            decoration: InputDecoration(
              border: InputBorder.none, 
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8, right: 12),
                child: Icon(Icons.place_outlined, color: theme.colorScheme.onSurfaceVariant),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            hint: Text('분실 장소를 선택해주세요.',style: theme.textTheme.bodySmall,),
            isExpanded: true,
            items: locations.map((loc) => DropdownMenuItem<Location>(
              value: loc,
              child: Text(loc.locationName),
              )
            ).toList(),
            onChanged: ((value) {
              setState(() {
                _selectedLocation = value;
              });
            }),
           );
        } else {
          return const SizedBox.shrink();
        }
      }
    );
  }

  Widget _buildStatusDropdown() {
    final theme = Theme.of(context);

    final List<Map<String, String>> statusOptions = [
      {'value': 'lost', 'label': '분실'},
      {'value': 'found', 'label': '습득'},
    ];
    _selectedStatus = widget.lostCategory;

    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(CupertinoIcons.checkmark_shield),
      ),
      isExpanded: true,
      items: statusOptions.map((status) => DropdownMenuItem<String>(
        value: status['value'],
        child: Text(status['label']!),
      )).toList(),
      onChanged: (value) {
        setState(() {
          _selectedStatus = value;
        });
      },
      validator: (value) => value == null || value.isEmpty ? '상태를 선택해주세요.' : null,
    );
  }


  Widget _buildDetailedLocationTextField() {
    final theme = Theme.of(context);
    return TextFormField(
      controller: _detailedLocationController,
      decoration: InputDecoration(
        border: InputBorder.none, 
        hintText: '분실 장소의 추가정보를 작성해주세요 (ex. 102호)',
        hintStyle: theme.textTheme.bodySmall,
        prefixIcon: Icon(Icons.place_outlined, color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    final theme = Theme.of(context);
    final boardRepository = getIt<BoardRepository>();
    
    return FutureBuilder(
      future: boardRepository.getAllItemTypes(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text('위치 목록을 불러오지 못했습니다.', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
          );
        } else if (snapshot.hasData) {
          final itemTypes = snapshot.data!;

           return DropdownButtonFormField<ItemType>(
            value: itemTypes.any((itype) => itype == _selectedItemType) ? _selectedItemType : null,
            decoration: InputDecoration(
              border: InputBorder.none, 
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8, right: 12),
                child: Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.onSurfaceVariant),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            hint: Text('종류를 선택해주세요.',style: theme.textTheme.bodySmall,),
            isExpanded: true,
            items: itemTypes.map((iType) => DropdownMenuItem<ItemType>(
              value: iType,
              child: Text(iType.itemType),
              )
            ).toList(),
            onChanged: ((value) {
              setState(() {
                _selectedItemType = value;
              });
            }),
           );
        } else {
          return const SizedBox.shrink();
        }
      }
    );
  }

  Widget _buildDatePicker() {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(Icons.calendar_today_outlined, color: theme.hintColor),
      title: Text(
        _selectedDate != null
        ? DateFormat('yyyy년 MM월 dd일').format(_selectedDate!)
        : '날짜를 선택해주세요.',
        style: theme.textTheme.bodySmall,
      ),
      trailing: const Icon(Icons.arrow_drop_down),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(color: theme.dividerColor),
      ),
      onTap: _selectDate,
    );
  }

  Widget _buildContentTextField() {
    final theme = Theme.of(context);
    return TextFormField(
      controller: _contentController,
      decoration: const InputDecoration(
        hintText: '내용을 작성해주세요.',
        border: InputBorder.none, 
      ),
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) return '내용을 입력해주세요.';
        return null;
      },
    );
  }
}