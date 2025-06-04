import 'dart:io';
import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:flutter/cupertino.dart';
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
      final boardViewModel = Provider.of<BoardViewModel>(context, listen: false,);

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: 
              Text('게시글이 성공적으로 등록되었습니다.')),
            );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류 발생: $e')),
          );
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
    final boardViewModel = Provider.of<BoardViewModel>(context);

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
              _buildLocationDropdown(boardViewModel),
              const SizedBox(height: 16),
              _buildDetailedLocationTextField(),
              const SizedBox(height: 16),
              _buildItemTypeDropdown(boardViewModel),
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

  Widget _buildLocationDropdown(BoardViewModel boardViewModel) {
    final theme = Theme.of(context);
    final lineColor = theme.colorScheme.onSurfaceVariant;

    if (boardViewModel.isLoadingLocations) {
      return SizedBox(
        width: 100,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (boardViewModel.locationError != null) {
      return Text('위치 로딩 실패', style: TextStyle(color: theme.colorScheme.error));
    }
    if (boardViewModel.locations.isEmpty) {
      return Text('위치 정보 없음');
    }
    final locations = boardViewModel.locations;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: lineColor, width: 1.0), // 테두리 두께 조정
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(16.0), // 반지름 조정
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Location>(
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: lineColor),
            hint: Text(
              '위치',
              style: theme.textTheme.labelMedium!.copyWith(color: lineColor),
            ),
            value: _selectedLocation,
            items:
                locations.map((Location location) {
                  return DropdownMenuItem<Location>(
                    value: location,
                    child: Text(
                      location.locationName,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (Location? newValue) {
              setState(() {
                _selectedLocation = newValue;
              });
            },
            isDense: true,
            dropdownColor: theme.colorScheme.surface,
          ),
        ),
      ),
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
      items:
          statusOptions
              .map(
                (status) => DropdownMenuItem<String>(
                  value: status['value'],
                  child: Text(status['label']!),
                ),
              )
              .toList(),
      onChanged: (value) {
        setState(() {
          _selectedStatus = value;
        });
      },
      validator:
          (value) => value == null || value.isEmpty ? '상태를 선택해주세요.' : null,
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

  Widget _buildItemTypeDropdown(BoardViewModel boardViewModel) {
    final theme = Theme.of(context);
    final lineColor = theme.colorScheme.onSurfaceVariant;

    if (boardViewModel.isLoadingItemTypes) {
      return SizedBox(
        width: 100,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (boardViewModel.itemTypeError != null) {
      return Text('종류 로딩 실패', style: TextStyle(color: theme.colorScheme.error));
    }
    if (boardViewModel.itemTypes.isEmpty) {
      return Text('종류 정보 없음');
    }
    final itemTypes = boardViewModel.itemTypes;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: lineColor, width: 1.0),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ItemType>(
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: lineColor),
            hint: Text(
              '종류',
              style: theme.textTheme.labelMedium!.copyWith(color: lineColor),
            ),
            value: _selectedItemType,
            items:
                itemTypes.map((ItemType type) {
                  return DropdownMenuItem<ItemType>(
                    value: type,
                    child: Text(
                      type.itemType,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (ItemType? newValue) {
              setState(() {
                _selectedItemType = newValue;
              });
            },
            isDense: true,
            dropdownColor: theme.colorScheme.surface,
          ),
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
