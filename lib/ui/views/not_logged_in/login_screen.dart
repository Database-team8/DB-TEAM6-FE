import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSwitchToSignUp;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginScreen({super.key, 
    required this.onSwitchToSignUp,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_isSubmitting) return; // 중복 제출 방지

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      FocusScope.of(context).unfocus();
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      
      try {
        bool success = await authViewModel.login(
          email: widget.emailController.text,
          password: widget.passwordController.text,
        );

        if (!mounted) {
          return;
        } else {
          if (success) {
            // 로그인 성공 후 처리
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('로그인 성공!')),
            );
            widget.emailController.clear();
            widget.passwordController.clear();
          } else {
            // 로그인 실패 처리
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('로그인 실패. 다시 시도해주세요.')),
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
        setState(() {
          _isSubmitting = false;
        });
      }
    } 
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styleForHint = theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 158, 158, 158));
    final styleForLabel = theme.textTheme.labelLarge;
    const divider = SizedBox(height: 48,);

    final focusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
    );

    final notFocusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.hintColor, width: 2.0)
    );

    return Form(key:_formKey,
    child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '로그인',
                style: theme.textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w900),
            )),
            SizedBox(height: 30,),
            Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '아직 계정이 없으신가요?\n',
                      style: theme.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: '회원가입',
                      recognizer: TapGestureRecognizer()..onTap = widget.onSwitchToSignUp,
                      style: theme.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.primary),
                    )
                  ]
                ),
                ),
            ),
            divider,
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Email',
                style: styleForLabel
              ),
            ),
            SizedBox(height: 6),
            TextFormField(
              controller: widget.emailController,
              obscureText: false,
              decoration: InputDecoration(
                focusedBorder: focusedBorder,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Icon(Icons.email_outlined),
                ),
                prefixIconColor: theme.colorScheme.primary,
                hintText: 'example@ajou.ac.kr',
                hintStyle: styleForHint,
                isDense: true,
                border: notFocusedBorder,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이메일을 입력하세요.';
                }
                if (!RegExp(r'^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)*ajou\.ac\.kr$').hasMatch(value)) {
                  return '아주대학교 계정만 사용할 수 있습니다.';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            divider,
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Password',
                style: styleForLabel,
              ),
            ),
            SizedBox(height: 6),            
            TextFormField(
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Icon(Icons.lock_outlined),
                ),
                prefixIconColor: theme.colorScheme.primary,
                focusedBorder: focusedBorder,
                isDense: true,
                border: notFocusedBorder,
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }, 
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Icon(_obscurePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: theme.hintColor),
                  )
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
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: theme.elevatedButtonTheme.style!.copyWith(
                minimumSize: WidgetStateProperty.all(
                  Size(double.infinity, 50)
                ),
              ),
              child: _isSubmitting
                    ? SizedBox( // 로딩 인디케이터 크기 조절
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.onPrimary,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        '로그인',
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      )));
  }
}
