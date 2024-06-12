import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_servicesItem.dart'; // Importa tu servicio de Firebase

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

  void guardarItem() async {
    // Obtener los valores de los controladores
    final String lista = listController.text;
    final String nombre = nameController.text;
    final String sitio = siteController.text;

    // Llamar al método addItem para guardar el nuevo ítem
    await addItem(lista, nombre, sitio);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ítem guardado con éxito')),
    );

    listController.clear();
    nameController.clear();
    siteController.clear();
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
                labelText: 'Ingrese la lista a la que pertenece el ítem',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ingrese el nombre del nuevo ítem',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: siteController,
              decoration: const InputDecoration(
                labelText: 'Ingrese el sitio al que pertenece el nuevo ítem',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: guardarItem,
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
