import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';
import 'package:sos_app/src/core/utils/utils.dart';
import 'package:sos_app/src/features/start_sos/providers/location_provider.dart';

class CurrentLocationWidget extends StatelessWidget {
  const CurrentLocationWidget({super.key});

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
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your are currently at",
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge,
                maxLines: 1,
              ),
              Text(
                provider.address,
                style: context.textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
              )
            ],
          ),
        );
      },
    );
  }
}
