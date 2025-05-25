import 'dart:io';

import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostBoardWidget extends StatefulWidget{
  const PostBoardWidget({super.key});

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
  String? _selectedCategory;

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
              _buildDetailedLocationTextField(),
              const SizedBox(height: 16),
              _buildCategorySelector(),
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
      decoration: const InputDecoration(
        hintText: '제목을 입력해주세요.',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '제목을 입력해주세요.';
        return null;
      },
    );
  }

  Widget _buildDetailedLocationTextField() {
    final theme = Theme.of(context);
    return TextFormField(
      controller: _detailedLocationController,
      decoration: InputDecoration(
        hintText: '분실 장소의 추가정보를 작성해주세요 (ex. 102호)',
        border: const OutlineInputBorder(),
        prefixIcon: Icon(Icons.fmd_good_outlined, color: theme.hintColor),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final theme = Theme.of(context);
    return ListTile(
      leading: const Icon(Icons.category_outlined, color: Colors.transparent),
      title: Text(_selectedCategory ?? '분실물 종류를 선택해주세요.'),
      trailing: const Icon(Icons.arrow_drop_down),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(color: theme.dividerColor),
      ),
      onTap: () {
        print('카테고리 선택 기능 호출 (구현 필요)');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('카테고리 선택 기능은 아직 구현되지 않았습니다.')));
        // setState(() { _selectedCategory = '임시 카테고리'; });
      },
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
        hintText: '분실물에 대한 내용을 알려주세요.',
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) return '내용을 입력해주세요.';
        return null;
      },
    );
  }
}