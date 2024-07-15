import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/features/my_circle/screen/my_circle_screen.dart';
import 'package:sos_app/src/features/start_sos/providers/location_provider.dart';
import 'package:sos_app/src/features/user_settings/screen/user_settings_screen.dart';
import 'package:sos_app/src/ui/themes/text_theme.dart';

import 'core/injector/injection_container.dart';
import 'features/start_sos/screen/start_sos_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider(sl())),
      ],
      child: MaterialApp(
        title: 'SOS App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          textTheme: textTheme,
          useMaterial3: true,
        ),
        home: const SOSBottomNavBar(),
      ),
    );
  }
}

class SOSBottomNavBar extends StatefulWidget {
  const SOSBottomNavBar({super.key});

  @override
  State<SOSBottomNavBar> createState() => _SOSBottomNavBarState();
}

class _SOSBottomNavBarState extends State<SOSBottomNavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.group_rounded),
            icon: Icon(Icons.group_outlined),
            label: 'My Circle',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings_rounded),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      body: _currentWidget(),
    );
  }

  Widget _currentWidget() {
    switch (currentPageIndex) {
      case 0:
        return StartSOSScreen();
      case 1:
        return MyCircleScreen();
      case 2:
        return UserSettingsScreen();
      default:
        return StartSOSScreen();
    }
  }
}
