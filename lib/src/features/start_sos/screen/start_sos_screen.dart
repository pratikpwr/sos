import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';
import 'package:sos_app/src/features/sos_details/screen/receiver_sos_alert_screen.dart';
import 'package:sos_app/src/features/sos_details/screen/receiver_sos_details_screen.dart';
import 'package:sos_app/src/features/start_sos/providers/location_provider.dart';
import 'package:sos_app/src/features/start_sos/providers/send_sos_provider.dart';
import 'package:sos_app/src/features/start_sos/providers/sos_button_provider.dart';
import 'package:sos_app/src/ui/atomic/molecules/current_location_widget.dart';
import 'package:sos_app/src/features/start_sos/widgets/sos_button.dart';

import '../../../core/injector/injection_container.dart';
import '../../../core/utils/utils.dart';
import '../../attach_media/screens/attach_media_screen.dart';

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
          ChangeNotifierProvider(create: (context) => SendSOSProvider(sl())),
        ],
        child: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const LocationWidget.current(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Hold the Button for ${kMaxSeconds + 1} seconds to send Signal!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 36),
                      SOSButton(
                        onSend: () {
                          final sendProvider =
                              context.provider<SendSOSProvider>(listen: false);
                          final locationProvider =
                              context.provider<LocationProvider>(listen: false);

                          sendProvider.sendSOS(
                            position: locationProvider.position,
                            onResponse: (status, sosId) {
                              if (status == SosStatus.sent) {
                                if (sosId != null) {
                                  context.pushScreen(AttachMediaScreen(
                                      sosId: sendProvider.sosId!));
                                } else {
                                  showSnackBar(context,
                                      "Sorry, Something went wrong while sending SOS!");
                                }
                              }
                              if (sendProvider.sosStatus == SosStatus.failed) {
                                showSnackBar(
                                    context, "Sorry, We Failed to Send SOS!");
                              }
                            },
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // context.pushScreen(ReceiverSOSDetailsScreen(sosId: 38));\

                          context.pushScreen(ReceiverAlertScreen(
                              sosId: 38));
                        },

                        child: Text('SOS Alert'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
