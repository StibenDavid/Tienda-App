import "package:cloud_firestore/cloud_firestore.dart";

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getShoppingItem() async {
  List<Map<String, dynamic>> shoppingItems = [];

  QuerySnapshot queryItem = await db.collection('ShoppingItem').get();

  queryItem.docs.forEach((documento) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final item = {
      "uid": documento.id,
      "listId": data['listId'],
      "name": data['name'],
      "siteId": data['siteId']
    };
    shoppingItems.add(item);
    print('Item retrieved: $item'); // Print statement to debug
  });

  return shoppingItems;
}


Future<void> addItem(String listId, String newName, String newsiteId) async {
  await db.collection("ShoppingItem").add({
    "listId": listId,
    "name": newName,
    "siteId": newsiteId
  });
}

Future<void> updateItem(String uid, String newlistId, String newName, String newsiteId) async {
  await db.collection("ShoppingItem").doc(uid).set({
    "listId": newlistId,
    "name": newName,
    "siteId": newsiteId
  });
}

Future<void> deleteItem(String uid) async {
  await db.collection("ShoppingItem").doc(uid).delete();
}
