import 'package:flutter/material.dart';
import 'package:sos_app/src/ui/themes/text_theme.dart';

import 'features/start_sos/screen/start_sos_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOS App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        textTheme: textTheme,
        useMaterial3: true,
      ),
      home: const StartSOSScreen(),
    );
  }
}
