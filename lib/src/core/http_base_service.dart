import 'package:http/http.dart' as http;
import 'package:meet_us/src/core/restful_service.dart';

class HttpBaseService extends AbstractRestfulService {
  final String _domain;
  static final baseHeaders = <String, String>{};

  HttpBaseService(this._domain);

  Uri _getUri(
    String api,
    Map<String, String>? queryParameters,
  ) {
    return Uri.https(_domain, api, queryParameters);
  }

  bool isSuccess(int statusCode) => statusCode == 200 || statusCode == 201;

  Map<String, String> _getHeaders(
    Map<String, String>? headers, {
    Map<String, String>? defaultHeader,
  }) {
    final tempHeaders = headers ?? defaultHeader ?? <String, String>{};
    tempHeaders.addAll(baseHeaders);
    return tempHeaders;
  }

  @override
  Future<http.Response> get(
    String api, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    final http.Response response = await http.get(
      _getUri(api, queryParameters),
      headers: _getHeaders(headers),
    );
    return response;
  }

  @override
  Future<http.Response> post(
    String api, {
    Map<String, String>? headers,
    body,
    Map<String, String>? queryParameters,
  }) async {
    final http.Response response = await http.post(
      _getUri(api, queryParameters),
      headers: _getHeaders(
        headers,
        defaultHeader: <String, String>{'Content-Type': 'application/json'},
      ),
      body: body,
    );
    return response;
  }

  @override
  Future<http.StreamedResponse> postWithMedia(
    String api, {
    required List<String> mediasPath,
    Map<String, String>? headers,
    Map<String, String>? body,
    Map<String, String>? queryParameters,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      _getUri(api, queryParameters),
    );

    request.headers.addAll(
      _getHeaders(
        headers,
        defaultHeader: <String, String>{'Content-Type': 'multipart/form-data'},
      ),
    );

    if (body != null) {
      for (final key in body.keys) {
        request.fields[key] = body[key]!;
      }
    }

    for (final path in mediasPath) {
      final multipartFile = await http.MultipartFile.fromPath('files', path);

      request.files.add(multipartFile);
    }

    return request.send();
  }

  @override
  Future<http.Response> put(
    String api, {
    Map<String, String>? headers,
    body,
    Map<String, String>? queryParameters,
  }) async {
    final http.Response response = await http.put(
      _getUri(api, queryParameters),
      headers: _getHeaders(
        headers,
        defaultHeader: <String, String>{'Content-Type': 'application/json'},
      ),
      body: body,
    );
    return response;
  }

  @override
  Future<http.Response> patch(
    String api, {
    Map<String, String>? headers,
    body,
    Map<String, String>? queryParameters,
  }) async {
    final http.Response response = await http.patch(
      _getUri(api, queryParameters),
      headers: _getHeaders(
        headers,
        defaultHeader: <String, String>{'Content-Type': 'application/json'},
      ),
      body: body,
    );
    return response;
  }

  @override
  Future<http.StreamedResponse> patchWithMedia(
    String api, {
    required List<String> mediasPath,
    Map<String, String>? headers,
    body,
    Map<String, String>? queryParameters,
  }) async {
    final request = http.MultipartRequest(
      'PATCH',
      _getUri(api, queryParameters),
    );

    request.headers.addAll(
      _getHeaders(
        headers,
        defaultHeader: <String, String>{'Content-Type': 'multipart/form-data'},
      ),
    );

    if (body != null) {
      for (final key in body.keys) {
        request.fields[key] = body[key]!;
      }
    }

    for (final path in mediasPath) {
      final multipartFile = await http.MultipartFile.fromPath('files', path);

      request.files.add(multipartFile);
    }

    return request.send();
  }

  @override
  Future<http.Response> delete(
    String api, {
    Map<String, String>? headers,
    body,
    Map<String, String>? queryParameters,
  }) async {
    final http.Response response = await http.delete(
      _getUri(api, queryParameters),
      headers: _getHeaders(
        headers,
        defaultHeader: <String, String>{'Content-Type': 'application/json'},
      ),
      body: body,
    );
    return response;
  }
}
