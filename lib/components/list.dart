import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(BuildContext, String) onDelete;

  const ItemList({Key? key, required this.items, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6, // Ajusta el tamaño como necesites
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              onDelete(context, item['id']);
            },
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.only(right: 20.0),
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Nombre: ${item['name'] ?? 'sin nombre'}'),
                  subtitle: Text('Id del sitio: ${item['siteId'] ?? 'Sin siteId'}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/editItem',
                      arguments: {
                        "listId": item['listId'] ?? '',
                        "name": item['name'] ?? '',
                        "site": item['siteId'] ?? '',
                        "uid": item['id'] ?? '',
                      },
                    );
                  },
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
