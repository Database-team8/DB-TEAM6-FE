import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onSwitchToLogin;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController nameController;
  final TextEditingController nickNameController;
  final TextEditingController descriptionController;
  final TextEditingController phoneNumberController;

  const SignUpScreen({
    super.key,
    required this.onSwitchToLogin,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.nameController,
    required this.nickNameController,
    required this.descriptionController,
    required this.phoneNumberController,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      await authViewModel.signUp(
        email: widget.emailController.text,
        password: widget.passwordController.text,
        name: widget.nameController.text,
        nickname: widget.nickNameController.text,
        phone: widget.phoneNumberController.text,
        description: widget.descriptionController.text,
        context: context,
      ); // 다시 쓰기
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styleForHint = theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(255, 158, 158, 158),
    );
    final styleForLabel = theme.textTheme.labelLarge;
    const divider = SizedBox(height: 48);

    final focusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
    );

    final notFocusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.hintColor, width: 2.0),
    );

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '회원가입',
                  style: theme.textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '아직 계정이 없으신가요?\n',
                        style: theme.textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: '회원가입',
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = widget.onSwitchToLogin,
                        style: theme.textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              divider,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Email', style: styleForLabel),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: widget.emailController,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Icon(Icons.email_outlined),
                  ),
                  prefixIconColor: theme.colorScheme.primary,
                  hintText: 'example@ajou.ac.kr',
                  hintStyle: styleForHint,
                  focusedBorder: focusedBorder,
                  border: notFocusedBorder,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력하세요.';
                  }
                  if (!RegExp(
                    r'^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)*ajou\.ac\.kr$',
                  ).hasMatch(value)) {
                    return '아주대학교 계정만 사용할 수 있습니다.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              divider,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Name', style: styleForLabel),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: widget.nameController,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Icon(Icons.account_circle_outlined),
                  ),
                  prefixIconColor: theme.colorScheme.primary,
                  hintText: '홍길동',
                  hintStyle: styleForHint,
                  focusedBorder: focusedBorder,
                  border: notFocusedBorder,
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              divider,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Nickname', style: styleForLabel),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: widget.nickNameController,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Icon(Icons.account_circle_outlined),
                  ),
                  prefixIconColor: theme.colorScheme.primary,
                  focusedBorder: focusedBorder,
                  border: notFocusedBorder,
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '별명을 입력하세요.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              divider,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Password', style: styleForLabel),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: widget.passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Icon(Icons.lock_outline),
                  ),
                  prefixIconColor: theme.colorScheme.primary,
                  focusedBorder: focusedBorder,
                  border: notFocusedBorder,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null) {
                    return '비밀번호를 입력하세요.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              divider,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Confirm Password', style: styleForLabel),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: widget.confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Icon(Icons.lock_outline),
                  ),
                  prefixIconColor: theme.colorScheme.primary,
                  focusedBorder: focusedBorder,
                  border: notFocusedBorder,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      (widget.passwordController.text != value)) {
                    return '비밀번호와 검증 비밀번호가 맞지 않습니다.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              divider,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Phone Number', style: styleForLabel),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: widget.phoneNumberController,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Icon(Icons.local_phone_outlined),
                  ),
                  prefixIconColor: theme.colorScheme.primary,
                  hintStyle: styleForHint,
                  hintText: '공란, 또는 01012345678',
                  focusedBorder: focusedBorder,
                  border: notFocusedBorder,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null &&
                      !RegExp(r'^01[016789]\d{8}$').hasMatch(value)) {
                    return '공란, 또는 01012345678';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              divider,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Description', style: styleForLabel),
              ),
              SizedBox(height: 6),
              TextFormField(
                controller: widget.descriptionController,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Icon(Icons.text_fields_outlined),
                  ),
                  prefixIconColor: theme.colorScheme.primary,
                  focusedBorder: focusedBorder,
                  border: notFocusedBorder,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  //테스트용 코드. 삭제할 것.
                  Provider.of<AuthViewModel>(
                    context,
                    listen: false,
                  ).testlogin();
                  FocusScope.of(context).unfocus();
                  //_submitForm();
                },
                style: theme.elevatedButtonTheme.style!.copyWith(
                  minimumSize: WidgetStateProperty.all(
                    Size(double.infinity, 50),
                  ),
                ),
                child: Text(
                  '회원가입',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
