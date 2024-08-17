import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/features/auth/providers/auth_provider.dart';
import 'package:sos_app/src/features/auth/providers/auth_status_provider.dart';
import 'package:sos_app/src/features/auth/screens/sign_in_screen.dart';
import 'package:sos_app/src/features/start_sos/providers/location_provider.dart';
import 'package:sos_app/src/core/utils/notification_config.dart';
import 'package:sos_app/src/ui/atomic/organism/sos_bttom_bar.dart';
import 'package:sos_app/src/ui/themes/text_theme.dart';

import 'core/injector/injection_container.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotificationConfig.setupForegroundMessaging(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider(sl())),
        ChangeNotifierProvider(
            create: (_) => AuthStatusProvider(sl())..isSignIn()),
        ChangeNotifierProvider(create: (_) => AuthProvider(sl())),
      ],
      child: Builder(builder: (context) {
        return Consumer<AuthStatusProvider>(
          builder: (context, provider, child) {
            return MaterialApp(
              title: 'SOS App',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
                textTheme: textTheme,
                useMaterial3: true,
              ),
              debugShowCheckedModeBanner: false,
              home: provider.isAuthenticated
                  ? const SOSBottomNavBar()
                  : SignInScreen(),
            );
          },
        );
      }),
    );
  }
}
