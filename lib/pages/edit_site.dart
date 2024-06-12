import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_serviceSite.dart'; // Importa tu servicio de Firebase

class EditSite extends StatefulWidget {
  const EditSite({Key? key}) : super(key: key);

  @override
  State<EditSite> createState() => _EditSiteState();
}

class _EditSiteState extends State<EditSite> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener los argumentos de la ruta
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Asignar los valores a los controladores si existen en los argumentos
    idController.text = arguments['siteId'] ?? '';
    nameController.text = arguments['name'] ?? '';
    dateController.text = arguments['date'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Sitio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              enabled: false, // No permitir editar el ID del sitio
              decoration: const InputDecoration(
                labelText: 'ID del sitio',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del sitio',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Fecha del sitio',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                // Obtén los valores actualizados de los controladores
                final String id = idController.text;
                final String name = nameController.text;
                final String date = dateController.text;

                // Llama al método updateSite para actualizar el sitio en Firebase Firestore
                await updateSite(id, name, date);

                // Muestra algún mensaje de éxito o realiza otras acciones después de la actualización
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sitio actualizado con éxito')),
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
