import 'package:flutter/material.dart';

class ListList extends StatelessWidget {
  final List<Map<String, dynamic>> lists;

  const ListList({super.key, required this.lists});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lists',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lists.length,
          itemBuilder: (context, index) {
            final list = lists[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('List Id: ${list['id']}'),
                Text('Date: ${list['date']}'),
                const Divider(),
              ],
            );
          },
        ),
      ],
    );
  }
}