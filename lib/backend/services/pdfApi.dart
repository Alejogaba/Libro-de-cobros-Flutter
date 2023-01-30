import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:libro_de_cobros_app/flutter_flow/flutter_flow_theme.dart';
import 'package:open_filex/open_filex.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart' as OpenFile;
import 'package:pdf_image_renderer/pdf_image_renderer.dart' as pdfRender;
import 'package:pdf/widgets.dart' as pw;


import '../../models/deudor.dart';
import '../../models/product.dart';

class PdfApi {
  final PdfColor baseColor = PdfColor.fromHex('000000');
  final PdfColor accentColor = PdfColor.fromHex('1b800b');
  final PdfColor _accentTextColor = PdfColor.fromHex('000000');
  Uint8List? _logo1;
  Uint8List? _logo2;
  NumberFormat formatoColombiano = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
      customPattern: '\$#,##0');

  String calcularTotal(List<Product> listaSumar) {
    double totalPrice = 0;
    log(listaSumar.length.toString());

    listaSumar.forEach((element) {
      totalPrice += element.price;
    });

    return formatoColombiano.format(totalPrice).toString();
  }

  Future<bool> generarHojaSalida(
      Map<DateTime, List<Product>> listaProductosDeudor,
      List<Product> productList,
      String nombreDeudor) async {
    final pdf = Document();
    List<Product> listaProductosSumaGeneral = [];
    List<Product> listaProductosSuma = [];
    Map<String, List<Product>> groupedProducts = {};
    var dateFormatter = DateFormat.jm('es_US');
    var dateFormatterTime = DateFormat.jm('es_US');
    var dateFormatterOnlyDay = DateFormat.EEEE('es_US').add_d().add_MMM();
    listaProductosDeudor.updateAll((key, value) => productList);
    double anchoBloque = 6 * PdfPageFormat.cm;
    double altobloque = 1.5 * PdfPageFormat.cm;
    double tamanioText = 8;

    double separacionAltura = 1;
    pdf.addPage(MultiPage(
        margin: EdgeInsets.only(
            left: 1.5 * PdfPageFormat.cm,
            right: 1.5 * PdfPageFormat.cm,
            bottom: 0.6 * PdfPageFormat.cm,
            top: 0.6 * PdfPageFormat.cm),
        pageFormat: PdfPageFormat.letter,
        build: (context) => [
              pw.Center(
                  child: buildTextCentrado(nombreDeudor, 24, FontWeight.bold)),
              SizedBox(height: separacionAltura * PdfPageFormat.cm),
              
              pw.Stack(
                children:[
                  Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListView.builder(
                        itemCount: listaProductosDeudor.length,
                        itemBuilder: (Context context, int indexGroup) {
                          productList =
                              listaProductosDeudor.values.elementAt(indexGroup);
                          listaProductosSuma = productList;
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 12, 0, 0),
                                child: Text(
                                    dateFormatterOnlyDay.format(
                                            listaProductosDeudor.keys
                                                .elementAt(indexGroup)) +
                                        '  |  Total: ' +
                                        calcularTotal(listaProductosSuma)
                                            .replaceAll('-', '+'),
                                    style: TextStyle(
                                      font: Font.helvetica(),
                                      color: PdfColor.fromHex('544f4f'),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.left),
                              ),
                              for (int index = 0;
                                  index < productList.length;
                                  index += 3)
                                Row(children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(4, 0, 4, 3),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(2, 0, 2, 1),
                                        child: Container(
                                          width: anchoBloque,
                                          height: altobloque,
                                          decoration: BoxDecoration(
                                            color: PdfColor.fromHex('F1F4F8'),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4,
                                                color:
                                                    PdfColor.fromHex('FFFFFF'),
                                                offset: PdfPoint(0, 2),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(1, 2, 2, 1),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  child: pw.Image(
                                                    productList[index].netImage,
                                                    fit: BoxFit.fitWidth,
                                                    height: 35,
                                                    width: 35,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            4, 0, 0, 0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
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
                                                            style: TextStyle(
                                                              font: Font
                                                                  .helvetica(),
                                                              color: PdfColors
                                                                  .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 11,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 1, 0, 0),
                                                          child: Text(
                                                            dateFormatter
                                                                .format(productList[
                                                                        index]
                                                                    .registrationDate)
                                                                .toString(),
                                                            style: TextStyle(
                                                              font: Font
                                                                  .helvetica(),
                                                              color: PdfColor
                                                                  .fromHex(
                                                                      '544f4f'),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 11,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                (productList[index].price >= 0)
                                                    ? Text(
                                                        formatoColombiano
                                                            .format(productList[
                                                                    index]
                                                                .price),
                                                        style: TextStyle(
                                                          font:
                                                              Font.helvetica(),
                                                          color:
                                                              PdfColor.fromHex(
                                                                  '544f4f'),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                        ),
                                                      )
                                                    : Text(
                                                        '+${formatoColombiano.format(productList[index].price).replaceAll('-', '')}',
                                                        style: TextStyle(
                                                          font:
                                                              Font.helvetica(),
                                                          color: PdfColors
                                                              .green400,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                        )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  (index + 1 < productList.length)
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 1),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(4, 0, 4, 1),
                                            child: Expanded(
                                              child: Container(
                                                width: anchoBloque,
                                                height: altobloque,
                                                decoration: BoxDecoration(
                                                  color: PdfColor.fromHex(
                                                      'F1F4F8'),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 4,
                                                      color: PdfColor.fromHex(
                                                          'FFFFFF'),
                                                      offset: PdfPoint(0, 2),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      1, 2, 2, 1),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                        child: pw.Image(
                                                          productList[index + 1]
                                                              .netImage,
                                                          fit: BoxFit.fitWidth,
                                                          height: 35,
                                                          width: 35,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  4, 0, 0, 0),
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
                                                                  (productList[index + 1]
                                                                              .cantidad >
                                                                          1)
                                                                      ? '${productList[index + 1].name.toString()} X${productList[index + 1].cantidad}'
                                                                      : productList[index +
                                                                              1]
                                                                          .name
                                                                          .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    font: Font
                                                                        .helvetica(),
                                                                    color: PdfColors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            1,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  dateFormatter
                                                                      .format(productList[index +
                                                                              1]
                                                                          .registrationDate)
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    font: Font
                                                                        .helvetica(),
                                                                    color: PdfColor
                                                                        .fromHex(
                                                                            '544f4f'),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      (productList[index + 1]
                                                                  .price >=
                                                              0)
                                                          ? Text(
                                                              formatoColombiano
                                                                  .format(productList[
                                                                          index +
                                                                              1]
                                                                      .price),
                                                              style: TextStyle(
                                                                font: Font
                                                                    .helvetica(),
                                                                color: PdfColor
                                                                    .fromHex(
                                                                        '544f4f'),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 11,
                                                              ),
                                                            )
                                                          : Text(
                                                              '+${formatoColombiano.format(productList[index + 1].price).replaceAll('-', '')}',
                                                              style: TextStyle(
                                                                font: Font
                                                                    .helvetica(),
                                                                color: PdfColors
                                                                    .green400,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 11,
                                                              )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  (index + 2 < productList.length)
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 1),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(4, 0, 4, 1),
                                            child: Expanded(
                                              child: Container(
                                                width: anchoBloque,
                                                height: altobloque,
                                                decoration: BoxDecoration(
                                                  color: PdfColor.fromHex(
                                                      'F1F4F8'),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 4,
                                                      color: PdfColor.fromHex(
                                                          'FFFFFF'),
                                                      offset: PdfPoint(0, 2),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      1, 2, 2, 1),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      ClipRRect(
                                                        child: pw.Image(
                                                          productList[index + 2]
                                                              .netImage,
                                                          fit: BoxFit.fitWidth,
                                                          height: 35,
                                                          width: 35,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  4, 0, 0, 0),
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
                                                                  (productList[index + 2]
                                                                              .cantidad >
                                                                          1)
                                                                      ? '${productList[index + 2].name.toString()} X${productList[index + 2].cantidad}'
                                                                      : productList[index +
                                                                              2]
                                                                          .name
                                                                          .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    font: Font
                                                                        .helvetica(),
                                                                    color: PdfColors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            1,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  dateFormatter
                                                                      .format(productList[index +
                                                                              2]
                                                                          .registrationDate)
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    font: Font
                                                                        .helvetica(),
                                                                    color: PdfColor
                                                                        .fromHex(
                                                                            '544f4f'),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      (productList[index + 2]
                                                                  .price >=
                                                              0)
                                                          ? Text(
                                                              formatoColombiano
                                                                  .format(productList[
                                                                          index +
                                                                              2]
                                                                      .price),
                                                              style: TextStyle(
                                                                font: Font
                                                                    .helvetica(),
                                                                color: PdfColor
                                                                    .fromHex(
                                                                        '544f4f'),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 11,
                                                              ),
                                                            )
                                                          : Text(
                                                              '+${formatoColombiano.format(productList[index + 2].price).replaceAll('-', '')}',
                                                              style: TextStyle(
                                                                font: Font
                                                                    .helvetica(),
                                                                color: PdfColors
                                                                    .green400,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 11,
                                                              )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container()
                                ]),
                            ],
                          );
                        }),
                  ])
                  
                  ,]),

             
            ]));

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      bool res =
          await saveDocumentDesktop(name: 'Salida de activos.pdf', pdf: pdf);
      return res;
    } else {
      saveDocumentMobile(name: 'Salida de activos.pdf', pdf: pdf);
      return false;
    }
  }

  static Widget buildTextCentrado(
          String texto, double tamano, FontWeight fuente) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(texto,
              style: TextStyle(fontSize: tamano, fontWeight: fuente),
              textAlign: TextAlign.center),
        ],
      );

  static buildText({
    String title = '',
    String value = '',
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) async {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static Widget buildTableActivoPrestamo(
      List<Product> listaActivo, String funcionarioArea) {
    final headers = [
      'Item',
      'Descripción Dispositivo',
      'Marca',
      '# activo',
      'S/N',
      'Dependencia'
    ];

    int count = 0;

    listaActivo.forEach((element) {
      count++;
      element.cantidad = count;
    });

    final data = listaActivo
        .map((activo) => [
              activo.imagenUrl,
              activo.name,
              activo.price,
              activo.cantidad,
              activo.total,
            ])
        .toList();

    return Table.fromTextArray(
        headers: headers,
        data: data,
        border: const TableBorder(
            left: BorderSide(width: 0.6),
            right: BorderSide(width: 0.6),
            top: BorderSide(width: 0.6),
            bottom: BorderSide(width: 0.6),
            horizontalInside: BorderSide(width: 0.6),
            verticalInside: BorderSide(width: 0.6)),
        headerStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        headerAlignment: Alignment.center,
        cellHeight: 20,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: FixedColumnWidth(35.0),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FixedColumnWidth(45.0),
          4: FlexColumnWidth(),
          5: FixedColumnWidth(100.0),
        });
  }

  static Widget buildTableObservacion(String observacion) {
    List<String> products = ['Observaciones: ', observacion];
    return Table.fromTextArray(
        headers: null,
        data: List<List<String>>.generate(1, (row) => products),
        border: const TableBorder(
            left: BorderSide(width: 0.6),
            right: BorderSide(width: 0.6),
            top: BorderSide(width: 0.6),
            bottom: BorderSide(width: 0.6),
            horizontalInside: BorderSide(width: 0.6),
            verticalInside: BorderSide(width: 0.6)),
        headerStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
        headerAlignment: Alignment.center,
        cellHeight: 30,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: FixedColumnWidth(150),
          1: FlexColumnWidth(),
        });
  }

  static Widget buildTitle(String texto, double tamano, FontWeight fuente) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texto,
            style: TextStyle(fontSize: tamano, fontWeight: fuente),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildTextJustificado(
          String texto, double tamano, FontWeight fuente) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texto,
              style: TextStyle(fontSize: tamano, fontWeight: fuente),
              textAlign: TextAlign.justify),
        ],
      );

  static Future<void> saveDocumentMobile({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getExternalStorageDirectory();
    final File file = File('${dir!.path}/$name');

    await file.writeAsBytes(bytes);

    final Uri uri = Uri.file(file.path);

    if (!File(uri.toFilePath()).existsSync()) {
      log('abrir archivo 1');
    }
    //if (!await launchUrl(uri)) {
    //  log('abrir archivo 2');}
    final result = await OpenFile.OpenFilex.open(file.path);
    var _openResult = 'Desconocido';
    _openResult = "type=${result.type}  message=${result.message}";
    log('Resultado OpenResult: $_openResult');
  }

  static Future<bool> saveDocumentDesktop({
    String? name,
    Document? pdf,
  }) async {
    String? pickedFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Seleccione a ruta donde desea guardar el archivo:',
        fileName: name,
        type: FileType.custom,
        allowedExtensions: ['pdf']);

    if (pickedFile != null) {
      String extension = pickedFile.split('.').last;
      if (extension != 'pdf') {
        pickedFile = '$pickedFile.pdf';
      }
      File imagefile = File(pickedFile);
      log('ruta archivo: ${imagefile.path}');
      final bytes = await pdf!.save();

      final file = File(imagefile.path);

      await file.writeAsBytes(bytes);

      final Uri uri = Uri.file(imagefile.path);

      if (!File(uri.toFilePath()).existsSync()) {
        throw '$uri does not exist!';
      }
      if (!await launchUrl(uri)) {
        throw 'Could not launch $uri';
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<File> getFileFromAssets(String filename) async {
    assert(filename != null);
    final byteData = await rootBundle.load(filename);
    var name = filename.split(Platform.pathSeparator).last;
    var absoluteName = '${(await getLibraryDirectory()).path}/$name';
    final file = File(absoluteName);

    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  }

  static Future<File?> pickFile() async {
    String? pickedFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'Reporte de activos.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (pickedFile != null) {
      File imagefile = File(pickedFile);
      log('ruta archivo: ${imagefile.path}');
      return imagefile;
    } else {
      return null;
      // User canceled the picker
    }
  }

/*
  static Future openFilePersonal(String nombreArchivo) async {
    final dir = await getExternalStorageDirectory();
    final url = dir!.path+'/'+nombreArchivo;

    await OpenFile.open(url);
  }

*/

  static String definirEstadoActivo(int? estado) {
    switch (estado) {
      case 0:
        return 'Bueno';

      case 1:
        return 'Regular';

      case 2:
        return 'Malo';

      default:
        return 'No definido';
    }
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topLeft,
                    padding: const pw.EdgeInsets.only(bottom: 0),
                    height: 72,
                    child: _logo1 != null
                        ? pw.Image(MemoryImage(_logo1!))
                        : pw.PdfLogo(),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    height: 15,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text(
                      'Código: CRI - SGC - 001',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 15,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text(
                      'Versión: 4 / 04-01-2016',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    double altura = 10;
    return pw.Column(
      children: [
        pw.Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Center(
                child: Text('- ${context.pageNumber} -',
                    style: TextStyle(fontSize: 11),
                    textAlign: TextAlign.center),
              )
            ]),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    height: 20,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      ' ',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: altura,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      'EL PUEBLO PRIMERO',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: altura,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      'Página Web: www.lajaguaibirico-cesar.gov.co',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: altura,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      'Correo Institucional: alcaldía@lajaguadeibirico-cesar.gov.co',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: altura,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      'Teléfono (095)5769206 - Fax (095) 5769024',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: altura,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      'Calle 6 No. 3ª - 23 ',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 0),
                    height: 72,
                    child: _logo2 != null
                        ? pw.Image(MemoryImage(_logo2!))
                        : pw.PdfLogo(),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  String _formatDate(DateTime date) {
    final format = DateFormat.yMMMMEEEEd('es_CO');
    return format.format(date);
  }
}
