import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(BuildContext, String) onDelete;

  const ItemList({Key? key, required this.items, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            onDelete(context, item['uid']);
          },
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.only(right: 20.0),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            title: Text(item['name'] ?? 'Sin nombre'),
            subtitle: Text('List ID: ${item['listId']}, Site ID: ${item['siteId']}'),
            onTap: () {
              Navigator.pushNamed(context, '/editItem', arguments: {
                "listId": item['listId'] ?? '',
                "name": item['name'] ?? '',
                "site": item['siteId'] ?? '',
                "uid": item['uid'] ?? '',
              });
            },
          ),
        );
      },
    );
  }
}
