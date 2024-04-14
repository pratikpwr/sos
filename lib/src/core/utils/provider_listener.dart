import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderListener<T extends ChangeNotifier> extends StatelessWidget {
  const ProviderListener({
    super.key,
    required this.child,
    required this.listener,
  });

  final Widget child;
  final Function(BuildContext context, T value) listener;

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (BuildContext context, value, _) {
        value.addListener(() {
          listener(context, value);
        });
        return child;
      },
    );
  }
}

class ProviderConsumer<T extends ChangeNotifier> extends StatelessWidget {
  const ProviderConsumer({
    super.key,
    required this.listener,
    required this.builder,
  });

  final Widget Function(BuildContext context, T value) builder;
  final Function(BuildContext context, T value) listener;

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (BuildContext context, value, _) {
        value.addListener(() {
          listener(context, value);
        });
        return builder(context, value);
      },
    );
  }
}
