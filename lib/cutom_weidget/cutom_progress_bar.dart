// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/input_fields/custom_color.dart';

///
/// Wrap around any widget that makes an async call to show a modal progress
/// indicator while the async call is in progress.
///
/// The progress indicator can be turned on or off using [inAsyncCall]
///
/// The progress indicator defaults to a [CircularProgressIndicator] but can be
/// any kind of widget
///
/// The progress indicator can be positioned using [offset] otherwise it is
/// centered
///
/// The modal barrier can be dismissed using [dismissible]
///
/// The color of the modal barrier can be set using [color]
///
/// The opacity of the modal barrier can be set using [opacity]
///
/// HUD=Heads Up Display
///
class ProgressHUD extends StatelessWidget {
  final bool? inAsyncCall;
  final double opacity;
  final Color color;
  final Offset? offset;
  final bool dismissible;
  final Widget child;
  final Color spinningKitColor;

  ProgressHUD({
    super.key,
    required this.inAsyncCall,
    this.opacity = 0.1,
    this.color = Colors.black,
    this.offset,
    this.dismissible = false,
    Color? spinningKitColor,
    required this.child,
  })  : assert(child != null),
        assert(inAsyncCall != null),
        spinningKitColor = spinningKitColor ?? CustomColor.primaryColor;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (inAsyncCall!) {
      late Widget layOutProgressIndicator;
      if (offset == null) {
        layOutProgressIndicator = Center(
            child: SpinKitDualRing(
          duration: const Duration(seconds: 1),
          color: spinningKitColor,
        ));
      }

      final modal = [
        Opacity(
          opacity: opacity,
          child: ModalBarrier(dismissible: dismissible, color: color),
        ),
        layOutProgressIndicator
      ];
      widgetList += modal;
    }
    return Stack(
      children: widgetList,
    );
  }
}
