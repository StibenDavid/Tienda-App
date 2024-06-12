import 'package:flutter/material.dart';

class ListList extends StatelessWidget {
  final List<Map<String, dynamic>> lists;
  final Function(BuildContext, String) onDelete;

  const ListList({
    Key? key,
    required this.lists,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Lists',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: lists.length,
          itemBuilder: (context, index) {
            final list = lists[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                onDelete(context, list['id']);
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
                    title: Text('List Id: ${list['id']}'),
                    subtitle: Text('Date: ${list['date']}'),
                    onTap: () {
                      // Navegar a la pantalla de edición con los argumentos adecuados
                      Navigator.pushNamed(
                        context,
                        '/editList',
                        arguments: {
                          "listId": list['id'] ?? '',
                          "date": list['date'] ?? '',
                        },
                      ).then((value) {
                        // Manejar la actualización de datos después de la edición
                        if (value == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('List updated')),
                          );
                          // Aquí puedes llamar a una función para actualizar los datos de la lista en Home
                          // Por ejemplo, puedes hacer una llamada a la función _fetchData para actualizar _future
                        }
                      });
                    },
                  ),
                  const Divider(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
