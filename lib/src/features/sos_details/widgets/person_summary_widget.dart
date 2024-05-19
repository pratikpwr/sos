import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/context_extension.dart';
import '../models/user_details_model.dart';

class PersonSummaryWidget extends StatelessWidget {
  const PersonSummaryWidget({
    super.key,
    required this.person,
  });

  final UserDetailsModel person;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (person.photoUrl != null && person.photoUrl!.isNotEmpty)
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(50),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                person.photoUrl!,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: context.textTheme.titleLarge,
                ),
                Text(
                  person.bloodGroup ?? "-",
                  style: context.textTheme.titleMedium,
                )
              ],
            ),
          ),
          SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed: () {
              _launchPhone(person.phone);
            },
            icon: const Icon(
              Icons.call,
              size: 28,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(String phoneNo) async {
    final url = Uri.parse('tel:$phoneNo');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
