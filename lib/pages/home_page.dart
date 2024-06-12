import 'package:flutter/material.dart';
import 'package:shopping_list_app/pages/edit_list.dart';
import 'package:shopping_list_app/services/firebase_serviceList.dart';
import 'package:shopping_list_app/services/firebase_serviceSite.dart';
import 'package:shopping_list_app/services/firebase_servicesItem.dart';
import 'package:shopping_list_app/components/item.dart';
import 'package:shopping_list_app/components/list.dart';
import 'package:shopping_list_app/components/site.dart';
import 'package:shopping_list_app/pages/add_item.dart';
import 'package:shopping_list_app/pages/add_site.dart';
import 'package:shopping_list_app/pages/add_list.dart';

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
    final listData = await getShoppingList();
    return [
      itemData.cast<Map<String, dynamic>>().toList(),
      siteData.cast<Map<String, dynamic>>().toList(),
      listData.cast<Map<String, dynamic>>().toList(),
    ];
  }

  Future<void> _confirmDelete(BuildContext context, String id, String collection) async {
    String itemName = '';
    try {
      switch (collection) {
        case 'items':
          itemName = await getItemName(id);
          await deleteItem(id);
          break;
        case 'sites':
          itemName = await getSiteName(id);
          await deleteSite(id);
          break;
        case 'lists':
          itemName = await getListName(id);
          await deleteList(id);
          break;
        default:
          throw Exception('Unsupported collection: $collection');
      }

      setState(() {
        _future = _fetchData();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Elemento "$itemName" eliminado correctamente'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el elemento: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _editList(BuildContext context, String listId, String date) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditList(listId: listId, initialDate: date)),
    );
    setState(() {
      _future = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tienda'),
      ),
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final items = snapshot.data![0];
            final sites = snapshot.data![1];
            final lists = snapshot.data![2];

            return ListView(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              children: [
                _buildSectionTitle('Items'),
                _buildItemList(items),
                _buildSectionTitle('Sites'),
                _buildSiteList(sites),
                _buildSectionTitle('Lists'),
                _buildListList(lists),
              ],
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Item()),
              ).then((_) {
                setState(() {
                  _future = _fetchData();
                });
              });
            },
            tooltip: 'Añadir ítem',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddSite()),
              ).then((_) {
                setState(() {
                  _future = _fetchData();
                });
              });
            },
            tooltip: 'Añadir sitio',
            child: Icon(Icons.add_location),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddList()),
              ).then((_) {
                setState(() {
                  _future = _fetchData();
                });
              });
            },
            tooltip: 'Añadir lista',
            child: Icon(Icons.playlist_add),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildItemList(List<Map<String, dynamic>> items) {
    if (items.isNotEmpty) {
      return ItemList(
        items: items,
        onDelete: (context, itemId) => _confirmDelete(context, itemId, 'items'),
      );
    } else {
      return ListTile(
        title: Text('No hay ítems'),
      );
    }
  }

  Widget _buildSiteList(List<Map<String, dynamic>> sites) {
    if (sites.isNotEmpty) {
      return SiteList(
        sites: sites,
        onDelete: (context, siteId) => _confirmDelete(context, siteId, 'sites'),
      );
    } else {
      return ListTile(
        title: Text('No hay sitios'),
      );
    }
  }

  Widget _buildListList(List<Map<String, dynamic>> lists) {
    if (lists.isNotEmpty) {
      return ListList(
        lists: lists,
        onDelete: (context, listId) => _confirmDelete(context, listId, 'lists'),
        onEdit: _editList,
      );
    } else {
      return ListTile(
        title: Text('No hay listas'),
      );
    }
  }
}
