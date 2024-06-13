import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_servicesItem.dart'; // Importa tu servicio de Firebase
import 'package:shopping_list_app/services/firebase_serviceSite.dart'; // Importa tu servicio de Firebase

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
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

  void guardarItem() async {
    final String lista = listController.text;
    final String nombre = nameController.text;
    final String sitio = selectedSite ?? ''; // Obtener el sitio seleccionado

    // Validar que todos los campos están llenos y el sitio es válido
    if (lista.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese la lista')),
      );
      return;
    }

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese el nombre del ítem')),
      );
      return;
    }

    if (!siteNames.contains(sitio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor elija un sitio válido')),
      );
      return;
    }

    // Si todas las validaciones pasan, agregar el ítem
    await addItem(lista, nombre, sitio);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ítem guardado con éxito')),
    );

    listController.clear();
    nameController.clear();
    setState(() {
      selectedSite = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Ítem"),
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
              onPressed: guardarItem,
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
