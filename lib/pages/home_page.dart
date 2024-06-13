import 'package:flutter/material.dart';
import 'package:shopping_list_app/components/list.dart';
import 'package:shopping_list_app/services/firebase_servicesItem.dart';
import 'package:shopping_list_app/services/firebase_serviceSite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<List<Map<String, dynamic>>>> _future;

  // Lista de items predefinidos
  List<Map<String, dynamic>> predefinedItems = [
    {
      "listId": "item1",
      "name": "Leche",
      "site": "Supermercado A",
    },
    {
      "listId": "item2",
      "name": "Pan",
      "site": "Panaderia B",
    },
    {
      "listId": "item3",
      "name": "Manzanas",
      "site": "Frutería C",
    },
    {
      "listId": "item4",
      "name": "Pasta",
      "site": "Supermercado A",
    },
    {
      "listId": "item5",
      "name": "Jabón",
      "site": "Farmacia D",
    },
  ];

  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  // Obtener datos de los servicios (simulados)
  Future<List<List<Map<String, dynamic>>>> _fetchData() async {
    try {
      final itemData = await getShoppingItem();
      final siteData = await getShoppingSite();
      if (itemData == null || siteData == null) {
        throw Exception("Error al obtener datos.");
      }
      return [
        itemData.cast<Map<String, dynamic>>().toList(),
        siteData.cast<Map<String, dynamic>>().toList(),
      ];
    } catch (e) {
      throw Exception("Error al obtener datos: $e");
    }
  }

  // Confirmar eliminación de un item
  Future<void> _confirmDeleteItem(BuildContext context, String itemId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro que quieres eliminar este ítem?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Eliminar'),
              onPressed: () async {
                await deleteItem(itemId);
                setState(() {
                  _future = Future.wait([
                    getShoppingItem().then((value) => value.cast<Map<String, dynamic>>().toList()),
                    getShoppingSite().then((value) => value.cast<Map<String, dynamic>>().toList()),
                  ]);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Mostrar la lista de items predefinidos en un AlertDialog
  void _showPredefinedItems(BuildContext context) async {
    final siteData = await getShoppingSite();
    final siteNames = siteData.map((site) => site['name'] as String).toList();
    final itemData = await getShoppingItem();
    final itemNames = itemData.map((item) => item['name'] as String).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Lista de Items Predefinida"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: predefinedItems.length,
              itemBuilder: (context, index) {
                final item = predefinedItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text(item['site']),
                  onTap: () async {
                    // Validar que el sitio y el nombre existen antes de agregar el item
                    if (siteNames.contains(item['site']) && !itemNames.contains(item['name'])) {
                      await addItem(item['listId'], item['name'], item['site']);

                      // Actualizar la lista mostrada
                      setState(() {
                        _future = Future.wait([
                          getShoppingItem().then((value) => value.cast<Map<String, dynamic>>().toList()),
                          getShoppingSite().then((value) => value.cast<Map<String, dynamic>>().toList()),
                        ]);
                      });

                      Navigator.of(context).pop(); // Cerrar el diálogo
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('El sitio "${item['site']}" no existe o el ítem "${item['name']}" ya está en la lista.')),
                      );
                    }
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Lista de Compras'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay datos disponibles'),
            );
          } else {
            final items = snapshot.data![0];
            final sites = snapshot.data![1];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildSection('Productos', items.isNotEmpty
                          ? ItemList(items: items, onDelete: _confirmDeleteItem)
                          : const Text('No hay ítems')),
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // Padding abajo
            child: FloatingActionButton(
              onPressed: () {
                _navigateToAddItem(context);
              },
              tooltip: 'Agregar Item',
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add_business_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // Padding abajo
            child: FloatingActionButton(
              onPressed: () {
                _navigateToAddSite(context);
              },
              tooltip: 'Agregar Sitio',
              backgroundColor: Colors.teal,
              child: const Icon(Icons.luggage_rounded),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              _showPredefinedItems(context);
            },
            tooltip: 'Mostrar Items Predefinidos',
            backgroundColor: Colors.teal,
            child: const Icon(Icons.list),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 12.0),
          content,
        ],
      ),
    );
  }

  void _navigateToAddItem(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/addItem');
    if (result == true) {
      setState(() {
        _future = _fetchData();
      });
    }
  }

  void _navigateToAddSite(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/addSite');
    if (result == true) {
      setState(() {
        _future = _fetchData();
      });
    }
  }
}


