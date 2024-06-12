import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_serviceSite.dart'; // Importa tu servicio de Firebase

class AddSite extends StatefulWidget {
  const AddSite({Key? key}) : super(key: key);

  @override
  State<AddSite> createState() => _AddSiteState();
}

class _AddSiteState extends State<AddSite> {
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

  void guardarSite() async {
    // Obtener los valores de los controladores
    final String name = nameController.text;
    final String date = dateController.text;

    // Llamar al método addSite para guardar el nuevo sitio
    await addSite(name, date);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sitio guardado con éxito')),
    );

    idController.clear();
    nameController.clear();
    dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Sitio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'Ingrese el ID del sitio',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ingrese el nombre del sitio',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Ingrese la fecha del sitio',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: guardarSite,
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
