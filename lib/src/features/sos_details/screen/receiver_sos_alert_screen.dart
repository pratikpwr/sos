import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/features/sos_details/models/user_details_model.dart';
import 'package:sos_app/src/features/sos_details/providers/receiver_alert_provider.dart';
import 'package:sos_app/src/features/start_sos/widgets/current_location_widget.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/injector/injection_container.dart';
import '../../../ui/themes/colors.dart';
import '../providers/sos_details_provider.dart';

class ReceiverAlertScreen extends StatelessWidget {
  final int sosId;

  const ReceiverAlertScreen({
    super.key,
    required this.sosId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                SOSDetailsProvider(sl())..getSOSDetails(sosId)),
        ChangeNotifierProvider(
            create: (BuildContext context) => ReceiverAlertProvider(sl()))
      ],
      child: Scaffold(
        backgroundColor: AppColors.dangerRed,
        body: SafeArea(
          child: Consumer<SOSDetailsProvider>(
            builder: (context, provider, child) {
              if (provider.sosStatus == SosDetailsStatus.loading) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    radius: 32,
                  ),
                );
              }
              if (provider.sosStatus == SosDetailsStatus.loading) {
                return Center(
                  child: Text(
                    "Failure",
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                );
              } else if (provider.sosStatus == SosDetailsStatus.success &&
                  provider.sosDetails != null) {
                return RefreshIndicator(
                  onRefresh: () async => provider.getSOSDetails(sosId),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        userDetails(
                          context,
                          provider.sosDetails!.userDetails,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Your friend is in need of your Help!",
                          textAlign: TextAlign.center,
                          style: context.textTheme.headlineSmall
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: LocationWidget.address(
                            long: provider.sosDetails!.long ?? 0,
                            lat: provider.sosDetails!.lat ?? 0,
                          ),
                        ),
                        Spacer(),
                        Consumer<ReceiverAlertProvider>(
                          builder: (context, alertProvider, child) {
                            if (alertProvider.acceptStatus ==
                                SosAcceptStatus.loading) {
                              return const Center(
                                child: CupertinoActivityIndicator(
                                  radius: 32,
                                ),
                              );
                            } else if (alertProvider.acceptStatus ==
                                SosAcceptStatus.failed) {
                              return Center(
                                child: Text(
                                  "Failure to accept, Please call him!",
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.headlineSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              );
                            }
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton.filledTonal(
                                    onPressed: () {
                                      context.popScreen();
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 64,
                                      color: AppColors.dangerRed,
                                    ),
                                  ),
                                  IconButton.filledTonal(
                                    onPressed: () {
                                      alertProvider.acceptSOSRequest(
                                        sosId,
                                        onAccept: () {},
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.check_rounded,
                                      size: 64,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 120,
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget userDetails(BuildContext context, UserDetailsModel user) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (user.photoUrl != null && user.photoUrl!.isNotEmpty)
            Container(
              height: context.screenWidth * 0.3,
              width: context.screenWidth * 0.3,
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(200),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                user.photoUrl!,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                user.name,
                style: context.textTheme.headlineMedium
                    ?.copyWith(color: Colors.white),
              ),
              Text(
                user.bloodGroup ?? "-",
                style:
                    context.textTheme.titleLarge?.copyWith(color: Colors.white),
              )
            ],
          ),
        ],
      ),
    );
  }
}
