import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro_de_cobros_app/backend/services/productController.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
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
          deudor.id = element.id.toString();
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

  Future<void> eliminar(BuildContext context, String idDeudor) async {
    late String response;
    ProductController().getSumaProductosDeudor(idDeudor).then((value) {
      if (value == '\$0') {
        CollectionReference products = FirebaseFirestore.instance
            .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
            .doc('listaDeudores')
            .collection('Deudores');

        return products.doc(idDeudor).delete().then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Eliminado con exito",
              style: FlutterFlowTheme.of(context).bodyText2.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                    color: FlutterFlowTheme.of(context).tertiaryColor,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText2Family),
                  ),
            ),
            backgroundColor: FlutterFlowTheme.of(context).primaryColor,
          ));
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Error al eliminar: " + error.toString(),
              style: FlutterFlowTheme.of(context).bodyText2.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                    color: FlutterFlowTheme.of(context).primaryBtnText,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText2Family),
                  ),
            ),
            backgroundColor: Colors.red,
          ));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Error al eliminar: el cliente no debe tener deudas para poder ser eliminado",
            style: FlutterFlowTheme.of(context).bodyText2.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText2Family),
                ),
          ),
          backgroundColor: Colors.red,
        ));
      }
    });
  }
}
