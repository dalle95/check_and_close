import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../global.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  Dio dio = Dio();

  HttpUtil._internal();

  Future<void> initialize() async {
    // Recupero l'url ambiente
    final urlAmbiente = await getUrlAmbiente();

    // Definisco le opzioni
    BaseOptions options = BaseOptions(
      baseUrl: urlAmbiente!,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {},
      contentType: "application/vnd.api+json",
      responseType: ResponseType.json,
      validateStatus: (status) {
        // Consente di accettare tutti i codici di stato
        return status != null && status < 500;
      },
    );

    // Aggiorno l'istanza di dio
    dio = Dio(options);

    // Per ignorare i certificati non validi (opzionale)
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };
  }

  // Chiamata POST Autenticazione
  Future authentication(
    String path,
    String username,
    String password,
  ) async {
    Logger().d('Funzione AUTHENTICATION');
    // Definisco il Content-Type specifico per la chiamata di autenticazione
    Options requestOptions = Options(
      contentType: Headers.formUrlEncodedContentType,
      validateStatus: (status) {
        // Consente di accettare tutti i codici di stato
        return status != null && status < 503;
      },
    );

    // Recupero l'url ambiente
    final urlAmbiente = await getUrlAmbiente();

    // Faccio la chiamata
    var response = await dio.post(
      '$urlAmbiente$path',
      queryParameters: {
        'login': username,
        'password': password,
        'origin': 'ORIGIN',
      },
      options: requestOptions,
    );

    Logger().d(response);

    return response;
  }

  // Chiamata GET
  Future get(
    String path, {
    dynamic mydata,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Logger().d('Funzione GET');

    // Recupero le opzioni predefinite se non sono settate di nuove
    Options requestOptions = options ?? Options();
    // Controllo se è presente un header e nel caso lo estraggo dall'istanza
    requestOptions.headers = requestOptions.headers ?? {};

    // Estraggo l'header di autenticazione se presente
    Map<String, dynamic>? authorization = await getAuthorizationHeader();

    // Controllo se è presente
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    // Faccio la chiamata
    var response = await dio.get(
      path,
      data: mydata,
      queryParameters: queryParameters,
      options: requestOptions,
    );

    // Logger().d(response);

    return response;
  }

  // Chiamata POST
  Future post(
    String path, {
    dynamic mydata,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Logger().d('Funzione POST');
    // Recupero le opzioni predefinite se non sono settate di nuove
    Options requestOptions = options ?? Options();
    // Controllo se è presente un header e nel caso lo estraggo dall'istanza
    requestOptions.headers = requestOptions.headers ?? {};

    // Estraggo l'header di autenticazione se presente
    Map<String, dynamic>? authorization = await getAuthorizationHeader();

    // Controllo se è presente
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    // Faccio la chiamata
    var response = await dio.post(
      path,
      data: mydata,
      queryParameters: queryParameters,
      options: requestOptions,
    );

    return response;
  }

  // Chiamata PATCH
  Future patch(
    String path, {
    dynamic mydata,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Logger().d('Funzione PATCH');
    // Recupero le opzioni predefinite se non sono settate di nuove
    Options requestOptions = options ?? Options();
    // Controllo se è presente un header e nel caso lo estraggo dall'istanza
    requestOptions.headers = requestOptions.headers ?? {};

    // Estraggo l'header di autenticazione se presente
    Map<String, dynamic>? authorization = await getAuthorizationHeader();

    // Controllo se è presente
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    // Faccio la chiamata
    var response = await dio.patch(
      path,
      data: mydata,
      queryParameters: queryParameters,
      options: requestOptions,
    );

    //Logger().d(response);

    return response;
  }

  // Funzione per estarre l'header
  Future<Map<String, dynamic>?> getAuthorizationHeader() async {
    var headers = <String, dynamic>{};
    // Estrazione dell'header dal dispositivo
    var accessToken = await Global.storageService.getUserToken();
    // Inizializzazione dell'header se non è nullo
    if (accessToken!.isNotEmpty) {
      headers = {
        "X-CS-Access-Token": accessToken,
      };
    }
    return headers;
  }

  // Funzione per estarre l'url Ambiente
  Future<String?> getUrlAmbiente() async {
    var urlAmbiente = await Global.storageService.getUrlAmbiente();
    return urlAmbiente;
  }
}
