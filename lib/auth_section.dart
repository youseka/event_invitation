import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../src/authentication.dart';

class AuthSection extends StatelessWidget {
  const AuthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => AuthFunc(
        loggedIn: appState.loggedIn,
        signOut: () {
          FirebaseAuth.instance.signOut();
        },
      ),
    );
  }
}
