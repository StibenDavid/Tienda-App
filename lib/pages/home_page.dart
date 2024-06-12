import 'package:flutter/material.dart';
import 'package:shopping_list_app/components/list.dart';
import 'package:shopping_list_app/services/firebase_serviceList.dart';
import 'package:shopping_list_app/services/firebase_serviceSite.dart';
import 'package:shopping_list_app/services/firebase_servicesItem.dart';
import 'package:shopping_list_app/components/item.dart';
import 'package:shopping_list_app/components/site.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<List<Map<String, dynamic>>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  Future<List<List<Map<String, dynamic>>>> _fetchData() async {
    final itemData = await getShoppingItem();
    final siteData = await getShoppingSite();
    return [
      itemData.cast<Map<String, dynamic>>().toList(),
      siteData.cast<Map<String, dynamic>>().toList(),
    ];
  }

  Future<void> _confirmDeleteItem(BuildContext context, String itemId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
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

  Future<void> _confirmDeleteSite(BuildContext context, String siteId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this site?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await deleteSite(siteId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda'),
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
          } else {
            final items = snapshot.data![0];
            final sites = snapshot.data![1];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildSection('Items', items.isNotEmpty
                          ? ItemList(items: items, onDelete: _confirmDeleteItem)
                          : const Text('No hay ítems')),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: _buildSection('Sites', sites.isNotEmpty
                          ? SiteList(sites: sites, onDelete: _confirmDeleteSite)
                          : const Text('No hay sitios')),
                    ),
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
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addItem');
            },
            tooltip: 'Add Item',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16.0), // Espacio entre botones flotantes
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addSite');
            },
            tooltip: 'Add Site',
            child: const Icon(Icons.add),
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          content,
        ],
      ),
    );
  }
}
