// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producto_struct.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ProductoStruct> _$productoStructSerializer =
    new _$ProductoStructSerializer();

class _$ProductoStructSerializer
    implements StructuredSerializer<ProductoStruct> {
  @override
  final Iterable<Type> types = const [ProductoStruct, _$ProductoStruct];
  @override
  final String wireName = 'ProductoStruct';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProductoStruct object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'firestoreUtilData',
      serializers.serialize(object.firestoreUtilData,
          specifiedType: const FullType(FirestoreUtilData)),
    ];
    Object? value;
    value = object.nombre;
    if (value != null) {
      result
        ..add('nombre')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.valor;
    if (value != null) {
      result
        ..add('valor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.porcGanancia;
    if (value != null) {
      result
        ..add('porc_ganancia')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.valorGanancia;
    if (value != null) {
      result
        ..add('valor_ganancia')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.urlImagen;
    if (value != null) {
      result
        ..add('url_imagen')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  ProductoStruct deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductoStructBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'nombre':
          result.nombre = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'valor':
          result.valor = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'porc_ganancia':
          result.porcGanancia = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'valor_ganancia':
          result.valorGanancia = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'url_imagen':
          result.urlImagen = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'firestoreUtilData':
          result.firestoreUtilData = serializers.deserialize(value,
                  specifiedType: const FullType(FirestoreUtilData))!
              as FirestoreUtilData;
          break;
      }
    }

    return result.build();
  }
}

class _$ProductoStruct extends ProductoStruct {
  @override
  final String? nombre;
  @override
  final double? valor;
  @override
  final int? porcGanancia;
  @override
  final double? valorGanancia;
  @override
  final String? urlImagen;
  @override
  final FirestoreUtilData firestoreUtilData;

  factory _$ProductoStruct([void Function(ProductoStructBuilder)? updates]) =>
      (new ProductoStructBuilder()..update(updates))._build();

  _$ProductoStruct._(
      {this.nombre,
      this.valor,
      this.porcGanancia,
      this.valorGanancia,
      this.urlImagen,
      required this.firestoreUtilData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        firestoreUtilData, r'ProductoStruct', 'firestoreUtilData');
  }

  @override
  ProductoStruct rebuild(void Function(ProductoStructBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductoStructBuilder toBuilder() =>
      new ProductoStructBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductoStruct &&
        nombre == other.nombre &&
        valor == other.valor &&
        porcGanancia == other.porcGanancia &&
        valorGanancia == other.valorGanancia &&
        urlImagen == other.urlImagen &&
        firestoreUtilData == other.firestoreUtilData;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, nombre.hashCode), valor.hashCode),
                    porcGanancia.hashCode),
                valorGanancia.hashCode),
            urlImagen.hashCode),
        firestoreUtilData.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductoStruct')
          ..add('nombre', nombre)
          ..add('valor', valor)
          ..add('porcGanancia', porcGanancia)
          ..add('valorGanancia', valorGanancia)
          ..add('urlImagen', urlImagen)
          ..add('firestoreUtilData', firestoreUtilData))
        .toString();
  }
}

class ProductoStructBuilder
    implements Builder<ProductoStruct, ProductoStructBuilder> {
  _$ProductoStruct? _$v;

  String? _nombre;
  String? get nombre => _$this._nombre;
  set nombre(String? nombre) => _$this._nombre = nombre;

  double? _valor;
  double? get valor => _$this._valor;
  set valor(double? valor) => _$this._valor = valor;

  int? _porcGanancia;
  int? get porcGanancia => _$this._porcGanancia;
  set porcGanancia(int? porcGanancia) => _$this._porcGanancia = porcGanancia;

  double? _valorGanancia;
  double? get valorGanancia => _$this._valorGanancia;
  set valorGanancia(double? valorGanancia) =>
      _$this._valorGanancia = valorGanancia;

  String? _urlImagen;
  String? get urlImagen => _$this._urlImagen;
  set urlImagen(String? urlImagen) => _$this._urlImagen = urlImagen;

  FirestoreUtilData? _firestoreUtilData;
  FirestoreUtilData? get firestoreUtilData => _$this._firestoreUtilData;
  set firestoreUtilData(FirestoreUtilData? firestoreUtilData) =>
      _$this._firestoreUtilData = firestoreUtilData;

  ProductoStructBuilder() {
    ProductoStruct._initializeBuilder(this);
  }

  ProductoStructBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nombre = $v.nombre;
      _valor = $v.valor;
      _porcGanancia = $v.porcGanancia;
      _valorGanancia = $v.valorGanancia;
      _urlImagen = $v.urlImagen;
      _firestoreUtilData = $v.firestoreUtilData;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductoStruct other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductoStruct;
  }

  @override
  void update(void Function(ProductoStructBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductoStruct build() => _build();

  _$ProductoStruct _build() {
    final _$result = _$v ??
        new _$ProductoStruct._(
            nombre: nombre,
            valor: valor,
            porcGanancia: porcGanancia,
            valorGanancia: valorGanancia,
            urlImagen: urlImagen,
            firestoreUtilData: BuiltValueNullFieldError.checkNotNull(
                firestoreUtilData, r'ProductoStruct', 'firestoreUtilData'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
