import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/utils/app_config.dart';

class LogoWidget extends StatefulWidget {
  final Receipt receipt;
  final Alignment alignment;
  LogoWidget(this.receipt, {@required this.alignment});

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
  Image image;

  @override
  void didChangeDependencies()
  {
    super.didChangeDependencies();
    String url = _getUrl(context);
    image = Image(
      image: CachedNetworkImageProvider(
        url, 
        scale: QUALITY_FACTOR.toDouble()
      )
    );
  }

  String _getUrl(BuildContext context)
  {
    String base = AppConfig.of(context).apiBaseUrl;
    String identifier = widget.receipt.vendor.identifier;
    return "${base}vendors/$identifier/logo?area=$URL_AREA&maxWidth=$URL_WIDTH&maxHeight=$URL_HEIGHT";
  }

  Row _buildRow()
  {
    CrossAxisAlignment cross;
    MainAxisAlignment main;
    if (widget.alignment.x < 0)
    {
      main = MainAxisAlignment.start;
    }
    else if (widget.alignment.x == 0)
    {
      main = MainAxisAlignment.center;
    }
    else
    {
      main = MainAxisAlignment.end;
    }

    if (widget.alignment.y < 0)
    {
      cross = CrossAxisAlignment.start;
    }
    else if (widget.alignment.y == 0)
    {
      cross = CrossAxisAlignment.center;
    }
    else
    {
      cross = CrossAxisAlignment.end;
    }

    return Row(
      crossAxisAlignment: cross,
      mainAxisAlignment: main,
      children: <Widget>[
        Hero(
          tag: "logo${widget.receipt.id}",
          child: image
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    
    return AnimatedOpacity(
      opacity: image == null ? 0.0 : 1.0,
      duration: Duration(milliseconds: 400),
      child: Container(
        height: MAX_HEIGHT.toDouble(), 
        width: MAX_WIDTH.toDouble(), 
        child: image == null ? null : _buildRow()
      ),
    );
  }

}