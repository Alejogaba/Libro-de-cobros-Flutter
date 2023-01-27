import 'package:libro_de_cobros_app/agregarFiado/anadir_fiado.dart';
import 'package:libro_de_cobros_app/backend/services/deudorController.dart';
import 'package:libro_de_cobros_app/index.dart';
import 'package:libro_de_cobros_app/historialCompras/historialCompras.dart';


import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:flutter_animate/flutter_animate.dart';

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

  @override
  void initState() {
    super.initState();
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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
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
                                      style:
                                          FlutterFlowTheme.of(context).title1,
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.94,
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
                                        future:
                                            DeudorController().getDeudores(),
                                        builder:
                                            (BuildContext context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.data != null) {
                                            return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.vertical,
                                              itemCount: snapshot.data!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return SwipeTo(
                                                  iconOnLeftSwipe: Icons.add,
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
                                                              .data![index].id,
                                                          nombreDeudor: snapshot
                                                              .data![index]
                                                              .name,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  onRightSwipe: () {
                                                    setState(() {
                                                      snapshot.data![index]
                                                        .editMode = true;
                                                    snapshot.data![index]
                                                        .textFieldFocus
                                                        .requestFocus();
                                                    });
                                                    
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                16, 8, 16, 0),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                HistorialCompras(
                                                                    idDeudor: snapshot
                                                              .data![index].id,
                                                          nombreDeudor: snapshot
                                                              .data![index]
                                                              .name,
                                                          )),
                                                        );
                                                      },
                                                      onLongPress: () async {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
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
                                                      child: Container(
                                                        width: double.infinity,
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
                                                                  Offset(0, 1),
                                                            )
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(8,
                                                                      8, 12, 8),
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
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child: Image
                                                                    .network(
                                                                  'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                                                  width: 70,
                                                                  height: 70,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    if ((snapshot
                                                                        .data![
                                                                            index]
                                                                        .editMode))
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              10,
                                                                              5,
                                                                              10,
                                                                              5),
                                                                          child:
                                                                              TextFormField(
                                                                            focusNode:
                                                                                snapshot.data![index].textFieldFocus,
                                                                            controller:
                                                                                snapshot.data![index].textController,
                                                                            obscureText:
                                                                                false,
                                                                            decoration:
                                                                                InputDecoration(
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
                                                                            style:
                                                                                FlutterFlowTheme.of(context).bodyText1.override(fontFamily: 'Poppins', fontSize: 18),
                                                                            keyboardType:
                                                                                TextInputType.text,
                                                                            onChanged:
                                                                                (value) {},
                                                                            onEditingComplete:
                                                                                () {},
                                                                            onFieldSubmitted:
                                                                                (suggestion) async {
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
                                                                        .data![
                                                                            index]
                                                                        .editMode))
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            16,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data![index]
                                                                              .name
                                                                              .toString(),
                                                                          style:
                                                                              FlutterFlowTheme.of(context).subtitle1,
                                                                        ),
                                                                      ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              16,
                                                                              2,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Text(
                                                                        'Head of Procurement',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyText2,
                                                                      ),
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
      ),
    );
  }
}
