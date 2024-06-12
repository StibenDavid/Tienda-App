import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopping_list_app/services/firebase_serviceList.dart';
import 'package:shopping_list_app/services/firebase_serviceSite.dart';
import 'package:shopping_list_app/services/firebase_servicesItem.dart';
import 'package:shopping_list_app/components/item.dart';
import 'package:shopping_list_app/components/list.dart';
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
    _future = Future.wait([
      getShoppingItem().then((value) => value.cast<Map<String, dynamic>>().toList()),
      getShoppingSite().then((value) => value.cast<Map<String, dynamic>>().toList()),
      getShoppingList().then((value) => value.cast<Map<String, dynamic>>().toList()),
    ]);
  }

  Future<void> _confirmDelete(BuildContext context, String itemId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
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
                    getShoppingList().then((value) => value.cast<Map<String, dynamic>>().toList()),
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
            final items = snapshot.data?[0] ?? [];
            final sites = snapshot.data?[1] ?? [];
            final lists = snapshot.data?[2] ?? [];

            return ListView(
              children: [
                ListTile(
                  title: const Text('Items'),
                  subtitle: items.isNotEmpty ? ItemList(items: items, onDelete: _confirmDelete) : const Text('No hay ítems'),
                ),
                ListTile(
                  title: const Text('Sites'),
                  subtitle: sites.isNotEmpty ? SiteList(sites: sites) : const Text('No hay sitios'),
                ),
                ListTile(
                  title: const Text('Lists'),
                  subtitle: lists.isNotEmpty ? ListList(lists: lists) : const Text('No hay listas'),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
