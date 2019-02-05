import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as imageUtil;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/models/logo.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/utils/app_config.dart';

class LogoWidget extends StatefulWidget {
  final double area;
  final double maxWidth;
  final double maxHeight;
  final Receipt receipt;
  LogoWidget(this.receipt, {this.area, this.maxWidth, this.maxHeight});

  @override
  LogoWidgetState createState() => LogoWidgetState();
}

class LogoWidgetState extends State<LogoWidget> {
  AppConfig config;
  Image image;

  @override
  void didChangeDependencies() {
    this.config = AppConfig.of(context);
    _renderLogo();
    super.didChangeDependencies();
  }

  Future<void> _renderLogo() async {
    Logo logo = await _getCachedLogo();
    if (logo == null) {
      logo = await _getNetworkLogo();
    }

    if (logo == null) return;

    double ratio = logo.height / logo.width;
    double resultingWidth = sqrt(widget.area / ratio);
    if (resultingWidth > widget.maxWidth) {
      resultingWidth = widget.maxWidth;
    }

    double resultingHeight = resultingWidth * ratio;
    if (resultingHeight > widget.maxHeight) {
      resultingHeight = widget.maxHeight;
      resultingWidth = resultingHeight / ratio;
    }

    if (!mounted) return;
    setState(() {
      this.image = Image.memory(
        logo.data, 
        width: resultingWidth, 
        fit: BoxFit.contain);
    });
  }

  Future<Logo> _getCachedLogo() async {
    return await Repository.of(context).getLogo(widget.receipt);
  }

  Future<Logo> _getNetworkLogo() async {
    var httpClient = HttpClient();
    Logo logo;

    try
    {
      var request = await httpClient.getUrl(
        Uri.parse(
          config.apiBaseUrl + 
          "vendors/${widget.receipt.vendor.identifier}/logo"
        )
      );

      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        logo = _parseLogo(bytes, response.headers.contentType.mimeType);
        // NOTE: This call is not awaited, since it is not a necessity to save.
        _saveLogo(logo);
      }
      else {
        debugPrint("API returned status code ${response.statusCode}");
      }
    }
    catch (e)
    {
      debugPrint("Failed to download logo:\n$e");
    }
    finally
    {
      httpClient.close();
    }

    return logo;
  }

  Logo _parseLogo(Uint8List logo, String mimeType) {
    imageUtil.Image resultingImage;

    try 
    {
      switch (mimeType) {
        case "image/jpeg":
          resultingImage = imageUtil.decodeJpg(logo);
          break;
        case "image/png":
          resultingImage = imageUtil.decodePng(logo);
          break;
        default:
          resultingImage = imageUtil.decodeImage(logo);
          break;
      }
    }
    on Exception catch (e) {
      debugPrint("Exception while parsing logo:\n$e");
    }
    catch(e, s) {
      debugPrint("Something was thrown while parsing logo:\n$e\n\nStacktrace:\n$s");
    }
    
    return Logo(
      resultingImage.width,
      resultingImage.height,
      mimeType,
      logo
    );
  }

  Future<void> _saveLogo(Logo logo) async {
    await Repository.of(context).saveLogo(widget.receipt.vendor.identifier, logo);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: image == null ? 0.0 : 1.0,
      duration: Duration(milliseconds: 400),
      child: Container(
        height: widget.maxHeight, 
        width: widget.maxWidth, 
        child: image == null ? null : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[image]
        )
      ),
    );
  }

}