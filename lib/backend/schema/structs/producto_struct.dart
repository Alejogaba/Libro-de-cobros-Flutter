
import '../serializers.dart';
import 'package:built_value/built_value.dart';

part 'producto_struct.g.dart';

abstract class ProductoStruct
    implements Built<ProductoStruct, ProductoStructBuilder> {
  static Serializer<ProductoStruct> get serializer =>
      _$productoStructSerializer;

  String? get nombre;

  double? get valor;

  @BuiltValueField(wireName: 'porc_ganancia')
  int? get porcGanancia;

  @BuiltValueField(wireName: 'valor_ganancia')
  double? get valorGanancia;

  @BuiltValueField(wireName: 'url_imagen')
  String? get urlImagen;

  /// Utility class for Firestore updates
  FirestoreUtilData get firestoreUtilData;

  static void _initializeBuilder(ProductoStructBuilder builder) => builder
    ..nombre = ''
    ..valor = 0.0
    ..porcGanancia = 0
    ..valorGanancia = 0.0
    ..urlImagen = ''
    ..firestoreUtilData = FirestoreUtilData();

  ProductoStruct._();
  factory ProductoStruct([void Function(ProductoStructBuilder) updates]) =
      _$ProductoStruct;
}

ProductoStruct createProductoStruct({
  String? nombre,
  double? valor,
  int? porcGanancia,
  double? valorGanancia,
  String? urlImagen,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ProductoStruct(
      (p) => p
        ..nombre = nombre
        ..valor = valor
        ..porcGanancia = porcGanancia
        ..valorGanancia = valorGanancia
        ..urlImagen = urlImagen
        ..firestoreUtilData = FirestoreUtilData(
          clearUnsetFields: clearUnsetFields,
          create: create,
          delete: delete,
          fieldValues: fieldValues,
        ),
    );

ProductoStruct? updateProductoStruct(
  ProductoStruct? producto, {
  bool clearUnsetFields = true,
}) =>
    producto != null
        ? (producto.toBuilder()
              ..firestoreUtilData =
                  FirestoreUtilData(clearUnsetFields: clearUnsetFields))
            .build()
        : null;

void addProductoStructData(
  Map<String, dynamic> firestoreData,
  ProductoStruct? producto,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (producto == null) {
    return;
  }
  if (producto.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  if (!forFieldValue && producto.firestoreUtilData.clearUnsetFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final productoData = getProductoFirestoreData(producto, forFieldValue);
  final nestedData = productoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final create = producto.firestoreUtilData.create;
  firestoreData.addAll(create ? mergeNestedFields(nestedData) : nestedData);

  return;
}

Map<String, dynamic> getProductoFirestoreData(
  ProductoStruct? producto, [
  bool forFieldValue = false,
]) {
  if (producto == null) {
    return {};
  }
  final firestoreData =
      serializers.toFirestore(ProductoStruct.serializer, producto);

  // Add any Firestore field values
  producto.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getProductoListFirestoreData(
  List<ProductoStruct>? productos,
) =>
    productos?.map((p) => getProductoFirestoreData(p, true)).toList() ?? [];
