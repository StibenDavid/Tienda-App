import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(BuildContext, String) onDelete;

  const ItemList({Key? key, required this.items, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          if (item['uid'] == null || item['uid'].toString().isEmpty) {
            print('Error: Item ID is null or empty');
            return Container(); // O muestra algún mensaje de error en lugar de un contenedor vacío
          }

          return Dismissible(
            key: Key(item['id'].toString()),
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
              title: Row(
                children: [
                  Expanded(
                    child: Text('Nombre: ${item['name'] ?? 'sin nombre'}'),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text('Sitio: ${item['siteId'] ?? 'Sin sitio'}'),
                  ),
                ],
              ),
              onTap: () {
                final String uid = item['uid'];

                Navigator.pushNamed(
                  context,
                  '/editItem',
                  arguments: {
                    "listId": item['listId'] ?? '',
                    "name": item['name'] ?? '',
                    "site": item['siteId'] ?? '',
                    "uid": uid,
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
