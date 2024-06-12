import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getShoppingSite() async {
  List<Map<String, dynamic>> shoppingSites = [];

  QuerySnapshot querySite = await db.collection('ShoppingSite').get();

  querySite.docs.forEach((documento) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final site = {
      "id": documento.id,
      "date": data['date'],
      "name": data['name']
    };
    shoppingSites.add(site);
    print('Site retrieved: $site'); // Print statement to debug
  });

  return shoppingSites;
}

Future<void> addSite(String date, String name) async {
  await db.collection("ShoppingSite").add({
    "date": date,
    "name": name,
  });
}

Future<void> updateSite(String id, String newDate, String newName) async {
  await db.collection("ShoppingSite").doc(id).set({
    "date": newDate,
    "name": newName,
  });
}

Future<void> deleteSite(String id) async {
  await db.collection("ShoppingSite").doc(id).delete();
}
