import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getShoppingList() async {
  List<Map<String, dynamic>> shoppingLists = [];

  QuerySnapshot queryList = await db.collection('ShoppingList').get();

  queryList.docs.forEach((documento) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final list = {
      "id": documento.id,
      "date": data['date'],
    };
    shoppingLists.add(list);
    print('List retrieved: $list'); // Print statement to debug
  });

  return shoppingLists;
}

Future<String> getListName(String listId) async {
  try {
    DocumentSnapshot doc = await db.collection('ShoppingList').doc(listId).get();
    if (doc.exists) {
      return doc['date']; // Cambiado a 'date' en lugar de 'name' para coincidir con los datos guardados
    } else {
      throw Exception('List not found');
    }
  } catch (e) {
    throw Exception('Error fetching list name: $e');
  }
}

Future<void> addList(String date) async {
  await db.collection("ShoppingList").add({
    "date": date,
  });
}

Future<void> updateList(String id, String newDate) async {
  await db.collection("ShoppingList").doc(id).set({
    "date": newDate,
  });
}

Future<void> deleteList(String id) async {
  await db.collection("ShoppingList").doc(id).delete();
}
