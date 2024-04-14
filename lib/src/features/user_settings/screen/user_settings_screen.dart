import 'package:flutter/material.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Settings',
          style: context.textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Center(child: Text("Add your Emergency Details")),
    );
  }
}
