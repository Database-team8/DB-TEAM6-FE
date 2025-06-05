import 'dart:io';
import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/ui/shared/widgets/build_generic_dropdown.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/filter_state_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostBoardWidget extends StatefulWidget {
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
  String? _selectedImageUrl;
  DateTime? _selectedDate;
  ItemType? _selectedItemType;
  Location? _selectedLocation;
  String? _selectedStatus;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

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
    if (_isSubmitting) return; // 중복 제출 방지

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      FocusScope.of(context).unfocus();
      final boardViewModel = Provider.of<BoardViewModel>(
        context,
        listen: false,
      );

      try {
        late bool success;

        if (widget.lostCategory == 'lost') {
          success = await boardViewModel.postLostBoard(
            title: _titleController.text,
            detailedLocation: _detailedLocationController.text,
            description: _contentController.text,
            relatedDate: _selectedDate!,
            image: '',
            category: widget.lostCategory.toUpperCase(),
            itemTypeId: _selectedItemType?.id ?? 0,
            locationId: _selectedLocation?.id ?? 0,
          );
        } else {
          success = await boardViewModel.postFoundBoard(
            title: _titleController.text,
            detailedLocation: _detailedLocationController.text,
            description: _contentController.text,
            relatedDate: _selectedDate ?? DateTime.now(),
            image: '',
            category: widget.lostCategory.toUpperCase(),
            itemTypeId: _selectedItemType?.id ?? 0,
            locationId: _selectedLocation?.id ?? 0,
          );
        }

        if (!mounted) {
          return;
        } else {
          if (success) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('게시글이 성공적으로 등록되었습니다.')));
            Navigator.of(context).pop(); // 게시글 등록 후 이전 화면으로 돌아가기
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('게시글 등록에 실패했습니다. 다시 시도해주세요.')),
            );
          }
        }
      } catch (e) {
        if (!mounted) {
          return;
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('오류 발생: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterStateViewModel = Provider.of<FilterStateViewModel>(context);

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
              buildGenericDropdown<Location>(
                hintText: '위치',
                selectedValue: _selectedLocation,
                items: filterStateViewModel.availableLocations,
                isLoading: filterStateViewModel.isLoadingLocations,
                error: filterStateViewModel.locationsError,
                emptyText: '위치 정보 없음',
                labelBuilder: (loc) => loc.locationName,
                theme: theme,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDetailedLocationTextField(),
              const SizedBox(height: 16),
              buildGenericDropdown<ItemType>(
                hintText: '종류',
                selectedValue: _selectedItemType,
                items: filterStateViewModel.availableItemTypes,
                isLoading: filterStateViewModel.isLoadingItemTypes,
                error: filterStateViewModel.itemTypesError,
                emptyText: '종류 정보 없음',
                labelBuilder: (itemType) => itemType.itemType,
                theme: theme,
                onChanged: (newValue) {
                  setState(() {
                    _selectedItemType = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              buildGenericDropdown<String>(
                hintText: '상태',
                selectedValue: _selectedStatus,
                items: filterStateViewModel.availableStatuses,
                isLoading: filterStateViewModel.isLoadingStatuses,
                error: filterStateViewModel.statusesError,
                emptyText: '상태 정보 없음',
                labelBuilder: (status) => status,
                theme: theme,
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
              ),
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
        onPressed: _isSubmitting ? null : _submitBoard,
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
        child:
            _selectedImage != null
                ? Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_rounded,
                      size: 60,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '사진을 첨부해주세요',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
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
        hintStyle: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
        ),
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
        border: InputBorder.none,
        hintText: '분실 장소의 추가정보를 작성해주세요 (ex. 102호)',
        hintStyle: theme.textTheme.bodySmall,
        prefixIcon: Icon(
          Icons.place_outlined,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
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
