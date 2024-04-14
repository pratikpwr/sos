import 'package:flutter/material.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';

class MyCircleScreen extends StatelessWidget {
  const MyCircleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Circle',
          style: context.textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Center(child: Text("Manage your circles")),
    );
  }
}
