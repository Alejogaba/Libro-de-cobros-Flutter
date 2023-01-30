import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Deudor {
  String id = '';
  String name = '';
  String phone = '';
  String imageUrl = '';
  bool editMode = false;
  TextEditingController textController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  Deudor({
    this.id = '',
    this.name = '',
    this.phone = '',
    this.imageUrl = '',
  });

  Deudor.fromMap(QueryDocumentSnapshot<Object?> data) {
    name = data['nombre'];
    phone = data['telefono'];
    imageUrl = data['imagenUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': name,
      'telefono': phone,
      'imagenUrl': imageUrl,
    };
  }
}
