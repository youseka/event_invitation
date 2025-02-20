import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:go_router/go_router.dart';

buildProfileScreen() {
  return ProfileScreen(
    providers: const [],
    actions: [
      SignedOutAction((context) {
        context.pushReplacement('/');
      }),
    ],
  );
}
