import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 56,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const CupertinoActivityIndicator(
                    radius: 16,
                  )
                : Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge
                        ?.copyWith(color: Colors.white, fontSize: 22),
                  ),
          ),
        ),
      ),
    );
  }
}
