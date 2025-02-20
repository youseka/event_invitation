import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

buildSignInScreen() {
  return SignInScreen(
    actions: [_buildForgotPasswordAction(), _buildAuthStateChangeAction()],
  );
}

ForgotPasswordAction _buildForgotPasswordAction() {
  return ForgotPasswordAction(((context, email) {
    final uri = Uri(
      path: '/sign-in/forgot-password',
      queryParameters: <String, String?>{
        'email': email,
      },
    );
    context.push(uri.toString());
  }));
}

AuthStateChangeAction _buildAuthStateChangeAction() {
  return AuthStateChangeAction(((context, state) {
    final user = switch (state) {
      SignedIn state => state.user,
      UserCreated state => state.credential.user,
      _ => null
    };
    if (user == null) {
      return;
    }
    if (state is UserCreated) {
      user.updateDisplayName(user.email!.split('@')[0]);
    }
    if (!user.emailVerified) {
      user.sendEmailVerification();
      const snackBar = SnackBar(
          content:
              Text('Please check your email to verify your email address'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    context.pushReplacement('/');
  }));
}
