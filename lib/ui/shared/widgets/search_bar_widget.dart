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
  bool _isFocused = false;

  void _onTextChanged() {
    final shouldShow = widget.controller.text.isNotEmpty;
    if (_showClearButton != shouldShow) {
      setState(() {
        _showClearButton = shouldShow;
      });
    }
  }

  void _onFocusChanged() {
    if (widget.focusNode != null) {
      setState(() {
        _isFocused = widget.focusNode?.hasFocus ?? false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(_onFocusChanged);
    }
    _showClearButton = widget.controller.text.isNotEmpty;
    _isFocused = widget.focusNode?.hasFocus ?? false;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    if (widget.focusNode != null) {
      widget.focusNode!.removeListener(_onFocusChanged);
    }
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
    final borderRadius = Radius.circular(28);
    final fixedHeight = 48.0;
    final fixedWidth = fixedHeight;

    return LayoutBuilder(
    builder: (context, constraints) {
      final availableWidth = constraints.maxWidth;
      final rightWidth = _isFocused 
      ? availableWidth - fixedWidth 
      : 200.0;

      return Container(
        height: fixedHeight,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Container(
              height: fixedHeight,
              width: fixedWidth,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius,
                  bottomLeft: borderRadius,
                ),
                border: Border(
                  top: BorderSide(
                    color: _isFocused
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                    width: _isFocused ? 2.0 : 1.5,
                  ),
                  left: BorderSide(
                    color: _isFocused
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                    width: _isFocused ? 2.0 : 1.5,
                  ),
                  bottom: BorderSide(
                    color: _isFocused
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                    width: _isFocused ? 2.0 : 1.5,
                  ),
                  right: BorderSide.none,
                ),
              ),
            ),
            Flexible(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: fixedHeight,
                width: rightWidth,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topRight: borderRadius,
                    bottomRight: borderRadius
                  ),
                  border: Border(
                  top: BorderSide(
                    color: _isFocused
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                    width: _isFocused ? 2.0 : 1.5,
                  ),
                  right: BorderSide(
                    color: _isFocused
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                    width: _isFocused ? 2.0 : 1.5,
                  ),
                  bottom: BorderSide(
                    color: _isFocused
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                    width: _isFocused ? 2.0 : 1.5,
                  ),
                  left: BorderSide.none,
                ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          hintText: widget.hintText,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.surface,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onSubmitted: _handleSearchSubmitted,
                        textInputAction: TextInputAction.search,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    _showClearButton
                        ? IconButton(
                            icon: Icon(Icons.clear, color: theme.colorScheme.onSurface),
                            onPressed: _handleClear,
                            tooltip: '검색어 지우기',
                          )
                        : const SizedBox.shrink(),
                    IconButton(
                      icon: Icon(Icons.search, color: theme.colorScheme.primary, size: 24),
                      onPressed: () => _handleSearchSubmitted(widget.controller.text),
                      splashRadius: 20,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                      tooltip: '검색',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
  }
}

