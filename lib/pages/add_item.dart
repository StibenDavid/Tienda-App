import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  const Item({Key? key}) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  final TextEditingController listController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController siteController = TextEditingController();

  @override
  void dispose() {
    listController.dispose();
    nameController.dispose();
    siteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: listController,
              decoration: const InputDecoration(
                labelText: 'Ingrese la lista a la que pertenece el item',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ingrese el nombre del nuevo item',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: siteController,
              decoration: const InputDecoration(
                labelText: 'Ingrese el sitio al que pertenece el nuevo item',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Aquí agregarás la lógica para guardar el nuevo item
                // usando los valores de listController, nameController, y siteController
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
