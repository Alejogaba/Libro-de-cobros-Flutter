import 'dart:async';


import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'productos_record.g.dart';

abstract class ProductosRecord
    implements Built<ProductosRecord, ProductosRecordBuilder> {
  static Serializer<ProductosRecord> get serializer =>
      _$productosRecordSerializer;

  ProductoStruct get producto;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(ProductosRecordBuilder builder) =>
      builder..producto = ProductoStructBuilder();

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('productos');

  static Stream<ProductosRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<ProductosRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  ProductosRecord._();
  factory ProductosRecord([void Function(ProductosRecordBuilder) updates]) =
      _$ProductosRecord;

  static ProductosRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createProductosRecordData({
  ProductoStruct? producto,
}) {
  final firestoreData = serializers.toFirestore(
    ProductosRecord.serializer,
    ProductosRecord(
      (p) => p..producto = ProductoStructBuilder(),
    ),
  );

  // Handle nested data for "producto" field.
  addProductoStructData(firestoreData, producto, 'producto');

  return firestoreData;
}
