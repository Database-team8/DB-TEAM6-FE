import 'package:ajoufinder/ui/views/not_logged_in/login_screen.dart';
import 'package:ajoufinder/ui/views/not_logged_in/sign_up_screen.dart';
import 'package:flutter/material.dart';

class NotLoggedInScreen extends StatefulWidget {
  const NotLoggedInScreen({super.key});

  @override
  _NotLoggedInScreenState createState() => _NotLoggedInScreenState();
}

class _NotLoggedInScreenState extends State<NotLoggedInScreen> {
  bool _isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _nickNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _nickNameController.dispose();
    _descriptionController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _passwordController.clear();
    _confirmPasswordController.clear();
    _nameController.clear();
    _nickNameController.clear();
    _descriptionController.clear();
    _phoneNumberController.clear();
  }

  void _switchToLogin() {
    setState(() {
      _isLogin = true;
      FocusScope.of(context).unfocus();
      _clearControllers();
    });
  }

  void _switchToSignUp() {
    setState(() {
      _isLogin = false;
      FocusScope.of(context).unfocus();
      _clearControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
              child: _isLogin
              ? LoginScreen(
                onSwitchToSignUp: _switchToSignUp,
                emailController: _emailController,
                passwordController: _passwordController,
              )
              : SignUpScreen(
                onSwitchToLogin: _switchToLogin,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                nameController: _nameController,
                nickNameController: _nickNameController,
                descriptionController: _descriptionController,
                phoneNumberController: _phoneNumberController,
              ),
            )
          )
        ),
        backgroundColor: theme.colorScheme.surface,
      );
  }
}
