import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// A multipart body carrying one photo under [field], so features can
/// upload (`send(form: ...)`) without importing Dio themselves. Rails
/// identifies the real type from the bytes, so a non-JPEG fallback from
/// [photoBytes] is still accepted.
FormData jpegUpload(String field, List<int> bytes) => FormData.fromMap({
  field: MultipartFile.fromBytes(
    bytes,
    filename: 'photo.jpg',
    contentType: DioMediaType('image', 'jpeg'),
  ),
});

/// Downscaled JPEG bytes for upload, or the original bytes when this
/// platform or format can't be compressed (compression throws on web and
/// on some formats). The server enforces type and the 10 MB cap.
Future<List<int>> photoBytes(XFile file) async {
  try {
    final jpeg = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 1600,
      minHeight: 1600,
      quality: 85,
    );
    if (jpeg != null) return jpeg;
  } on Object {
    // Fall back to the original bytes below.
  }
  return await file.readAsBytes();
}
