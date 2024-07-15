import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';
import 'package:sos_app/src/core/utils/utils.dart';
import 'package:sos_app/src/features/start_sos/providers/location_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget.current({
    super.key,
  })  : isCurrent = true,
        lat = null,
        long = null;

  const LocationWidget.address({
    super.key,
    required this.lat,
    required this.long,
  }) : isCurrent = false;

  final bool isCurrent;
  final double? lat;
  final double? long;

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  Color get textColor => widget.isCurrent ? Colors.black : Colors.white;

  bool get showDirections => !widget.isCurrent;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.provider<LocationProvider>(listen: false).getLocation(
            isCurrent: widget.isCurrent,
            long: widget.long,
            lat: widget.lat,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        provider.addListener(() {
          if (provider.hasError) {
            showSnackBar(context, "Failed to get your location!");
          }
        });
        if (provider.isLoading || provider.hasError) {
          return const SizedBox(
            height: 90,
          );
        }
        return Container(
          height: showDirections ? 122 : 90,
          decoration: BoxDecoration(
            border: Border.all(color: textColor),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isCurrent
                    ? "Your are currently at"
                    : "His Current Location",
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge?.copyWith(color: textColor),
                maxLines: 1,
              ),
              Text(
                provider.address,
                style:
                    context.textTheme.titleMedium?.copyWith(color: textColor),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              if (showDirections)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        openGoogleMapsAppOrWeb(widget.lat!, widget.long!);
                      },
                      child: Text(
                        'See Directions'.toUpperCase(),
                        style: context.textTheme.labelMedium
                            ?.copyWith(color: textColor, fontSize: 18),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }


  Future<void> openGoogleMapsAppOrWeb(double latitude, double longitude) async {
    final Uri geoUri = Uri.parse('geo:$latitude,$longitude');
    final Uri webUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    // Attempt to open in Google Maps app
    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri);
    } else {
      // Fallback to opening in a web browser
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri);
      } else {
        throw 'Could not open the map.';
      }
    }
  }
}
