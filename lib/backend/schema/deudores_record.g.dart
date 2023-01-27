// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deudores_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DeudoresRecord> _$deudoresRecordSerializer =
    new _$DeudoresRecordSerializer();

class _$DeudoresRecordSerializer
    implements StructuredSerializer<DeudoresRecord> {
  @override
  final Iterable<Type> types = const [DeudoresRecord, _$DeudoresRecord];
  @override
  final String wireName = 'DeudoresRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, DeudoresRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.displayName;
    if (value != null) {
      result
        ..add('display_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.photoUrl;
    if (value != null) {
      result
        ..add('photo_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.phoneNumber;
    if (value != null) {
      result
        ..add('phone_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.ffRef;
    if (value != null) {
      result
        ..add('Document__Reference__Field')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  DeudoresRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DeudoresRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'display_name':
          result.displayName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'photo_url':
          result.photoUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'phone_number':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'Document__Reference__Field':
          result.ffRef = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
      }
    }

    return result.build();
  }
}

class _$DeudoresRecord extends DeudoresRecord {
  @override
  final String? displayName;
  @override
  final String? photoUrl;
  @override
  final String? phoneNumber;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$DeudoresRecord([void Function(DeudoresRecordBuilder)? updates]) =>
      (new DeudoresRecordBuilder()..update(updates))._build();

  _$DeudoresRecord._(
      {this.displayName, this.photoUrl, this.phoneNumber, this.ffRef})
      : super._();

  @override
  DeudoresRecord rebuild(void Function(DeudoresRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeudoresRecordBuilder toBuilder() =>
      new DeudoresRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeudoresRecord &&
        displayName == other.displayName &&
        photoUrl == other.photoUrl &&
        phoneNumber == other.phoneNumber &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, displayName.hashCode), photoUrl.hashCode),
            phoneNumber.hashCode),
        ffRef.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeudoresRecord')
          ..add('displayName', displayName)
          ..add('photoUrl', photoUrl)
          ..add('phoneNumber', phoneNumber)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class DeudoresRecordBuilder
    implements Builder<DeudoresRecord, DeudoresRecordBuilder> {
  _$DeudoresRecord? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _photoUrl;
  String? get photoUrl => _$this._photoUrl;
  set photoUrl(String? photoUrl) => _$this._photoUrl = photoUrl;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  DeudoresRecordBuilder() {
    DeudoresRecord._initializeBuilder(this);
  }

  DeudoresRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _photoUrl = $v.photoUrl;
      _phoneNumber = $v.phoneNumber;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeudoresRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DeudoresRecord;
  }

  @override
  void update(void Function(DeudoresRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeudoresRecord build() => _build();

  _$DeudoresRecord _build() {
    final _$result = _$v ??
        new _$DeudoresRecord._(
            displayName: displayName,
            photoUrl: photoUrl,
            phoneNumber: phoneNumber,
            ffRef: ffRef);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
