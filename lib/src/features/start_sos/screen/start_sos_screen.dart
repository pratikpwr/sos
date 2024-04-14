import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';
import 'package:sos_app/src/features/start_sos/providers/location_provider.dart';
import 'package:sos_app/src/features/start_sos/providers/sos_button_provider.dart';
import 'package:sos_app/src/features/start_sos/widgets/current_location_widget.dart';
import 'package:sos_app/src/features/start_sos/widgets/sos_button.dart';

class StartSOSScreen extends StatelessWidget {
  const StartSOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Send Distress Signal',
          style: context.textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SOSButtonProvider()),
          ChangeNotifierProvider(
              create: (context) => LocationProvider()..getLocation()),
        ],
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 12),
              CurrentLocationWidget(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hold the Button for ${kMaxSeconds + 1} seconds to send Signal!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 36),
                    SOSButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
