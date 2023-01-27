import 'dart:async';

import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'productos_fiados_record.g.dart';

abstract class ProductosFiadosRecord
    implements Built<ProductosFiadosRecord, ProductosFiadosRecordBuilder> {
  static Serializer<ProductosFiadosRecord> get serializer =>
      _$productosFiadosRecordSerializer;

  ProductoStruct get producto;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  DocumentReference get parentReference => reference.parent.parent!;

  static void _initializeBuilder(ProductosFiadosRecordBuilder builder) =>
      builder..producto = ProductoStructBuilder();

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('productos_fiados')
          : FirebaseFirestore.instance.collectionGroup('productos_fiados');

  static DocumentReference createDoc(DocumentReference parent) =>
      parent.collection('productos_fiados').doc();

  static Stream<ProductosFiadosRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<ProductosFiadosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then(
          (s) => serializers.deserializeWith(serializer, serializedData(s))!);

  ProductosFiadosRecord._();
  factory ProductosFiadosRecord(
          [void Function(ProductosFiadosRecordBuilder) updates]) =
      _$ProductosFiadosRecord;

  static ProductosFiadosRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createProductosFiadosRecordData({
  ProductoStruct? producto,
}) {
  final firestoreData = serializers.toFirestore(
    ProductosFiadosRecord.serializer,
    ProductosFiadosRecord(
      (p) => p..producto = ProductoStructBuilder(),
    ),
  );

  // Handle nested data for "producto" field.
  addProductoStructData(firestoreData, producto, 'producto');

  return firestoreData;
}
