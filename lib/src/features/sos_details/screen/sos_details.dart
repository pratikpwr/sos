import 'package:flutter/material.dart';

class SOSDetails extends StatelessWidget {
  final int sosId;

  const SOSDetails({
    super.key,
    required this.sosId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBar(
        title: Text("Help is on the way!!!"),
      ),
    );
  }
}
