import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_list_app/pages/add_item.dart';
import 'package:shopping_list_app/pages/add_list.dart';
import 'package:shopping_list_app/pages/add_site.dart';
import 'package:shopping_list_app/pages/edit_item.dart';
import 'package:shopping_list_app/pages/edit_list.dart';
import 'package:shopping_list_app/pages/edit_site.dart';
import 'package:shopping_list_app/pages/home_page.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/addItem': (context) => const Item(),
        '/editItem': (context) => const EditItem(),
        '/addSite': (context) => const AddSite(),
        '/editSite': (context) => const EditSite(),
        '/editList': (context) => const EditList(),
        '/addList': (context) => const AddList(),
      },
    );
  }
}

