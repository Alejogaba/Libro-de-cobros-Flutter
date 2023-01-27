import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

import '../agregarFiado/anadir_fiado.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class CustomFbAdd extends StatefulWidget {
  final ScrollController controller;
  final String? idDeudor;
  final String? nombreDeudor;
  const CustomFbAdd(
      {Key? key, required this.controller, this.idDeudor, this.nombreDeudor})
      : super(key: key);

  @override
  _CustomFbAddState createState() => _CustomFbAddState();
}

class _CustomFbAddState extends State<CustomFbAdd> {
  bool fbEsVisible = true;
  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        Logger().v('Scroll listener true');
        if (fbEsVisible) {
          setState(() {
            fbEsVisible = false;
          });
        }
      } else {
        Logger().v('Scroll listener false');
        if (fbEsVisible == false) {
          setState(() {
            fbEsVisible = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 20, 80),
      child: Visibility(
        visible: fbEsVisible,
        child: FloatingActionButton(
          isExtended: fbEsVisible,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AgregarFiado(
                  idDeudor: widget.idDeudor,
                  nombreDeudor: widget.nombreDeudor,
                ),
              ),
            ).then((value) {
              setState(() {});
            });
          },
          child: Icon(Icons.add),
          backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        ),
      ),
    );
  }
}
