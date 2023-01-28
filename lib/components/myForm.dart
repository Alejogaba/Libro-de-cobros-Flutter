import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:libro_de_cobros_app/backend/services/deudorController.dart';
import 'package:libro_de_cobros_app/backend/services/storageController.dart';
import 'package:libro_de_cobros_app/models/deudor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libro_de_cobros_app/flutter_flow/flutter_flow_widgets.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:logger/logger.dart' as logger;
import '../flutter_flow/flutter_flow_util.dart';

class MyForm extends StatefulWidget {
  final Deudor? deudorEdit;
  const MyForm({Key? key, this.deudorEdit}) : super(key: key);
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _number = '';
  String _imageUrl = '';

  TextEditingController customerPhonenumberController = TextEditingController();
  TextEditingController customernameController = TextEditingController();
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  File? foto;

  @override
  void initState() {
    super.initState();
    if (widget.deudorEdit != null) {
      customerPhonenumberController.text = widget.deudorEdit!.phone;
      customernameController.text = widget.deudorEdit!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        child: _decideImageView(imageFile),
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
          Align(
            alignment: AlignmentDirectional(0, 0.05),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 13, 0, 0),
              child: FFButtonWidget(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.deudorEdit != null) {
                      subirImagen(Deudor(
                          id: widget.deudorEdit!.id,
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
                  width: 340,
                  height: 60,
                  color: Color(0xFF2C9330),
                  textStyle: FlutterFlowTheme.of(context).subtitle2.override(
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
        ],
      ),
    );
  }

  Widget _decideImageView(imageFile) {
    if (widget.deudorEdit != null &&
        widget.deudorEdit!.imageUrl.isNotEmpty &&
        imageFile == null) {
      return Image.network(
        widget.deudorEdit!.imageUrl,
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

  Future<void> subirImagen(Deudor producto) async {
    if (imageFile != null) {
      StorageController storageController = StorageController();
      var res = await storageController.subirImagen(
          context, imageFile!, producto.id, 'Productos');

      setState(() {
        if (widget.deudorEdit != null) {
          DeudorController()
              .registrarDeudor(producto, id: widget.deudorEdit!.id);
        } else {
          DeudorController().registrarDeudor(producto);
        }
      });
    }
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
                children: <Widget>[
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
}
