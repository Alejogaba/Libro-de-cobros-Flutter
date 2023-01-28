import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro_de_cobros_app/backend/services/deudorController.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:libro_de_cobros_app/backend/services/productController.dart';
import 'package:libro_de_cobros_app/index.dart';

import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:path_provider/path_provider.dart';
import '../backend/services/storageController.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';

import 'package:flutter_animate/flutter_animate.dart';

import '../flutter_flow/flutter_flow_widgets.dart';
import '../models/deudor.dart';

class DeudoresWidget extends StatefulWidget {
  const DeudoresWidget({Key? key}) : super(key: key);

  @override
  _DeudoresWidgetState createState() => _DeudoresWidgetState();
}

class _DeudoresWidgetState extends State<DeudoresWidget>
    with TickerProviderStateMixin {
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: Offset(0, 20),
          end: Offset(0, 0),
        ),
      ],
    ),
  };
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Deudor> listaDeudores = [];
  BottomBarWithSheetController _bottomBarWithSheetController =
      BottomBarWithSheetController(initialIndex: 0);

  late AnimationController _settingController;
  TextEditingController customerPhonenumberController = TextEditingController();
  TextEditingController customernameController = TextEditingController();
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  File? foto;
  final _formKey = GlobalKey<FormState>();
  Deudor editDeudor = Deudor();
  bool blur = false;

  @override
  void initState() {
    super.initState();
    _settingController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
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
      /* floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 20, 80),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AbsorbPointer(
              absorbing: false,
              child: FloatingActionButton(
                onPressed: () async {
                  try {} catch (e) {}
                },
                child: Icon(Icons.check),
                backgroundColor: Colors.green,
              ),
            )
          ],
        ),
      ),*/
      bottomNavigationBar: BottomBarWithSheet(
        controller: _bottomBarWithSheetController,
        autoClose: false,
        sheetChild: Center(
          child: _formDeudor(),
        ),
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        bottomBarTheme: BottomBarTheme(
          height: 80,
          heightClosed: 80,
          heightOpened: 400,
          mainButtonPosition: MainButtonPosition.right,
          selectedItemIconColor: Colors.transparent,
          itemIconColor: Colors.transparent,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.0),
            ),
          ),
        ),
        mainActionButtonTheme: MainActionButtonTheme(
          size: 65,
          color: FlutterFlowTheme.of(context).primaryColor,
          splash: FlutterFlowTheme.of(context).primaryColor.withAlpha(40),
          icon: Icon(
            Icons.add,
            color: FlutterFlowTheme.of(context).primaryBtnText,
            size: 35,
          ),
        ),
        onSelectItem: (p0) {
          log('message');
          log(p0.toString());
        },
        items: const [
          BottomBarWithSheetItem(icon: Icons.home_rounded),
          BottomBarWithSheetItem(icon: Icons.settings),
        ],
      ),
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: false
          ? AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              title: Text(
                'Page Title',
                style: FlutterFlowTheme.of(context).title2.override(
                      fontFamily: 'Poppins',
                      color: FlutterFlowTheme.of(context).darkSeaGreen,
                      fontSize: 22,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 2,
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (blur) {
                  setState(() {
                    blur = false;
                  });
                }
                if (_bottomBarWithSheetController.isOpened) {
                  _bottomBarWithSheetController.closeSheet();
                  if (editDeudor.id.isNotEmpty) {
                    setState(() {
                      editDeudor = Deudor();
                      customerPhonenumberController = TextEditingController();
                      customernameController = TextEditingController();
                    });
                  }
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 16, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 0, 0),
                                        child: Text(
                                          'Clientes',
                                          style: FlutterFlowTheme.of(context)
                                              .title1,
                                        ),
                                      ),
                                      if (responsiveVisibility(
                                        context: context,
                                        tabletLandscape: false,
                                        desktop: false,
                                      ))
                                        FlutterFlowIconButton(
                                          borderColor: Colors.transparent,
                                          borderRadius: 30,
                                          borderWidth: 1,
                                          buttonSize: 60,
                                          icon: Icon(
                                            Icons.search_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            print('IconButton pressed ...');
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 4, 0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.94,
                                    decoration: BoxDecoration(),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 24),
                                      child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                          child: FutureBuilder<List<Deudor>>(
                                            future: DeudorController()
                                                .getDeudores(),
                                            builder: (BuildContext context,
                                                snapshot) {
                                              if (snapshot.connectionState ==
                                                      ConnectionState.done &&
                                                  snapshot.data != null) {
                                                return ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      snapshot.data!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return SwipeTo(
                                                      iconOnLeftSwipe:
                                                          Icons.add,
                                                      iconOnRightSwipe:
                                                          Icons.text_fields,
                                                      iconColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryColor,
                                                      onLeftSwipe: () async {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AgregarFiado(
                                                              idDeudor: snapshot
                                                                  .data![index]
                                                                  .id,
                                                              nombreDeudor:
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .name,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      onRightSwipe: () {
                                                        setState(() {
                                                          if (!_bottomBarWithSheetController
                                                              .isOpened) {
                                                            _bottomBarWithSheetController
                                                                .openSheet();
                                                          }
                                                          setState(() {
                                                            editDeudor =
                                                                snapshot.data![
                                                                    index];
                                                            customernameController
                                                                    .text =
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .name;
                                                            customerPhonenumberController
                                                                    .text =
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .phone;
                                                          });
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(16, 8,
                                                                    16, 0),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            await Navigator
                                                                .push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          HistorialCompras(
                                                                            idDeudor:
                                                                                snapshot.data![index].id,
                                                                            nombreDeudor:
                                                                                snapshot.data![index].name,
                                                                          )),
                                                            );
                                                          },
                                                          onLongPress:
                                                              () async {
                                                            await Navigator
                                                                .push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AgregarFiado(
                                                                  idDeudor: snapshot
                                                                      .data![
                                                                          index]
                                                                      .id,
                                                                  nombreDeudor:
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .name,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  blurRadius: 3,
                                                                  color: Color(
                                                                      0x20000000),
                                                                  offset:
                                                                      Offset(
                                                                          0, 1),
                                                                )
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8,
                                                                          8,
                                                                          12,
                                                                          8),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      child: _decideImageProfile(snapshot
                                                                          .data![
                                                                              index]
                                                                          .imageUrl)),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        if ((snapshot
                                                                            .data![index]
                                                                            .editMode))
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                                                                              child: TextFormField(
                                                                                focusNode: snapshot.data![index].textFieldFocus,
                                                                                controller: snapshot.data![index].textController,
                                                                                obscureText: false,
                                                                                decoration: InputDecoration(
                                                                                  hintText: '\$Ingrese el nombre...',
                                                                                  hintStyle: FlutterFlowTheme.of(context).bodyText2,
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).gray200,
                                                                                      width: 1,
                                                                                    ),
                                                                                    borderRadius: const BorderRadius.only(
                                                                                      topLeft: Radius.circular(4.0),
                                                                                      topRight: Radius.circular(4.0),
                                                                                    ),
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: FlutterFlowTheme.of(context).gray200,
                                                                                      width: 1,
                                                                                    ),
                                                                                    borderRadius: const BorderRadius.only(
                                                                                      topLeft: Radius.circular(4.0),
                                                                                      topRight: Radius.circular(4.0),
                                                                                    ),
                                                                                  ),
                                                                                  errorBorder: UnderlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: Color(0x00000000),
                                                                                      width: 1,
                                                                                    ),
                                                                                    borderRadius: const BorderRadius.only(
                                                                                      topLeft: Radius.circular(4.0),
                                                                                      topRight: Radius.circular(4.0),
                                                                                    ),
                                                                                  ),
                                                                                  focusedErrorBorder: UnderlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: Color(0x00000000),
                                                                                      width: 1,
                                                                                    ),
                                                                                    borderRadius: const BorderRadius.only(
                                                                                      topLeft: Radius.circular(4.0),
                                                                                      topRight: Radius.circular(4.0),
                                                                                    ),
                                                                                  ),
                                                                                  filled: true,
                                                                                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyText1.override(fontFamily: 'Poppins', fontSize: 18),
                                                                                keyboardType: TextInputType.text,
                                                                                onChanged: (value) {},
                                                                                onEditingComplete: () {},
                                                                                onFieldSubmitted: (suggestion) async {
                                                                                  if (suggestion.isNotEmpty) {
                                                                                    Deudor deudor = Deudor(id: snapshot.data![index].id, name: suggestion.toString());
                                                                                    String id = await DeudorController().registrarDeudor(deudor, id: deudor.id);
                                                                                    if (id != 'error') {
                                                                                      deudor.id = id;
                                                                                      setState(() {
                                                                                        snapshot.data!.add(deudor);
                                                                                        snapshot.data![index].editMode = false;
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        if (!(snapshot
                                                                            .data![index]
                                                                            .editMode))
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                16,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              snapshot.data![index].name.toString(),
                                                                              style: FlutterFlowTheme.of(context).subtitle1,
                                                                            ),
                                                                          ),
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              16,
                                                                              2,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              FutureBuilder(
                      future: ProductController().getSumaProductosDeudor(snapshot.data![index].id),
                      builder: (BuildContext context, snapshotSuma) {
                        if (snapshotSuma.connectionState == ConnectionState.done &&
                            snapshotSuma.hasData) {
                          return Text(
                          'Deuda Total: ${snapshotSuma.data.toString()}',
                           style: FlutterFlowTheme.of(context)
                                  .bodyText2
                          );
                        } else {
                          return Text(
                             'Deuda Total: \$0',
                            style: FlutterFlowTheme.of(context)
                                  .bodyText2
                          );
                        }
                      },
                    )
                                                                        ),
                                                                        /*Padding(
                                                                          padding: EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                                  16,
                                                                                  0,
                                                                                  0,
                                                                                  0),
                                                                          child: Text(
                                                                            'ACME Co.',
                                                                            style: FlutterFlowTheme.of(
                                                                                    context)
                                                                                .bodyText2
                                                                                .override(
                                                                                  fontFamily:
                                                                                      'Poppins',
                                                                                  color:
                                                                                      FlutterFlowTheme.of(context).primaryColor,
                                                                                  fontSize:
                                                                                      12,
                                                                                ),
                                                                          ),
                                                                        ),*/
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .star_border_rounded,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    size: 24,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ).animateOnPageLoad(
                                                            animationsMap[
                                                                'containerOnPageLoadAnimation']!),
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                            '¿Esta realmente seguro que desea eliminar a ${editDeudor.name}?, recuerda que este no debe tener deudas para poder ser eliminado. ',
                            editDeudor.id),
                        //. animateOnActionTrigger(animationsMap['cajaAdvertenciaOnActionTriggerAnimation']!,hasBeenTriggered: true),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _formDeudor() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFDBE2E7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFF73B175),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                      child: Container(
                        width: 90,
                        height: 90,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: GestureDetector(
                            onTap: () {
                              _showChoiceDialog(context);
                            },
                            child: _decideImageView(imageFile)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 18, 2, 16),
                    child: TextFormField(
                      controller: customernameController,
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) return 'No deje este campo vacio';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        labelStyle: FlutterFlowTheme.of(context).bodyText2,
                        hintStyle: FlutterFlowTheme.of(context).bodyText2,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                      ),
                      style: FlutterFlowTheme.of(context).bodyText1,
                      maxLines: 2,
                      minLines: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(3, 0, 5, 0),
                  child: FlutterFlowIconButton(
                    borderColor: Color(0x60DBE2E7),
                    borderRadius: 10,
                    borderWidth: 2,
                    buttonSize: 60,
                    fillColor: FlutterFlowTheme.of(context).primaryColor,
                    icon: FaIcon(
                      FontAwesomeIcons.addressBook,
                      color: FlutterFlowTheme.of(context).primaryBtnText,
                      size: 30,
                    ),
                    showLoadingIndicator: true,
                    onPressed: () async {
                      final FullContact contact =
                          await FlutterContactPicker.pickFullContact();
                      if (contact.phones.length > 0) {
                        setState(() {
                          customernameController.text =
                              '${contact.name?.firstName} ${contact.name?.lastName}';
                          customerPhonenumberController.text = contact
                              .phones[0].number
                              .toString()
                              .replaceAll(' ', '');
                        });
                        if (contact.photo != null) {
                          await uint8ListToFile(contact.photo!.bytes);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 1),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 5, 20, 16),
                    child: TextFormField(
                      controller: customerPhonenumberController,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                        labelStyle: FlutterFlowTheme.of(context).bodyText2,
                        hintStyle: FlutterFlowTheme.of(context).bodyText2,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                      ),
                      style: FlutterFlowTheme.of(context).bodyText1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (editDeudor.id != '')
                Align(
                  alignment: AlignmentDirectional(0, 0.05),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(3, 10, 0, 8),
                    child: FlutterFlowIconButton(
                      borderColor: Color(0x60DBE2E7),
                      borderRadius: 10,
                      borderWidth: 2,
                      buttonSize: 60,
                      fillColor: Colors.red,
                      icon: FaIcon(
                        Icons.delete_outline,
                        color: FlutterFlowTheme.of(context).primaryBtnText,
                        size: 30,
                      ),
                      showLoadingIndicator: true,
                      onPressed: () async {
                        setState(() {
                          blur = true;
                        });
                      },
                    ),
                  ),
                ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0, 0.05),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: FFButtonWidget(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_bottomBarWithSheetController.isOpened) {
                            _bottomBarWithSheetController.closeSheet();
                          }
                          print('cerrar');

                          if (editDeudor.id.isNotEmpty) {
                            subirImagen(Deudor(
                                id: editDeudor.id,
                                name: customernameController.text,
                                phone: customerPhonenumberController.text));
                          } else {
                            subirImagen(Deudor(
                                name: customernameController.text,
                                phone: customerPhonenumberController.text));
                          }
                        }
                      },
                      text: 'Guardar Cambios',
                      icon: Icon(
                        Icons.save_rounded,
                        size: 15,
                      ),
                      options: FFButtonOptions(
                        width: (editDeudor.id.isNotEmpty)
                            ? MediaQuery.of(context).size.width * 0.8
                            : MediaQuery.of(context).size.width * 0.90,
                        height: 60,
                        color: Color(0xFF2C9330),
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                        elevation: 2,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _decideImageView(imageFile) {
    if (editDeudor.id.isNotEmpty &&
        editDeudor.imageUrl.isNotEmpty &&
        imageFile == null) {
      return Image.network(
        editDeudor.imageUrl,
        fit: BoxFit.fitWidth,
      );
    } else if (imageFile == null) {
      return Image.asset(
        'assets/images/Pngtreecartoon_man_avatar_vector_ilustration_8515463.png',
        fit: BoxFit.fitWidth,
      );
    } else {
      return Image.file(
        imageFile,
        fit: BoxFit.fitWidth,
      );
    }
  }

  Widget _decideImageProfile(String? urlImagen) {
    if (urlImagen != null && urlImagen.isNotEmpty) {
      return CachedNetworkImage(
        fit: BoxFit.cover,
        height: 70,
        width: 70,
        imageUrl: urlImagen.toString(),
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else {
      return Image.asset(
        'assets/images/Pngtreecartoon_man_avatar_vector_ilustration_8515463.png',
        width: 70,
        height: 70,
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> uint8ListToFile(Uint8List data) async {
    // Obtener ruta del almacenamiento temporal
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/myfile.jpg');
    File imagen = await file.writeAsBytes(data);
    setState(() {
      imageFile = imagen;
    });
  }

  Future pickImageFromGallery() async {
    print("starting get image");
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    //final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print("getting image.....");

    if (pickedFile != null) {
      imageFile = await File(pickedFile.path).create();
    } else {
      print('No image selected.');
    }
  }

  Future<void> subirImagen(Deudor deudor) async {
    StorageController storageController = StorageController();
    if (deudor.id.isNotEmpty) {
      if (imageFile != null) {
        var res = await storageController.subirImagen(
            context, imageFile!, deudor.id, 'Deudores');
        print('id imagen:' + res);
        deudor.imageUrl = res;
      } else {
        deudor.imageUrl = editDeudor.imageUrl;
      }
      var resRegistro =
          await DeudorController().registrarDeudor(deudor, id: deudor.id);
      if (resRegistro != 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Registrado con exito",
            style: FlutterFlowTheme.of(context).bodyText2.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText2Family),
                ),
          ),
          backgroundColor: Color.fromARGB(255, 30, 148, 34),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Error, no se pudo registrar al cliente",
            style: FlutterFlowTheme.of(context).bodyText2.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText2Family),
                ),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      var res = await DeudorController().registrarDeudor(deudor);
      if (res != 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text(
            "Registrado con exito",
            style: FlutterFlowTheme.of(context).bodyText2.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText2Family),
                ),
          ),
          backgroundColor: Color.fromARGB(255, 30, 148, 34),
        ));
        if (imageFile != null) {
          var resImage = await storageController.subirImagen(
              context, imageFile!, res, 'Deudores');
          deudor.id = res;
          deudor.imageUrl = resImage;
          await DeudorController().registrarDeudor(deudor,id: res);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Error, no se pudo registrar al cliente",
            style: FlutterFlowTheme.of(context).bodyText2.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText2Family),
                ),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        editDeudor = Deudor();
        imageFile = null;
        customerPhonenumberController = TextEditingController();
        customernameController = TextEditingController();
      });
    });
  }

  Future captureImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() async {
      if (pickedFile != null) {
        imageFile = await File(pickedFile.path).create();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Seleccione"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      pickImageFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camara"),
                    onTap: () {
                      captureImageFromCamera();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _cajaAdvertencia(context, mensaje, String id) {
    return Align(
      alignment: AlignmentDirectional(0, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 5),
        child: Container(
          width: 450,
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: 350,
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
                          color: Color(0xFFFC4253),
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).title2Family),
                        ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Text(
                      mensaje,
                      textAlign: TextAlign.justify,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyText1Family),
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      late var response;
                      if (id.isNotEmpty) {
                        await DeudorController().eliminar(context, id);
                      }
                      if (_bottomBarWithSheetController.isOpened) {
                        _bottomBarWithSheetController.closeSheet();
                      }
                      Future.delayed(Duration(milliseconds: 1500), () {
                        setState(() {
                          editDeudor = Deudor();
                          customerPhonenumberController =
                              TextEditingController();
                          customernameController = TextEditingController();
                          blur = false;
                        });
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
}
