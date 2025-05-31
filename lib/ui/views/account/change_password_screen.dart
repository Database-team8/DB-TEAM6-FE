import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart'; // AuthViewModel 경로
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final success = await authViewModel.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      String message;

      if (success) {
        message = '비밀번호가 성공적으로 변경되었습니다.';
        if (mounted) {
          Navigator.of(context).pop(); // 성공 시 이전 화면으로 돌아가기
        }
      } else {
        message = authViewModel.authErrorMessage ?? '비밀번호 변경에 실패했습니다. 다시 시도해주세요.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: success ? Colors.green : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildPasswordTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required bool obscureText,
    required VoidCallback onObscureToggle,
    required IconData visibilityIcon,
    required String? Function(String?) validator,
  }) {
    final theme = Theme.of(context);
    final styleForHint = theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(255, 158, 158, 158),
    );
    final styleForLabel = theme.textTheme.labelLarge;
    final focusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
    );
    final notFocusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.hintColor, width: 2.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(labelText, style: styleForLabel),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Icon(Icons.lock_outline),
            ),
            prefixIconColor: theme.colorScheme.primary,
            hintText: hintText,
            hintStyle: styleForHint,
            focusedBorder: focusedBorder,
            border: notFocusedBorder,
            suffixIcon: IconButton(
              onPressed: onObscureToggle,
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Icon(visibilityIcon, color: theme.hintColor),
              ),
            ),
          ),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const divider = SizedBox(height: 32); // SignUpScreen보다 간격을 약간 줄임

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          '비밀번호 변경',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 페이지 상단 설명 텍스트 (선택 사항)
                Text(
                  '새로운 비밀번호를 설정해주세요. 보안을 위해 현재 비밀번호를 함께 입력해야 합니다.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 48),

                _buildPasswordTextField(
                  context: context,
                  controller: _currentPasswordController,
                  labelText: '현재 비밀번호',
                  hintText: '현재 사용 중인 비밀번호',
                  obscureText: _obscureCurrentPassword,
                  onObscureToggle: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                  visibilityIcon: _obscureCurrentPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '현재 비밀번호를 입력하세요.';
                    }
                    // 실제로는 ViewModel을 통해 현재 비밀번호 일치 여부 검증 필요
                    return null;
                  },
                ),
                divider,
                _buildPasswordTextField(
                  context: context,
                  controller: _newPasswordController,
                  labelText: '새 비밀번호',
                  hintText: '새로 사용할 비밀번호',
                  obscureText: _obscureNewPassword,
                  onObscureToggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                  visibilityIcon: _obscureNewPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '새 비밀번호를 입력하세요.';
                    }
                    if (value == _currentPasswordController.text) {
                      return '현재 비밀번호와 다른 비밀번호를 사용해주세요.';
                    }
                    return null;
                  },
                ),
                divider,
                _buildPasswordTextField(
                  context: context,
                  controller: _confirmNewPasswordController,
                  labelText: '새 비밀번호 확인',
                  hintText: '새 비밀번호를 다시 입력',
                  obscureText: _obscureConfirmNewPassword,
                  onObscureToggle: () => setState(() => _obscureConfirmNewPassword = !_obscureConfirmNewPassword),
                  visibilityIcon: _obscureConfirmNewPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '새 비밀번호 확인을 입력하세요.';
                    }
                    if (_newPasswordController.text != value) {
                      return '새 비밀번호와 일치하지 않습니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 48), // 하단 버튼과의 간격
                ElevatedButton(
                  onPressed: _submitForm,
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    minimumSize: WidgetStateProperty.all(
                      const Size(double.infinity, 50),
                    ),
                    backgroundColor: WidgetStateProperty.all(theme.colorScheme.primary), // SignUpScreen과 유사한 스타일
                  ),
                  child: Provider.of<AuthViewModel>(context).isLoading // 로딩 상태 반영
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          '비밀번호 변경',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onPrimary, // SignUpScreen과 유사한 스타일
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
