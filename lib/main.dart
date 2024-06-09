import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_list_app/services/firebase_serviceList.dart';
import 'package:shopping_list_app/services/firebase_serviceSite.dart';
import 'package:shopping_list_app/services/firebase_servicesItem.dart';
import 'firebase_options.dart';
import 'package:shopping_list_app/components/item.dart';
import 'package:shopping_list_app/components/list.dart';
import 'package:shopping_list_app/components/site.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: Home(),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
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
                ItemList(items: items),
                SiteList(sites: sites),
                ListList(lists: lists),
              ],
            );
          }
        },
      ),
    );
  }
}