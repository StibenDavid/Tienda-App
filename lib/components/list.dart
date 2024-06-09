import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Item Id: ${item['Id']}'),
                Text('ListId: ${item['listId']}'),
                Text('Nombre: ${item['nombre']}'),
                Text('SiteId: ${item['siteId']}'),
                const Divider(),
              ],
            );
          },
        ),
      ],
    );
  }
}