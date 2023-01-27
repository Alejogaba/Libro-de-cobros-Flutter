import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:logger/logger.dart';
import 'package:universal_io/io.dart';
import 'package:translator/translator.dart';
import 'package:path/path.dart' as p;
import 'package:image_compression/image_compression.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class StorageController {
  Future<String> subirImagen(BuildContext context, File imageFile, String? id,
      String bucketName) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Subiendo imagen....",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));
      final input = ImageFile(
        rawBytes: imageFile.readAsBytesSync(),
        filePath: imageFile.path,
      );
      var output;
      if (input.sizeInBytes > 300000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.noCompression, jpgQuality: 90)));
      } else if (input.sizeInBytes > 500000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.bestSpeed, jpgQuality: 80)));
      } else if (input.sizeInBytes > 700000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.defaultCompression,
                jpgQuality: 70)));
      } else if (input.sizeInBytes > 1000000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.bestCompression,
                jpgQuality: 50)));
      } else if (input.sizeInBytes > 1500000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.bestCompression,
                jpgQuality: 30)));
      } else if (input.sizeInBytes > 2000000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.bestCompression,
                jpgQuality: 10)));
      } else if (input.sizeInBytes > 3000000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.bestCompression,
                jpgQuality: 5)));
      } else {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.noCompression, jpgQuality: 95)));
      }

      log('FileName: ${output.fileName}');
      log('FilePath: ${output.filePath}');
      final bytes = output.rawBytes;
      const fileExt = 'jpg'; //output.filePath.split('.').last;
      final fileName = '$id.$fileExt';
      final filePath = fileName;
      File imagen = File(output.filePath);
      // Create a storage reference from our app
      final storageRef = FirebaseStorage.instance.ref();
      Logger().v('filename: $fileName');
      Logger().v('Storagereference');
// Create a reference to "mountains.jpg"
      final mountainsRef = storageRef.child("$fileName");

// Create a reference to 'images/mountains.jpg'
      final mountainImagesRef = storageRef.child("images/$fileName");
      Logger().v('mountainsref');
// While the file names are the same, the references point to different files
      assert(mountainsRef.name == mountainImagesRef.name);
      assert(mountainsRef.fullPath != mountainImagesRef.fullPath);
      await mountainsRef.putFile(imageFile);

      Logger().i('downloadUrl');
      final String downloadURL = await mountainsRef.getDownloadURL();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 800),
        content: Text(
          "Imagen subida con exitó",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));

      return downloadURL;
    } on FirebaseException catch (error) {
      var errorTraducido = '${error.message}';

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Error al subir imagen:$errorTraducido',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));

      return 'error';
    } catch (error) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Text(
          "Ha ocurrido un error inesperado al momento de subir la imagen, verifique su conexión a internet",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      Logger().e(error);
      return 'error';
    }
  }

  Future<String> traducir(String input) async {
    try {
      final translator = GoogleTranslator();
      var translation = await translator.translate(input, from: 'en', to: 'es');
      return translation.toString();
    } catch (e) {
      log(e.toString());
      return "Ha ocurrido un error inesperado, revise su conexión a internet";
    }
  }
}
