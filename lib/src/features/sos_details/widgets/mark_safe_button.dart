import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/injector/injection_container.dart';
import '../providers/mark_safe_provider.dart';
import '../providers/sos_details_provider.dart';

class MarkSafeButton extends StatelessWidget {
  const MarkSafeButton({
    super.key,
    required this.sosId,
  });

  final int sosId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MarkSafeProvider(sl()),
      child: Consumer<MarkSafeProvider>(
        builder: (context, markSafeProvider, child) {
          return ActionSlider.standard(
            borderWidth: 2,
            toggleColor: Colors.green,
            action: (cntr) {
              final detailsProvider = Provider.of<SOSDetailsProvider>(
                context,
                listen: false,
              );
              detailsProvider.stopSyncing();

              markSafeProvider.setSliderController(cntr);
              markSafeProvider.markSafe(sosId, onSafe: () {
                context.popScreen();
                context.popScreen();
              });
            },
            child: Text(
              'Mark Yourself as Safe',
              style: context.textTheme.titleLarge,
            ),
            icon: const Icon(
              Icons.fast_forward_rounded,
              color: Colors.white,
              size: 32,
            ),
            successIcon: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 32,
            ),
            failureIcon: const Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 32,
            ),
          );
        },
      ),
    );
  }
}
