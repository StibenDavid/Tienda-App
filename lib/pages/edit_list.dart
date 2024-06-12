import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_serviceList.dart';

class EditList extends StatefulWidget {
  const EditList({Key? key}) : super(key: key);

  @override
  _EditListState createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  late TextEditingController idController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    dateController = TextEditingController();
  }

  @override
  void dispose() {
    idController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _updateList(String listId) async {
    final String date = dateController.text;

    await updateList(listId, date);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lista actualizada con éxito')),
    );

    Navigator.of(context).pop(); // Cerrar el modal después de actualizar
  }

  @override
  Widget build(BuildContext context) {
    // Obtener los argumentos de la ruta
    final Map<String, dynamic>? arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Asignar los valores a los controladores si existen en los argumentos
    if (arguments != null) {
      idController.text = arguments['listId'] ?? '';
      dateController.text = arguments['date'] ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Lista"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: idController,
              enabled: false, // No permitir editar el ID de la lista
              decoration: const InputDecoration(
                labelText: 'ID de la lista',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Nueva Fecha',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Obtén el ID de la lista de los controladores
                final String listId = idController.text;
                _updateList(listId); // Llama a la función para actualizar la lista
              },
              child: const Text("Actualizar"),
            ),
          ],
        ),
      ),
    );
  }
}
