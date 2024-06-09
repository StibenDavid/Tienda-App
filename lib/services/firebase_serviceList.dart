import "package:cloud_firestore/cloud_firestore.dart";

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getShoppingList() async { 
  List lists = [];

  CollectionReference collectionReferenceItem= db.collection('ShoppingList');

  QuerySnapshot queryItem = await collectionReferenceItem.get();

  queryItem.docs.forEach((documento){
    lists.add(documento.data());
  });
  
  return lists;

}