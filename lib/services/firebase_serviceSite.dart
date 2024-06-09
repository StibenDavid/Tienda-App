import "package:cloud_firestore/cloud_firestore.dart";

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getShoppingSite() async { 
  List sites = [];

  CollectionReference collectionReferenceItem= db.collection('ShoppingSite');

  QuerySnapshot queryItem = await collectionReferenceItem.get();

  queryItem.docs.forEach((documento){
    sites.add(documento.data());
  });
  
  return sites;

}