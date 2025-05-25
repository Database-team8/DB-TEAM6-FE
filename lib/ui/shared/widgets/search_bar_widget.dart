import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSubmitted,
    this.onClear,
    this.focusNode,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _showClearButton = false;

  void _onTextChanged() {
    final shouldShow = widget.controller.text.isNotEmpty;
    if (_showClearButton != shouldShow) {
      setState(() {
        _showClearButton = shouldShow;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _showClearButton = widget.controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _handleClear() {
    widget.controller.clear();
    widget.onClear?.call();
  }

  void _handleSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      widget.onSubmitted(query.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderRadius = BorderRadius.circular(28);

    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: borderRadius,
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.3),
          width: 1.5
        ),
      ),
      child: Row(
        children: [
          // 텍스트 입력창
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                isDense: true,
                //labelText: widget.hintText, // 접근성 향상
              ),
              onSubmitted: _handleSearchSubmitted,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          // 오른쪽 아이콘 영역
          if (_showClearButton)
            IconButton(
              icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant, size: 22),
              onPressed: _handleClear,
              splashRadius: 20,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              tooltip: '삭제',
            ),
          IconButton(
            icon: Icon(Icons.search, color: colorScheme.primary, size: 24),
            onPressed: () => _handleSearchSubmitted(widget.controller.text),
            splashRadius: 20,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            tooltip: '검색',
          ),
        ],
      ),
    );
  }
}

