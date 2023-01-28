import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../flutter_flow/flutter_flow_util.dart';
import '../../models/product.dart';

import "package:collection/collection.dart";

class ProductController {
  Future<List<Product>> getProductos(String pattern) async {
    var stringsToMatch = [pattern];
    CollectionReference productos = FirebaseFirestore.instance
        .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
        .doc('listaProductos')
        .collection('productos');
    QuerySnapshot querySnapshot;

    querySnapshot = await productos.get();

    var documents = querySnapshot.docs;
    List<Product> products = [];
    if (pattern.length < 1) {
      documents.forEach(
        (element) {
          Product producto = Product.fromMap(element);
          producto.id = element.id.toString();
          products.add(producto);
        },
      );
    } else {
      documents.forEach(
        (element) {
          Product producto = Product.fromMap(element);

          producto.id = element.id.toString();
          if (producto.name
              .toString()
              .toLowerCase()
              .contains(pattern.toLowerCase().trim())) {
            products.add(producto);
          }
        },
      );
    }

    if (products.length < 1) {
      Product producto = Product(
          registrationDate: DateTime.now(),
          name: 'Registrar "$pattern"',
          imagenUrl:
              'https://firebasestorage.googleapis.com/v0/b/proyecto-cobros.appspot.com/o/add.png?alt=media&token=78c41fda-9d99-4a91-b85b-05527bb80d9c');
      products.add(producto);
    }

    return products;
  }

  Future<Map<DateTime, List<Product>>> getProductosDeudor(String idDeudor,
      {String pattern = ''}) async {
    var stringsToMatch = [pattern];
    CollectionReference productos = FirebaseFirestore.instance
        .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
        .doc('listaDeudores')
        .collection('Deudores')
        .doc(idDeudor)
        .collection('Productos');
    QuerySnapshot querySnapshot;

    querySnapshot =
        await productos.orderBy('fechaRegistro', descending: true).get();

    var documents = querySnapshot.docs;
    List<Product> products = [];
    if (pattern.length < 1) {
      documents.forEach(
        (element) {
          Product producto = Product.fromMap(element);
          producto.id = element.id.toString();

          products.add(producto);
        },
      );
    } else {
      documents.forEach(
        (element) {
          Product producto = Product.fromMap(element);
          producto.id = element.id.toString();

          if (producto.name
              .toString()
              .toLowerCase()
              .contains(pattern.toLowerCase().trim())) {
            products.add(producto);
          }
        },
      );
    }

    var productsGroupedByDate =
        groupBy(products, (Product product) => DateUtils.dateOnly(product.registrationDate));

    productsGroupedByDate.forEach(
      (key, value) {
        log('Lista agrupada key:' + key.toString());
        value.forEach((Product element) {
          log('Lista agrupada value:' + element.name.toString());
        });
      },
    );

    return productsGroupedByDate;
  }

  Future<String> getSumaProductosDeudor(String idDeudor,
      {String pattern = ''}) async {
    var stringsToMatch = [pattern];
    CollectionReference productos = FirebaseFirestore.instance
        .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
        .doc('listaDeudores')
        .collection('Deudores')
        .doc(idDeudor)
        .collection('Productos');
    QuerySnapshot querySnapshot;

    querySnapshot =
        await productos.orderBy('fechaRegistro', descending: true).get();

    var documents = querySnapshot.docs;
    List<Product> products = [];
    if (pattern.length < 1) {
      documents.forEach(
        (element) {
          Product producto = Product.fromMap(element);
          producto.id = element.id.toString();

          products.add(producto);
        },
      );
    } else {
      documents.forEach(
        (element) {
          Product producto = Product.fromMap(element);
          producto.id = element.id.toString();

          if (producto.name
              .toString()
              .toLowerCase()
              .contains(pattern.toLowerCase().trim())) {
            products.add(producto);
          }
        },
      );
    }
    NumberFormat formatoColombiano = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
      customPattern: '\$#,##0');

    double totalPrice = 0;
    log(products.length.toString());
    products.forEach((element) {
      totalPrice += element.price;
    });

    return formatoColombiano.format(totalPrice).toString();
  }

  Future<void> registrarProductoaDeudor(
      Product product, String idDeudor) async {
    await FirebaseFirestore.instance
        .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
        .doc('listaDeudores')
        .collection('Deudores')
        .doc(idDeudor)
        .collection('Productos')
        .add(product.toMap())
        .then((value) => log(value.toString()));
  }

  Future<String> registrarProducto(Product product, {String id = ''}) async {
    String result = 'error';
    if (id.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
          .doc('listaProductos')
          .collection('productos')
          .doc(id)
          .set(product.toMap(), SetOptions(merge: true))
          .then((value) => result = id);
      return result;
    } else {
      await FirebaseFirestore.instance
          .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
          .doc('listaProductos')
          .collection('productos')
          .add(
            product.toMap(),
          )
          .then((value) => result = value.id);
      return result;
    }
  }

  Future<void> eliminarProducto(String id) async {
    CollectionReference products = FirebaseFirestore.instance
        .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
        .doc('listaProductos')
        .collection('productos');

    return products
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> eliminarProductodeFuncionario(
      String idProducto, String idDeudor) async {
    CollectionReference products = FirebaseFirestore.instance
        .collection('GRrFmH5egLZkSCaOHxS1UhexSQU2')
        .doc('listaDeudores')
        .collection('Deudores')
        .doc(idDeudor)
        .collection('Productos');

    return products
        .doc(idProducto)
        .delete()
        .then((value) => print("Producto eliminado"))
        .catchError((error) => print("Failed to delete: $error"));
  }
}
