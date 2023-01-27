import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'deudores_record.g.dart';

abstract class DeudoresRecord
    implements Built<DeudoresRecord, DeudoresRecordBuilder> {
  static Serializer<DeudoresRecord> get serializer =>
      _$deudoresRecordSerializer;

  @BuiltValueField(wireName: 'display_name')
  String? get displayName;

  @BuiltValueField(wireName: 'photo_url')
  String? get photoUrl;

  @BuiltValueField(wireName: 'phone_number')
  String? get phoneNumber;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static void _initializeBuilder(DeudoresRecordBuilder builder) => builder
    ..displayName = ''
    ..photoUrl = ''
    ..phoneNumber = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('deudores');

  static Stream<DeudoresRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<DeudoresRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  DeudoresRecord._();
  factory DeudoresRecord([void Function(DeudoresRecordBuilder) updates]) =
      _$DeudoresRecord;

  static DeudoresRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createDeudoresRecordData({
  String? displayName,
  String? photoUrl,
  String? phoneNumber,
}) {
  final firestoreData = serializers.toFirestore(
    DeudoresRecord.serializer,
    DeudoresRecord(
      (d) => d
        ..displayName = displayName
        ..photoUrl = photoUrl
        ..phoneNumber = phoneNumber,
    ),
  );

  return firestoreData;
}
