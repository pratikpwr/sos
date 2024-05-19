import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/injector/injection_container.dart';
import '../../../ui/themes/colors.dart';
import '../providers/sos_details_provider.dart';
import '../widgets/mark_safe_button.dart';
import '../widgets/person_summary_widget.dart';
import '../widgets/sos_active_widget.dart';

class UserSOSDetailsScreen extends StatelessWidget {
  final int sosId;

  const UserSOSDetailsScreen({
    super.key,
    required this.sosId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          SOSDetailsProvider(sl())..getSOSDetails(sosId),
      child: Scaffold(
        backgroundColor: AppColors.dangerRed,
        // appBar: AppBar(
        //   title: Text("Help is on the way!!!"),
        // ),
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MarkSafeButton(sosId: sosId),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Don't Panic!\nYour location has been Shared!",
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          const SOSActiveWidget(),
                          provider.sosDetails!.acceptorUsers.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "People On The Way",
                                        style: context.textTheme.headlineSmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      const SizedBox(height: 12),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: provider
                                            .sosDetails!.acceptorUsers.length,
                                        itemBuilder: (context, index) {
                                          return PersonSummaryWidget(
                                            person: provider.sosDetails!
                                                .acceptorUsers[index],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "No one has accepted your Request yet!",
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.headlineSmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                        ],
                      ),
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
}
