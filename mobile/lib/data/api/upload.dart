import 'package:dio/dio.dart';

/// A multipart body carrying one JPEG under [field], so features can
/// upload (`send(form: ...)`) without importing Dio themselves.
FormData jpegUpload(String field, List<int> bytes) => FormData.fromMap({
  field: MultipartFile.fromBytes(
    bytes,
    filename: 'photo.jpg',
    contentType: DioMediaType('image', 'jpeg'),
  ),
});
