import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_servicesItem.dart'; // Importa tu servicio de Firebase

class EditItem extends StatefulWidget {
  const EditItem({Key? key}) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
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
    // Obtener los argumentos de la ruta
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    // Asignar los valores a los controladores si existen en los argumentos
    listController.text = arguments['list'] ?? '';
    nameController.text = arguments['name'] ?? '';
    siteController.text = arguments['site'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: listController,
              decoration: const InputDecoration(
                labelText: 'Ingrese la nueva lista a la que pertenece el Item',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ingrese el nuevo nombre del Item',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: siteController,
              decoration: const InputDecoration(
                labelText: 'Ingrese el nuevo sitio al que pertenece el Item',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                // Obtén los valores actualizados de los controladores
                final String list = listController.text;
                final String name = nameController.text;
                final String site = siteController.text;
              
                // Obtén el UID del ítem desde los argumentos
                final String uid = arguments['uid'];

                // Llama al método updatedItem para actualizar el ítem en Firebase Firestore
                await updateItem(uid, list, name, site);
                
                // Muestra algún mensaje de éxito o realiza otras acciones después de la actualización
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item actualizado con éxito')),
                );
              },
              child: const Text("Actualizar"),
            ),
          ],
        ),
      ),
    );
  }
}
