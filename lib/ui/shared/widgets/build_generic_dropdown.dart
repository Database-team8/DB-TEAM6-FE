import 'package:flutter/material.dart';

Widget buildGenericDropdown<T>({
  required String hintText,
  required T? selectedValue,
  required List<T> items,
  required bool isLoading,
  required String? error,
  required String emptyText,
  required String Function(T) labelBuilder,
  ValueChanged<T?>? onChanged,
  Future<void> Function()? onChangedAsync,
  required ThemeData theme,
  Color? lineColor,
  Widget? icon,
  bool isFormField = false,
  FormFieldValidator<T>? validator,
  Widget? prefixIcon,
}) {
  final effectiveLineColor = lineColor ?? theme.colorScheme.onSurfaceVariant;

  if (isLoading) {
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
  if (error != null) {
    return Text('$hintText 로딩 실패', style: TextStyle(color: theme.colorScheme.error));
  }
  if (items.isEmpty) {
    return Text(emptyText);
  }

  final dropdown = DropdownButton<T>(
    icon: icon ?? Icon(Icons.keyboard_arrow_down_rounded, color: effectiveLineColor),
    hint: Text(
      hintText,
      style: theme.textTheme.labelMedium!.copyWith(color: effectiveLineColor),
    ),
    value: selectedValue,
    items: items.map((T value) {
      return DropdownMenuItem<T>(
        value: value,
        child: Text(
          labelBuilder(value),
          style: theme.textTheme.labelMedium!.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      );
    }).toList(),
    onChanged: (T? newValue) async {
      if (onChanged != null) onChanged(newValue);
      if (onChangedAsync != null) await onChangedAsync();
    },
    isDense: true,
    dropdownColor: theme.colorScheme.surface,
  );

  if (isFormField) {
    return DropdownButtonFormField<T>(
      value: selectedValue,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: prefixIcon,
      ),
      isExpanded: true,
      items: items.map((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(labelBuilder(value)),
        );
      }).toList(),
      onChanged: (T? newValue) async {
      if (onChanged != null) onChanged(newValue);
      if (onChangedAsync != null) await onChangedAsync();
    },
      validator: validator,
    );
  }

  return DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: effectiveLineColor, width: 1.0),
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
      child: DropdownButtonHideUnderline(child: dropdown),
    ),
  );
}
