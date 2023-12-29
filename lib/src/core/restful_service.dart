abstract class AbstractRestfulService {
  Future<dynamic> get(
    String api, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  });

  Future<dynamic> post(
    String api, {
    Map<String, String>? headers,
    body,
    Map<String, String>? queryParameters,
  });

  Future<dynamic> postWithMedia(
    String api, {
    Map<String, String>? headers,
    Map<String, String>? body,
    Map<String, String>? queryParameters,
    required List<String> mediasPath,
  });

  Future<dynamic> put(
    String api, {
    Map<String, String>? headers,
    body,
    Map<String, String>? queryParameters,
  });

  Future<dynamic> patch(
    String api, {
    Map<String, String>? headers,
    body,
    Map<String, String>? queryParameters,
  });

  Future<dynamic> patchWithMedia(
    String api, {
    Map<String, String>? headers,
    Map<String, String>? body,
    Map<String, String>? queryParameters,
    required List<String> mediasPath,
  });

  Future<dynamic> delete(
    String api, {
    Map<String, String>? headers,
    body,
    Map<String, String>? queryParameters,
  });
}
