// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productos_fiados_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ProductosFiadosRecord> _$productosFiadosRecordSerializer =
    new _$ProductosFiadosRecordSerializer();

class _$ProductosFiadosRecordSerializer
    implements StructuredSerializer<ProductosFiadosRecord> {
  @override
  final Iterable<Type> types = const [
    ProductosFiadosRecord,
    _$ProductosFiadosRecord
  ];
  @override
  final String wireName = 'ProductosFiadosRecord';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ProductosFiadosRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'producto',
      serializers.serialize(object.producto,
          specifiedType: const FullType(ProductoStruct)),
    ];
    Object? value;
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
  ProductosFiadosRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductosFiadosRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'producto':
          result.producto.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ProductoStruct))!
              as ProductoStruct);
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

class _$ProductosFiadosRecord extends ProductosFiadosRecord {
  @override
  final ProductoStruct producto;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$ProductosFiadosRecord(
          [void Function(ProductosFiadosRecordBuilder)? updates]) =>
      (new ProductosFiadosRecordBuilder()..update(updates))._build();

  _$ProductosFiadosRecord._({required this.producto, this.ffRef}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        producto, r'ProductosFiadosRecord', 'producto');
  }

  @override
  ProductosFiadosRecord rebuild(
          void Function(ProductosFiadosRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductosFiadosRecordBuilder toBuilder() =>
      new ProductosFiadosRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductosFiadosRecord &&
        producto == other.producto &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, producto.hashCode), ffRef.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductosFiadosRecord')
          ..add('producto', producto)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class ProductosFiadosRecordBuilder
    implements Builder<ProductosFiadosRecord, ProductosFiadosRecordBuilder> {
  _$ProductosFiadosRecord? _$v;

  ProductoStructBuilder? _producto;
  ProductoStructBuilder get producto =>
      _$this._producto ??= new ProductoStructBuilder();
  set producto(ProductoStructBuilder? producto) => _$this._producto = producto;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  ProductosFiadosRecordBuilder() {
    ProductosFiadosRecord._initializeBuilder(this);
  }

  ProductosFiadosRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _producto = $v.producto.toBuilder();
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductosFiadosRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductosFiadosRecord;
  }

  @override
  void update(void Function(ProductosFiadosRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductosFiadosRecord build() => _build();

  _$ProductosFiadosRecord _build() {
    _$ProductosFiadosRecord _$result;
    try {
      _$result = _$v ??
          new _$ProductosFiadosRecord._(
              producto: producto.build(), ffRef: ffRef);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'producto';
        producto.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'ProductosFiadosRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
