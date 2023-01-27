import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/deudor.dart';
import '../../models/product.dart';

class DeudorController {
  Future<List<Deudor>> getDeudores({String pattern = ''}) async {
    CollectionReference productos = FirebaseFirestore.instance
        .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
        .doc('listaDeudores')
        .collection('Deudores');
    QuerySnapshot querySnapshot;

    querySnapshot = await productos.get();

    var documents = querySnapshot.docs;
    List<Deudor> listaDeudores = [];
    if (pattern.length < 3) {
      documents.forEach(
        (element) {
          Deudor deudor = Deudor.fromMap(element);
          deudor.id=element.id.toString();
          listaDeudores.add(deudor);
          log(deudor.id.toString());
        },
      );
    } else {
      documents.forEach(
        (element) {
          Deudor deudor = Deudor.fromMap(element);
          if (deudor.name
              .toString()
              .toLowerCase()
              .contains(pattern.toLowerCase().trim())) {
            listaDeudores.add(deudor);
          }
        },
      );
    }

    return listaDeudores;
  }

  Future<String> registrarDeudor(Deudor deudor, {String id = ''}) async {
    String result = 'error';
    if (id.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
          .doc('listaDeudores')
          .collection('Deudores')
          .doc(id)
          .set(deudor.toMap(), SetOptions(merge: true))
          .then((value) => result = id);
      return result;
    } else {
      await FirebaseFirestore.instance
          .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
          .doc('listaDeudores')
          .collection('Deudores')
          .add(
            deudor.toMap(),
          )
          .then((value) => result = value.id);
      return result;
    }
  }
}
