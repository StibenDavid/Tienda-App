import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_servicesItem.dart'; // Importa tu servicio de Firebase
import 'package:shopping_list_app/services/firebase_serviceSite.dart'; // Importa tu servicio de Firebase

class EditItem extends StatefulWidget {
  const EditItem({Key? key}) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final TextEditingController listController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? selectedSite;

  List<String> siteNames = []; // Lista para almacenar los nombres de los sitios

  @override
  void initState() {
    super.initState();
    _fetchSiteNames(); // Obtener los nombres de los sitios al iniciar la pantalla
  }

  Future<void> _fetchSiteNames() async {
    final sites = await getShoppingSite(); // Método para obtener la lista de sitios
    setState(() {
      siteNames = sites.map((site) => site['name'] as String).toList();
    });
  }

  @override
  void dispose() {
    listController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener los argumentos de la ruta
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Imprimir argumentos para depuración
    print('Arguments: $arguments');

    // Asignar los valores a los controladores si existen en los argumentos
    listController.text = arguments['list'] ?? '';
    nameController.text = arguments['name'] ?? '';
    selectedSite = arguments['site'] ?? null;

    final String? uid = arguments['uid'];

    // Imprimir UID para depuración
    print('UID: $uid');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Hero(
              tag: 'item_${arguments['uid']}',
              child: CircleAvatar(
                child: Icon(Icons.shopping_cart),
              ),
            ),
            const SizedBox(height: 16.0),
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
            DropdownButtonFormField<String>(
              value: selectedSite,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSite = newValue;
                });
              },
              items: siteNames.map((String siteName) {
                return DropdownMenuItem<String>(
                  value: siteName,
                  child: Text(siteName),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Seleccione el sitio del ítem',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                // Validar UID antes de intentar actualizar
                if (uid == null || uid.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error: UID inválido')),
                  );
                  return;
                }

                // Obtén los valores actualizados de los controladores
                final String list = listController.text;
                final String name = nameController.text;
                final String site = selectedSite ?? '';

                try {
                  // Llama al método updatedItem para actualizar el ítem en Firebase Firestore
                  await updateItem(uid, list, name, site);

                  // Muestra algún mensaje de éxito o realiza otras acciones después de la actualización
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item actualizado con éxito')),
                  );

                  // Navegar hacia atrás después de actualizar
                  Navigator.of(context).pop(true);
                } catch (e) {
                  // Manejo de errores
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar el item: $e')),
                  );
                }
              },
              child: const Text("Actualizar"),
            ),
          ],
        ),
      ),
    );
  }
}
