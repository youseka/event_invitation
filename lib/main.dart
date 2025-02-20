import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // new

import 'app_routes.dart'; // new
import 'app_state.dart'; // new
import 'app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // changenotifierprovider is a provider that allows you to listen to changes in the state of the application
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Firebase Meetup',
      theme: buildAppTheme(context),
      routerConfig: AppRoutes.router, // new
    );
  }
}
