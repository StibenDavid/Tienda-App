import 'package:flutter/material.dart';

class SiteList extends StatelessWidget {
  final List<Map<String, dynamic>> sites;

  const SiteList({super.key, required this.sites});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sites',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sites.length,
          itemBuilder: (context, index) {
            final site = sites[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Site Id: ${site['id']}'),
                Text('Date: ${site['date']}'),
                Text('Name: ${site['name']}'),
                const Divider(),
              ],
            );
          },
        ),
      ],
    );
  }
}