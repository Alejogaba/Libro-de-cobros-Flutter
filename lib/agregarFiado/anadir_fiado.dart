import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:libro_de_cobros_app/backend/services/productController.dart';
import 'package:libro_de_cobros_app/backend/services/storageController.dart';

import '../flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '../flutter_flow/flutter_flow_count_controller.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/random_data_util.dart' as random_data;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:logger/logger.dart' as logger;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/product.dart';

class AgregarFiado extends StatefulWidget {
  const AgregarFiado({
    Key? key,
    this.idDeudor,
    this.nombreDeudor,
  }) : super(key: key);

  final String? idDeudor;
  final String? nombreDeudor;

  @override
  _AgregarFiadoState createState() =>
      _AgregarFiadoState(this.idDeudor, this.nombreDeudor);
}

class _AgregarFiadoState extends State<AgregarFiado> {
  TextEditingController? textController2;
  final textFieldMask2 = MaskTextInputFormatter(mask: '\$#.###.### und/lib');
  NumberFormat formatoColombiano = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
      customPattern: '\$#,##0');
  int? productdemandValue;
  int valorProducto = 0;
  final textFieldKey1 = GlobalKey();
  TextEditingController? textControllerBusqueda;
  String? textFieldSelectedOption1;
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? idDeudor;
  String totalGeneral = "\$0";
  DateTime fechaHora = DateTime.now();
  List<Product> listaProductos = [];
  List<Product> listaProductosaRegistrar = [];
  String? nombreDeudor;
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  bool okBtnHabilitado = true;
  Timer _timerResta = Timer(const Duration(milliseconds: 100), (() {}));
  Timer _timerSuma = Timer(const Duration(milliseconds: 100), (() {}));

  _AgregarFiadoState(this.idDeudor, this.nombreDeudor);

  @override
  void initState() {
    super.initState();
    okBtnHabilitado = true;
    textControllerBusqueda = TextEditingController();
    textController2 = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    textController2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 10, 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2022, 12, 1),
                    maxTime: DateTime.now(), onChanged: (date) {
                  //nothing to do
                }, onConfirm: (date) {
                  fechaHora = date;
                }, currentTime: fechaHora, locale: LocaleType.es);
              },
              child: Icon(
                Icons.calendar_month,
                color: FlutterFlowTheme.of(context).primaryBtnText,
              ),
              backgroundColor: Color.fromARGB(255, 36, 121, 190),
            ),
            SizedBox(width: 10),
            if (listaProductos.isNotEmpty)
              FloatingActionButton(
                onPressed: () async {
                  log('ok button pressed');
                  try {
                    if (okBtnHabilitado) {
                      setState(() {
                        okBtnHabilitado = false;
                      });

                      logger.Logger().v('ok');
                      ProductController productController = ProductController();

                      for (var product in listaProductos) {
                        logger.Logger().v('${product.name} registrando');
                        product.registrationDate = fechaHora;
                        product.price = product.total;
                        product.gain = product.total * product.percentageGain;
                        await productController.registrarProductoaDeudor(
                            product, idDeudor.toString());
                      }
                       Navigator.pop(context);
                      try {
                        
                       
                      } catch (e) {}
                    }
                  } catch (e) {
                    setState(() {
                      okBtnHabilitado = true;
                    });
                    logger.Logger().e(e);
                  }
                },
                child: (okBtnHabilitado) ? Icon(Icons.check,
                    color: okBtnHabilitado
                        ? FlutterFlowTheme.of(context).primaryBtnText
                        : FlutterFlowTheme.of(context).gray200): CircularProgressIndicator(color: FlutterFlowTheme.of(context).primaryBtnText,),
                backgroundColor: Colors.green,
              )
          ],
        ),
      ),
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryColor.withOpacity(0.75),
            size: 30,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          nombreDeudor.toString(),
          style: FlutterFlowTheme.of(context).title1,
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: Color(0x33000000),
                      offset: Offset(0, 1),
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TypeAheadField<Product?>(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: textControllerBusqueda,
                              autofocus: true,
                              style:
                                  DefaultTextStyle.of(context).style.copyWith(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Poppins',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        decorationColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryColor
                                                .withOpacity(0),
                                        fontSize: 40,
                                      ),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryColor)),
                                  hintText: "Buscar producto...",
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    size: 40.0,
                                  ),
                                  border: OutlineInputBorder())),
                          suggestionsCallback: (pattern) async {
                            return await ProductController()
                                .getProductos(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              leading: CachedNetworkImage(
                                memCacheHeight: 70,
                                memCacheWidth: 70,
                                fit: BoxFit.cover,
                                height: 70,
                                width: 70,
                                imageUrl: suggestion!.imagenUrl.toString(),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              title: Text(suggestion.name.toString()),
                              subtitle:
                                  Text('\$${suggestion.price.toString()}'),
                            );
                          },
                          onSuggestionSelected: (suggestion) async {
                            if (suggestion != null) {
                              suggestion.total = suggestion.price;
                              suggestion.textController =
                                  TextEditingController();
                              if (suggestion.name!.contains('Registrar')) {
                                String nombre = suggestion.name!
                                    .replaceAll('Registrar', '')
                                    .replaceAll('"', '')
                                    .trim();
                                suggestion.name = nombre[0].toUpperCase() +
                                    nombre.substring(1);
                                String id = await ProductController()
                                    .registrarProducto(suggestion);
                                if (id != 'error') {
                                  suggestion.id = id;
                                  setState(() {
                                    listaProductos.add(suggestion);
                                  });
                                }
                              } else {
                                setState(() {
                                  listaProductos.add(suggestion);
                                });
                              }
                              textControllerBusqueda = TextEditingController();
                              calcularTotal();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listaProductos.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onLongPress: () async {
                                    try {
                                      bool? puedeVibrar =
                                          await Vibration.hasVibrator();
                                      if (puedeVibrar != null) {
                                        if (puedeVibrar) {
                                          Vibration.vibrate(
                                              duration: 200, amplitude: 80);
                                        }
                                      }
                                    } catch (e) {}
                                    log('longprees');
                                    setState(() {
                                      if (listaProductos[index]
                                          .mostrarContador) {
                                        listaProductos[index].mostrarContador =
                                            false;
                                        listaProductos[index].total =
                                            listaProductos[index].price;
                                      } else {
                                        listaProductos[index].mostrarContador =
                                            true;
                                        listaProductos[index].total =
                                            listaProductos[index].price *
                                                listaProductos[index].cantidad;
                                      }
                                      listaProductos[index]
                                          .textFieldFocus
                                          .requestFocus();
                                      calcularTotal();
                                    });
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Material(
                                          color: Colors.transparent,
                                          elevation: 1,
                                          child: ClipRRect(
                                            child: Container(
                                              width: 300,
                                              height: MediaQuery.of(context)
                                                      .textScaleFactor *
                                                  160,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .lineColor,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await _showChoiceDialog(
                                                          context,
                                                          listaProductos[
                                                              index]);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  7, 6, 3, 2),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          FittedBox(
                                                            child:
                                                                CachedNetworkImage(
                                                              memCacheHeight:
                                                                  116,
                                                              memCacheWidth:
                                                                  116,
                                                              useOldImageOnUrlChange:
                                                                  false,
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .high,
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                              height: listaProductos[
                                                                          index]
                                                                      .mostrarContador
                                                                  ? 116
                                                                  : 110,
                                                              width: listaProductos[
                                                                          index]
                                                                      .mostrarContador
                                                                  ? 116
                                                                  : 110,
                                                              imageUrl:
                                                                  listaProductos[
                                                                          index]
                                                                      .imagenUrl,
                                                              progressIndicatorBuilder: (context,
                                                                      url,
                                                                      downloadProgress) =>
                                                                  CircularProgressIndicator(
                                                                      value: downloadProgress
                                                                          .progress),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 18, 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    listaProductos[
                                                                            index]
                                                                        .name
                                                                        .toString(),
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .title3
                                                                        .override(
                                                                          fontFamily:
                                                                              'Poppins',
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      listaProductos
                                                                          .remove(
                                                                              listaProductos[index]);
                                                                      calcularTotal();
                                                                    });
                                                                  },
                                                                  onLongPress:
                                                                      () async {
                                                                    try {
                                                                      bool?
                                                                          puedeVibrar =
                                                                          await Vibration
                                                                              .hasVibrator();
                                                                      if (puedeVibrar !=
                                                                          null) {
                                                                        if (puedeVibrar) {
                                                                          Vibration.vibrate(
                                                                              duration: 200,
                                                                              amplitude: 100);
                                                                        }
                                                                      }
                                                                    } catch (e) {}
                                                                    ProductController()
                                                                        .eliminarProducto(
                                                                            listaProductos[index].id);
                                                                    setState(
                                                                        () {
                                                                      listaProductos
                                                                          .remove(
                                                                              listaProductos[index]);
                                                                      calcularTotal();
                                                                    });
                                                                  },
                                                                  child:
                                                                      FlutterFlowIconButton(
                                                                    borderColor:
                                                                        Colors
                                                                            .transparent,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      size: 20,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional.fromSTEB(
                                                                        0,
                                                                        listaProductos[index].mostrarContador
                                                                            ? 5
                                                                            : 15,
                                                                        10,
                                                                        listaProductos[index].mostrarContador
                                                                            ? 5
                                                                            : 15),
                                                                    child:
                                                                        TextFormField(
                                                                      focusNode:
                                                                          listaProductos[index]
                                                                              .textFieldFocus,
                                                                      controller:
                                                                          listaProductos[index]
                                                                              .textController,
                                                                      obscureText:
                                                                          false,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            '\$${listaProductos[index].price} und/lib',
                                                                        hintStyle:
                                                                            FlutterFlowTheme.of(context).bodyText2,
                                                                        enabledBorder: listaProductos[index].mostrarContador
                                                                            ? OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: Color(0x00000000),
                                                                                  width: 1,
                                                                                ),
                                                                                borderRadius: const BorderRadius.only(
                                                                                  topLeft: Radius.circular(4.0),
                                                                                  topRight: Radius.circular(4.0),
                                                                                ),
                                                                              )
                                                                            : OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).gray200,
                                                                                  width: 1,
                                                                                ),
                                                                                borderRadius: const BorderRadius.only(
                                                                                  topLeft: Radius.circular(4.0),
                                                                                  topRight: Radius.circular(4.0),
                                                                                ),
                                                                              ),
                                                                        focusedBorder: listaProductos[index].mostrarContador
                                                                            ? UnderlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).gray200,
                                                                                  width: 1,
                                                                                ),
                                                                                borderRadius: const BorderRadius.only(
                                                                                  topLeft: Radius.circular(4.0),
                                                                                  topRight: Radius.circular(4.0),
                                                                                ),
                                                                              )
                                                                            : OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: FlutterFlowTheme.of(context).gray200,
                                                                                  width: 1,
                                                                                ),
                                                                                borderRadius: const BorderRadius.only(
                                                                                  topLeft: Radius.circular(4.0),
                                                                                  topRight: Radius.circular(4.0),
                                                                                ),
                                                                              ),
                                                                        errorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00000000),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        focusedErrorBorder:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                Color(0x00000000),
                                                                            width:
                                                                                1,
                                                                          ),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(4.0),
                                                                            topRight:
                                                                                Radius.circular(4.0),
                                                                          ),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            FlutterFlowTheme.of(context).secondaryBackground,
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyText1
                                                                          .override(
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontSize: listaProductos[index].mostrarContador
                                                                                ? 18
                                                                                : 20,
                                                                          ),
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .phone,
                                                                      onFieldSubmitted:
                                                                          (value) async {
                                                                        if (listaProductos[index]
                                                                            .mostrarContador) {
                                                                          listaProductos[index].price =
                                                                              double.parse(value);
                                                                          listaProductos[index].gain =
                                                                              listaProductos[index].price * listaProductos[index].percentageGain;
                                                                          await ProductController().registrarProducto(
                                                                              listaProductos[index],
                                                                              id: listaProductos[index].id);
                                                                        }
                                                                      },
                                                                      onChanged:
                                                                          (value) {
                                                                        double
                                                                            valor =
                                                                            double.parse(value);
                                                                        try {
                                                                          if (listaProductos[index]
                                                                              .name
                                                                              .toString()
                                                                              .contains('Abono')) {
                                                                            if (valor >
                                                                                0) {
                                                                              double negativo = valor * -1;
                                                                              listaProductos[index].price = double.parse(formatoColombiano.parse(negativo.toString()).toString());
                                                                            } else {
                                                                              listaProductos[index].price = double.parse(formatoColombiano.parse(value).toString());
                                                                            }
                                                                          } else {
                                                                            listaProductos[index].price =
                                                                                double.parse(formatoColombiano.parse(value).toString());
                                                                          }
                                                                        } catch (e) {
                                                                          listaProductos[index].price =
                                                                              0;
                                                                        }

                                                                        if (listaProductos[index]
                                                                            .mostrarContador) {
                                                                          setState(
                                                                              () {
                                                                            listaProductos[index].total =
                                                                                listaProductos[index].price * listaProductos[index].cantidad;
                                                                            calcularTotal();
                                                                          });
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            listaProductos[index].total =
                                                                                listaProductos[index].price;
                                                                            calcularTotal();
                                                                          });
                                                                        }
                                                                      },
                                                                      onEditingComplete:
                                                                          () {
                                                                        try {
                                                                          var valor =
                                                                              formatoColombiano.format(double.parse(textController2!.text));
                                                                          setState(
                                                                              () {
                                                                            textController2!.text =
                                                                                valor;
                                                                          });
                                                                        } catch (e) {}
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (!(listaProductos[
                                                                        index]
                                                                    .mostrarContador))
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            5,
                                                                            10),
                                                                    child: (listaProductos[index].total >=
                                                                            0)
                                                                        ? Text(
                                                                            formatoColombiano.format(listaProductos[index].total).toString(),
                                                                            style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w800,
                                                                                ),
                                                                          )
                                                                        : Text(
                                                                            '+${formatoColombiano.format(listaProductos[index].total).toString().replaceAll('-', '')}',
                                                                            style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                  color: Color.fromARGB(255, 22, 141, 83),
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w800,
                                                                                ),
                                                                          ),
                                                                  )
                                                              ],
                                                            ),
                                                          ),
                                                          if (listaProductos[
                                                                  index]
                                                              .mostrarContador)
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              10),
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        elevation:
                                                                            2,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          side:
                                                                              BorderSide(color: FlutterFlowTheme.of(context).lineColor),
                                                                          borderRadius:
                                                                              BorderRadius.circular(25),
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              120,
                                                                          height:
                                                                              35,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            borderRadius:
                                                                                BorderRadius.circular(25),
                                                                            shape:
                                                                                BoxShape.rectangle,
                                                                          ),
                                                                          child:
                                                                              FlutterFlowCountController(
                                                                            decrementIconBuilder: (enabled) =>
                                                                                FaIcon(
                                                                              FontAwesomeIcons.minus,
                                                                              color: enabled ? FlutterFlowTheme.of(context).alternate : Color(0xFFEEEEEE),
                                                                              size: 20,
                                                                            ),
                                                                            incrementIconBuilder: (enabled) =>
                                                                                FaIcon(
                                                                              FontAwesomeIcons.plus,
                                                                              color: enabled ? Color(0xFF73B175) : Color(0xFFEEEEEE),
                                                                              size: 20,
                                                                            ),
                                                                            countBuilder: (count) =>
                                                                                Text(
                                                                              count.toString(),
                                                                              style: GoogleFonts.getFont('Open Sans', color: FlutterFlowTheme.of(context).primaryText, fontWeight: FontWeight.w600, fontSize: 15),
                                                                            ),
                                                                            count:
                                                                                listaProductos[index].cantidad,
                                                                            updateCount: (count) =>
                                                                                setState(() {
                                                                              listaProductos[index].cantidad = count;
                                                                              listaProductos[index].total = listaProductos[index].price * listaProductos[index].cantidad;

                                                                              calcularTotal();
                                                                            }),
                                                                            stepSize:
                                                                                1,
                                                                            minimum:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              10),
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        elevation:
                                                                            0,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(25),
                                                                        ),
                                                                        child: Container(
                                                                            width: 130,
                                                                            height: 35,
                                                                            decoration: BoxDecoration(
                                                                              color: Color.fromARGB(0, 0, 0, 0).withOpacity(0),
                                                                              borderRadius: BorderRadius.circular(25),
                                                                              shape: BoxShape.rectangle,
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Expanded(
                                                                                    child: Container(
                                                                                  height: 200,
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                      try {
                                                                                        bool? puedeVibrar = await Vibration.hasVibrator();
                                                                                        if (puedeVibrar != null) {
                                                                                          if (puedeVibrar) {
                                                                                            Vibration.vibrate(duration: 50, amplitude: 1);
                                                                                          }
                                                                                        }
                                                                                      } catch (e) {}
                                                                                      int count = listaProductos[index].cantidad;
                                                                                      if (count > 1) {
                                                                                        setState(() {
                                                                                          listaProductos[index].cantidad = count - 1;
                                                                                          listaProductos[index].total = listaProductos[index].price * listaProductos[index].cantidad;

                                                                                          calcularTotal();
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    onLongPress: () {
                                                                                      _timerResta = Timer.periodic(Duration(milliseconds: 220), (_) {
                                                                                        int count = listaProductos[index].cantidad;
                                                                                        if (count > 1) {
                                                                                          setState(() {
                                                                                            listaProductos[index].cantidad = count - 1;
                                                                                            listaProductos[index].total = listaProductos[index].price * listaProductos[index].cantidad;

                                                                                            calcularTotal();
                                                                                          });
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    onLongPressEnd: (details) {
                                                                                      _timerResta.cancel();
                                                                                    },
                                                                                    child: InkWell(child: Text('')),
                                                                                  ),
                                                                                )),
                                                                                Expanded(
                                                                                    child: Container(
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                      try {
                                                                                        bool? puedeVibrar = await Vibration.hasVibrator();
                                                                                        if (puedeVibrar != null) {
                                                                                          if (puedeVibrar) {
                                                                                            Vibration.vibrate(duration: 50, amplitude: 2);
                                                                                          }
                                                                                        }
                                                                                      } catch (e) {}
                                                                                      int count = listaProductos[index].cantidad;
                                                                                      if (count < 999) {
                                                                                        setState(() {
                                                                                          listaProductos[index].cantidad = count + 1;
                                                                                          listaProductos[index].total = listaProductos[index].price * listaProductos[index].cantidad;

                                                                                          calcularTotal();
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    onLongPress: () {
                                                                                      _timerSuma = Timer.periodic(Duration(milliseconds: 220), (_) {
                                                                                        int count = listaProductos[index].cantidad;
                                                                                        if (count < 999) {
                                                                                          setState(() {
                                                                                            listaProductos[index].cantidad = count + 1;
                                                                                            listaProductos[index].total = listaProductos[index].price * listaProductos[index].cantidad;

                                                                                            calcularTotal();
                                                                                          });
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    onLongPressEnd: (details) {
                                                                                      _timerSuma.cancel();
                                                                                    },
                                                                                    child: InkWell(child: Text('')),
                                                                                  ),
                                                                                ))
                                                                              ],
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                FittedBox(
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            5,
                                                                            10),
                                                                    child: (listaProductos[index].total >=
                                                                            0)
                                                                        ? Text(
                                                                            formatoColombiano.format(listaProductos[index].total).toString(),
                                                                            style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w800,
                                                                                ),
                                                                          )
                                                                        : Text(
                                                                            '+${formatoColombiano.format(listaProductos[index].total).toString().replaceAll('-', '')}',
                                                                            style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                  color: Color.fromARGB(255, 22, 141, 83),
                                                                                  fontFamily: 'Poppins',
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w800,
                                                                                ),
                                                                          ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFF73B175),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: Color(0x430F1113),
                      offset: Offset(0, -2),
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: (formatoColombiano.parse(totalGeneral) >= 0)
                    ? FFButtonWidget(
                        onPressed: () {
                          print('Checkout pressed ...');
                        },
                        text: 'Total: ' + totalGeneral,
                        icon: FaIcon(
                          FontAwesomeIcons.solidMoneyBill1,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: double.infinity,
                          color: FlutterFlowTheme.of(context).primaryColor,
                          textStyle: FlutterFlowTheme.of(context)
                              .subtitle2
                              .override(
                                fontFamily: 'Lexend Deca',
                                color:
                                    FlutterFlowTheme.of(context).primaryBtnText,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                          elevation: 0,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        showLoadingIndicator: false,
                      )
                    : FFButtonWidget(
                        onPressed: () {
                          print('Checkout pressed ...');
                        },
                        text: 'Total: +' + totalGeneral.replaceAll('-', ''),
                        icon: FaIcon(
                          FontAwesomeIcons.solidMoneyBill1,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: double.infinity,
                          color: FlutterFlowTheme.of(context).primaryColor,
                          textStyle:
                              FlutterFlowTheme.of(context).subtitle2.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color.fromARGB(255, 22, 141, 83),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                          elevation: 0,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        showLoadingIndicator: false,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  calcularTotal() {
    double totalPrice = 0;
    for (var product in listaProductos) {
      totalPrice += product.total;
    }
    totalGeneral = formatoColombiano.format(totalPrice);
  }

  Future pickImageFromGallery(Product producto) async {
    print("starting get image");
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    //final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print("getting image.....");

    if (pickedFile != null) {
      logger.Logger().i('Imagen seleccionada ruta:${pickedFile.path}');
      imageFile = await File(pickedFile.path).create();
      await subirImagen(producto);
    } else {
      print('No image selected.');
    }
  }

  Future<void> subirImagen(Product producto) async {
    if (imageFile != null) {
      StorageController storageController = StorageController();
      var res = await storageController.subirImagen(
          context, imageFile!, producto.id, 'Productos');

      setState(() {
        producto.imagenUrl = res;
        ProductController().registrarProducto(producto, id: producto.id);
      });
    }
  }

  Future captureImageFromCamera(Product producto) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() async {
      if (pickedFile != null) {
        imageFile = await File(pickedFile.path).create();
        await subirImagen(producto);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _showChoiceDialog(BuildContext context, Product producto) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Seleccione"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      pickImageFromGallery(producto);
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camara"),
                    onTap: () {
                      captureImageFromCamera(producto);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, required LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}
