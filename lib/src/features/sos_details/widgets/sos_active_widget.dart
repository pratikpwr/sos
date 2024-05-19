import 'package:flutter/material.dart';

import '../../../core/extensions/context_extension.dart';

class SOSActiveWidget extends StatelessWidget {
  const SOSActiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24.0),
      height: context.screenHeight * 0.4,
      width: context.screenWidth * 0.8,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.7),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "SOS",
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall
                    ?.copyWith(color: Colors.white),
              ),
              Text(
                "is Activated",
                textAlign: TextAlign.center,
                style:
                    context.textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
