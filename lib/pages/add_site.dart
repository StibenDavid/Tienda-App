import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_serviceSite.dart'; // Importa tu servicio de Firebase

class AddSite extends StatefulWidget {
  const AddSite({Key? key}) : super(key: key);

  @override
  State<AddSite> createState() => _AddSiteState();
}

class _AddSiteState extends State<AddSite> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    if (_formKey.currentState!.validate()) {
      final String id = idController.text.trim();
      final String name = nameController.text.trim();
      final String date = dateController.text.trim();

      // Verificar si el ID ya existe
      final bool siteExists = await checkSiteExists(id);
      if (siteExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El ID del sitio ya existe')),
        );
        return;
      }

      // Llamar al método addSite para guardar el nuevo sitio
      await addSite(name, date);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sitio guardado con éxito')),
      );

      idController.clear();
      nameController.clear();
      dateController.clear();
    }
  }

  Future<bool> checkSiteExists(String id) async {
    final sites = await getShoppingSite();
    return sites.any((site) => site['id'] == id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Sitio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese el ID del sitio',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el ID del sitio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese el nombre del sitio',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del sitio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Ingrese la fecha del sitio',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha del sitio';
                  }
                  // Puedes agregar validaciones adicionales para el formato de fecha si es necesario
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    dateController.text = pickedDate.toString();
                  }
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: guardarSite,
                child: const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
