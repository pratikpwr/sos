import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/features/start_sos/providers/send_sos_provider.dart';
import 'package:sos_app/src/features/start_sos/widgets/sos_button.dart';


class StartSOSScreen extends StatefulWidget {
  const StartSOSScreen({super.key});

  @override
  State<StartSOSScreen> createState() => _StartSOSScreenState();
}

class _StartSOSScreenState extends State<StartSOSScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Distress Signal'),
        centerTitle: true,
      ),
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
      body: ChangeNotifierProvider(
        create: (context) => SendSOSProvider(),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hold the Button for ${kMaxSeconds + 1} seconds to send Signal!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 24),
              SOSButton(),
            ],
          ),
        ),
      ),
    );
  }
}
