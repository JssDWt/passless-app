import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/utils/app_config.dart';
import 'package:transparent_image/transparent_image.dart';

class LogoWidget extends StatefulWidget {
  final Receipt receipt;
  final Alignment alignment;
  LogoWidget(
    this.receipt, 
    {@required this.alignment}
  ) : assert(receipt != null),
      assert(alignment != null);

  @override
  LogoWidgetState createState() => LogoWidgetState();
}

class LogoWidgetState extends State<LogoWidget> {
  static const int MAX_WIDTH = 150;
  static const int MAX_HEIGHT = 65;
  static const int AREA = 2700;
  static const int QUALITY_FACTOR = 2;
  static const int URL_WIDTH = MAX_WIDTH * QUALITY_FACTOR;
  static const int URL_HEIGHT = MAX_HEIGHT * QUALITY_FACTOR;
  static const int URL_AREA = 2700 * QUALITY_FACTOR * QUALITY_FACTOR;
  String url;

  @override
  void didChangeDependencies()
  {
    super.didChangeDependencies();
    url = _getUrl(context);
  }

  String _getUrl(BuildContext context)
  {
    String base = AppConfig.of(context).apiBaseUrl;
    String identifier = widget.receipt.vendor.identifier;
    return "${base}vendors/$identifier/logo?area=$URL_AREA&maxWidth=$URL_WIDTH&maxHeight=$URL_HEIGHT";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MAX_HEIGHT.toDouble(), 
      width: MAX_WIDTH.toDouble(), 
      child: Align(
        alignment: widget.alignment,
        child: FadeInImage(
            fadeInDuration: const Duration(milliseconds: 350),
            placeholder: MemoryImage(kTransparentImage),
            image: CachedNetworkImageProvider(
              url, 
              scale: QUALITY_FACTOR.toDouble()
            )
        ),
      )
    );
  }
}