import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_serviceList.dart';

class AddList extends StatefulWidget {
  const AddList({super.key});

  @override
  _AddListState createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _saveList() async {
    final String date = dateController.text;

    await addList(date);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lista guardada con éxito')),
    );

    idController.clear();
    dateController.clear();

    Navigator.of(context).pop(); // Cerrar el modal después de guardar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Lista"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID de la lista',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Fecha',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _saveList,
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
