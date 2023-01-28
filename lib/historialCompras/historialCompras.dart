import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro_de_cobros_app/agregarFiado/anadir_fiado.dart';
import 'package:libro_de_cobros_app/backend/services/productController.dart';

import 'package:libro_de_cobros_app/models/product.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:swipe_to/swipe_to.dart';

import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:logger/logger.dart' as logger;
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

class HistorialCompras extends StatefulWidget {
  final String? idDeudor;
  final String? nombreDeudor;
  const HistorialCompras({Key? key, this.idDeudor, this.nombreDeudor})
      : super(key: key);

  @override
  _HistorialComprasState createState() =>
      _HistorialComprasState(this.idDeudor, this.nombreDeudor);
}

class _HistorialComprasState extends State<HistorialCompras>
    with TickerProviderStateMixin {
  final animationsMap = {
    'textOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 60),
          end: Offset(0, 0),
        ),
      ],
    ),
    'listViewOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 80),
          end: Offset(0, 0),
        ),
      ],
    ),
    'textOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 100),
          end: Offset(0, 0),
        ),
      ],
    ),
    'listViewOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 120),
          end: Offset(0, 0),
        ),
      ],
    ),
  };
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? idDeudor;
  NumberFormat formatoColombiano = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
      customPattern: '\$#,##0');
  var dateFormatter = DateFormat.EEEE('es_US').add_d().add_MMM().add_jm();
  var dateFormatterTime = DateFormat.d('es_US').add_MMM().add_jm();
  var dateFormatterOnlyDay = DateFormat.EEEE('es_US').add_d().add_MMM();

  String totalGeneral = "\$0";
  String? nombreDeudor;
  _HistorialComprasState(this.idDeudor, this.nombreDeudor);
  List<Product> listaProductosSumaGeneral = [];
  List<Product> listaProductosSuma = [];
  ScrollController scrollController = ScrollController();
  bool fbEsVisible = true;
  bool blur = false;
  String? idProductoEliminar;
  late var _getData;
  @override
  void initState() {
    super.initState();
    _getData = ProductController().getSumaProductosDeudor(idDeudor!);
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 20, 80),
        child: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context)
                .push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 100),
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return SlideTransition(
                  
                    position: Tween<Offset>(
          begin: Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
                    child: AgregarFiado(
                      idDeudor: idDeudor,
                      nombreDeudor: nombreDeudor,
                    ),
                  );
                },
              ),
            )
                .then((value) {
              setState(() {});
            });
          },
          child: Icon(Icons.add,
              color: FlutterFlowTheme.of(context).primaryBtnText),
          backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          nombreDeudor.toString(),
          style: FlutterFlowTheme.of(context).subtitle1,
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(_unfocusNode);
                setState(() {
                  blur = false;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: FutureBuilder<Map<DateTime, List<Product>>>(
                      future: ProductController()
                          .getProductosDeudor(idDeudor.toString()),
                      builder: (BuildContext context, snapshotGroup) {
                        if (snapshotGroup.connectionState ==
                                ConnectionState.done &&
                            snapshotGroup.hasData) {
                          listaProductosSumaGeneral = [];
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshotGroup.data!.length,
                            itemBuilder: (BuildContext context, int index1) {
                              List<Product> productList =
                                  snapshotGroup.data!.values.elementAt(index1);
                              listaProductosSuma = productList;
                              listaProductosSumaGeneral += productList;
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 12, 0, 0),
                                      child: Text(
                                        dateFormatterOnlyDay.format(
                                                snapshotGroup.data!.keys
                                                    .elementAt(index1)) +
                                            '  |  Total: ' +
                                            calcularTotal(listaProductosSuma)
                                                .replaceAll('-', '+'),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                      ).animateOnPageLoad(animationsMap[
                                          'textOnPageLoadAnimation1']!),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: ListView.builder(
                                        controller: scrollController,
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: productList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: EdgeInsetsDirectional
                                                  .fromSTEB(16, 0, 16, 8),
                                            child: SwipeActionCell(
                                              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                                              key: ObjectKey(productList[index]),
                                              trailingActions: <SwipeAction>[
                                                SwipeAction(
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color: FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBtnText,
                                                    ),
                                                    title: "Eliminar",
                                                    onTap: (CompletionHandler
                                                        handler) async {
                                                      if (productList[index].id !=
                                                          null) {
                                                        await ProductController()
                                                            .eliminarProductodeFuncionario(
                                                                productList[index]
                                                                    .id,
                                                                idDeudor!);
                                                      }
                                                      setState(() {
                                                        blur = false;
                                                      });
                                                    },
                                                    color: Colors.red),
                                              ],
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(2, 0, 2, 4),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context)
                                                          .textScaleFactor *
                                                      115,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 4,
                                                        color: Color(0x520E151B),
                                                        offset: Offset(0, 2),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional
                                                        .fromSTEB(8, 8, 8, 8),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.fitWidth,
                                                            height: 70,
                                                            width: 70,
                                                            imageUrl:
                                                                productList[index]
                                                                    .imagenUrl
                                                                    .toString(),
                                                            progressIndicatorBuilder: (context,
                                                                    url,
                                                                    downloadProgress) =>
                                                                CircularProgressIndicator(
                                                                    value: downloadProgress
                                                                        .progress),
                                                            errorWidget: (context,
                                                                    url, error) =>
                                                                Icon(Icons.error),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(12,
                                                                        0, 0, 0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  (productList[index]
                                                                              .cantidad >
                                                                          1)
                                                                      ? '${productList[index].name.toString()} X${productList[index].cantidad}'
                                                                      : productList[
                                                                              index]
                                                                          .name
                                                                          .toString(),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .subtitle1,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              5,
                                                                              0,
                                                                              0),
                                                                  child: Text(
                                                                    (DateTime.now().day == productList[index].registrationDate.day &&
                                                                            DateTime.now().month ==
                                                                                productList[index]
                                                                                    .registrationDate
                                                                                    .month &&
                                                                            DateTime.now().year ==
                                                                                productList[index]
                                                                                    .registrationDate
                                                                                    .year)
                                                                        ? 'Hoy ${dateFormatterTime.format(productList[index].registrationDate).toString()}'
                                                                        : dateFormatter
                                                                            .format(
                                                                                productList[index].registrationDate)
                                                                            .toString(),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText2,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        (productList[index]
                                                                    .price >=
                                                                0)
                                                            ? Text(
                                                                formatoColombiano
                                                                    .format(productList[
                                                                            index]
                                                                        .price),
                                                                style: FlutterFlowTheme
                                                                        .of(context)
                                                                    .bodyText2,
                                                              )
                                                            : Text(
                                                                '+${formatoColombiano.format(productList[index].price).replaceAll('-', '')}',
                                                                style: FlutterFlowTheme
                                                                        .of(context)
                                                                    .bodyText2
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              22,
                                                                              141,
                                                                              83),
                                                                    )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).animateOnPageLoad(animationsMap[
                                          'listViewOnPageLoadAnimation1']!),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
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
                    child: FutureBuilder(
                      future: _getData,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return FFButtonWidget(
                            onPressed: () {
                              setState(() {});
                            },
                            text: 'Total: ${snapshot.data.toString()}',
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
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
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
                          );
                        } else {
                          return FFButtonWidget(
                            onPressed: () {
                              setState(() {});
                            },
                            text: 'Total: \$0',
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
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBtnText,
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
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (blur)
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 0),

                      child: _cajaAdvertencia(
                          context,
                          '¿Esta realmente seguro que desea eliminar este registro?',
                          idProductoEliminar),
                      //. animateOnActionTrigger(animationsMap['cajaAdvertenciaOnActionTriggerAnimation']!,hasBeenTriggered: true),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cajaAdvertencia(context, mensaje, id) {
    return Align(
      alignment: AlignmentDirectional(0, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 5),
        child: Container(
          width: 450,
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 7,
                color: Color(0x4D000000),
                offset: Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    'Advertencia',
                    style: FlutterFlowTheme.of(context).title2.override(
                          fontFamily: 'Poppins',
                          color: FlutterFlowTheme.of(context).primaryText,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).title2Family),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    mensaje,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyText1Family),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      if (idProductoEliminar != null) {
                        await ProductController().eliminarProductodeFuncionario(
                            idProductoEliminar!, idDeudor!);
                      }
                      setState(() {
                        blur = false;
                      });
                    },
                    text: 'Sí, deseo eliminarlo',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50,
                      color: Color(0xFFFC4253),
                      textStyle: FlutterFlowTheme.of(context)
                          .subtitle2
                          .override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).primaryBtnText,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).subtitle2Family),
                          ),
                      elevation: 2,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    showLoadingIndicator: false,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          setState(() {
                            blur = false;
                          });
                        },
                        text: 'No, cancelar',
                        options: FFButtonOptions(
                          width: 170,
                          height: 50,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          textStyle: FlutterFlowTheme.of(context)
                              .subtitle2
                              .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .subtitle2Family),
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        showLoadingIndicator: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  calcularTotalGeneral() {
    logger.Logger().v('ola');
    double totalPrice = 0;
    log(listaProductosSumaGeneral.length.toString());
    logger.Logger().v(listaProductosSumaGeneral.length.toString());
    listaProductosSumaGeneral.forEach((element) {
      totalPrice += element.price;
    });
    logger.Logger().v(totalPrice);
    setState(() {
      totalGeneral = formatoColombiano.format(totalPrice);
    });
    log(totalGeneral);
    logger.Logger().v(totalGeneral);
  }

  String calcularTotal(List<Product> listaSumar) {
    double totalPrice = 0;
    log(listaSumar.length.toString());
    logger.Logger().v(listaSumar.length.toString());
    listaSumar.forEach((element) {
      totalPrice += element.price;
    });
    logger.Logger().v(totalPrice);
    return formatoColombiano.format(totalPrice).toString();
  }
}
