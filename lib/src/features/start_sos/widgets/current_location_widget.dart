import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';
import 'package:sos_app/src/core/utils/utils.dart';
import 'package:sos_app/src/features/start_sos/providers/location_provider.dart';

import '../../../core/injector/injection_container.dart';

class LocationWidget extends StatelessWidget {
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

  Color get textColor => isCurrent ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationProvider(sl())
        ..getLocation(isCurrent: isCurrent, lat: lat, long: long),
      child: Consumer<LocationProvider>(
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
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(color: textColor),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isCurrent ? "Your are currently at" : "His Current Location",
                  textAlign: TextAlign.center,
                  style:
                      context.textTheme.titleLarge?.copyWith(color: textColor),
                  maxLines: 1,
                ),
                Text(
                  provider.address,
                  style:
                      context.textTheme.titleMedium?.copyWith(color: textColor),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
