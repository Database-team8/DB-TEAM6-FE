import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/views/logged_in/logged_in_screen.dart';
import 'package:ajoufinder/ui/views/not_logged_in/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget{
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {

    return Selector<AuthViewModel, bool>(
      selector: (context, authViewModel) => authViewModel.isLoggedIn,
      builder: (context, isLoggedIn, child) {

        Widget screenToDisplay = isLoggedIn ? LoggedInScreen() : NotLoggedInScreen();

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: screenToDisplay,
          ),
        );
      }
    );
  }
}