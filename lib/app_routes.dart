import 'package:go_router/go_router.dart';

import 'screens/home_page.dart';
import 'screens/profile_screen.dart';
import 'screens/sign_in_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
              path: 'sign-in',
              builder: (context, state) => buildSignInScreen()),
          GoRoute(
              path: 'profile',
              builder: (context, state) => buildProfileScreen()),
        ],
      ),
    ],
  );
}
