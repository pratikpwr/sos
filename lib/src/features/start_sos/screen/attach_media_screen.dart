import 'package:flutter/material.dart';

class AttachMediaScreen extends StatelessWidget {
  const AttachMediaScreen({
    super.key,
    required this.sosId,
  });

  final String sosId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("We have sent Signal!"),
      ),
    );
  }
}
