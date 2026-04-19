import 'package:flutter/material.dart';

import 'core/strings.dart';
import 'core/theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/root_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }

        final mediaQuery = MediaQuery.of(context);
        final fixedSize = const Size(402, 874);
        final override = mediaQuery.copyWith(
          size: fixedSize,
          viewPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
        );

        return MediaQuery(
          data: override,
          child: Center(
            child: SizedBox(
              width: fixedSize.width,
              height: fixedSize.height,
              child: child,
            ),
          ),
        );
      },
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool loggedIn = false;

  void _handleLogin() {
    setState(() => loggedIn = true);
  }

  void _handleLogout() {
    setState(() => loggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return loggedIn
        ? RootShell(onLogout: _handleLogout)
        : LoginScreen(onLogin: _handleLogin);
  }
}
