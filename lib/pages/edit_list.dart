import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_serviceList.dart';

class EditList extends StatefulWidget {
  final String listId;
  final String initialDate;

  const EditList({Key? key, required this.listId, required this.initialDate}) : super(key: key);

  @override
  _EditListState createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  late TextEditingController idController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.listId);
    dateController = TextEditingController(text: widget.initialDate);
  }

  @override
  void dispose() {
    idController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _updateList() async {
    final String date = dateController.text;

    await updateList(widget.listId, date);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lista actualizada con éxito')),
    );

    Navigator.of(context).pop(); // Cerrar el modal después de actualizar
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _updateList,
              child: const Text("Actualizar"),
            ),
          ],
        ),
      ),
    );
  }
}