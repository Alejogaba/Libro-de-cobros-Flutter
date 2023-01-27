import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  String id='';
  String? name;
  double price = 0;
  double percentageGain = 0.2;
  double? gain;
  String imagenUrl =
      'https://firebasestorage.googleapis.com/v0/b/proyecto-cobros.appspot.com/o/add.png?alt=media&token=78c41fda-9d99-4a91-b85b-05527bb80d9c';
  DateTime registrationDate = DateTime.now();
  int cantidad = 1;
  double total = 0;
  bool mostrarContador = true;
  TextEditingController textController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  Product(
      {this.id='',
        this.name = '',
      this.price = 0,
      this.percentageGain = 0.2,
      this.gain = 0,
      this.imagenUrl =
          'https://firebasestorage.googleapis.com/v0/b/proyecto-cobros.appspot.com/o/add.png?alt=media&token=78c41fda-9d99-4a91-b85b-05527bb80d9c',
      required this.registrationDate,
      this.cantidad = 1,
      this.total = 0,
      this.mostrarContador = true});

  calcularTotal() {
    this.total = this.price * double.parse(this.cantidad.toString());
  }

  calcularGanancia() {
    this.gain = this.price * this.percentageGain;
  }

  Product.fromMap(QueryDocumentSnapshot<Object?> data) {
    name = data['nombre'];
    price = double.parse(data.get('valor').toString());
    percentageGain = double.parse(data['porc_ganancia'].toString());
    gain = double.parse(data['valor_ganancia'].toString());
    imagenUrl = data['imagenUrl'];
    cantidad = int.parse(data['cantidad'].toString());
    registrationDate =
        DateTime.fromMillisecondsSinceEpoch(data['fechaRegistro']);
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'valor': price,
      'porc_ganancia': percentageGain,
      'valor_ganancia': gain,
      'imagenUrl': imagenUrl,
      'cantidad': cantidad,
      'fechaRegistro': registrationDate.millisecondsSinceEpoch,
    };
  }
}
