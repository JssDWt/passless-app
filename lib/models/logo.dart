import 'dart:typed_data';

class Logo {
  int width;
  int height;
  String mimeType;
  Uint8List data;

  Logo(this.width, this.height, this.mimeType, this.data);
}