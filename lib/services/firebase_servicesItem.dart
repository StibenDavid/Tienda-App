import "package:cloud_firestore/cloud_firestore.dart";

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getShoppingItem() async { 
  List shoppingItem = [];

  CollectionReference collectionReferenceItem= db.collection('ShoppingItem');

  QuerySnapshot queryItem = await collectionReferenceItem.get();

  queryItem.docs.forEach((documento){
    shoppingItem.add(documento.data());
  });
  
  return shoppingItem;

}