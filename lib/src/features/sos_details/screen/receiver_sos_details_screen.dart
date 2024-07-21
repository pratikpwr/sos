import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/injector/injection_container.dart';
import '../../../ui/atomic/molecules/current_location_widget.dart';
import '../../../ui/atomic/molecules/network_gallery_view.dart';
import '../../../ui/themes/colors.dart';
import '../models/user_details_model.dart';
import '../providers/sos_details_provider.dart';
import '../widgets/person_summary_widget.dart';

class ReceiverSOSDetailsScreen extends StatelessWidget {
  const ReceiverSOSDetailsScreen({
    super.key,
    required this.sosId,
  });

  final int sosId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          SOSDetailsProvider(sl())..getSOSDetails(sosId),
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
                  child: SingleChildScrollView(
                    // width: double.infinity,
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
                        const SizedBox(height: 12),
                        // if (provider.sosDetails!.acceptorUsers.length > 2)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "People On The Way",
                                style: context.textTheme.headlineSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    provider.sosDetails!.acceptorUsers.length,
                                itemBuilder: (context, index) {
                                  return PersonSummaryWidget(
                                    person: provider
                                        .sosDetails!.acceptorUsers[index],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Attachments",
                            textAlign: TextAlign.left,
                            style: context.textTheme.headlineSmall
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          // height: context.screenHeight * 0.35,
                          // width: context.screenWidth * 0.4,
                          child: NetworkGalleryView(
                            mediaFiles: provider.sosDetails!.mediaFileUrls,
                          ),
                        ),
                        // const Spacer(),
                        const SizedBox(height: 120)
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
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final url = Uri.parse('tel:${user.phone}');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.call_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text(
                      user.phone,
                      style: context.textTheme.titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
