import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '/global.dart';

import '/common/entities/user.dart';
import '/common/values/label.dart';
import '/common/utils/http_util.dart';
import '/common/values/constant.dart';
import '/common/utils/error_util.dart';

class UserAPI {
  /// Funzione di autenticazione
  static Future<User> authenticate({
    required String username,
    required String password,
  }) async {
    // Per gestire i log
    var logger = Logger();

    logger.d("Funzione: authenticate");

    String token;
    User user;

    String url;
    Response<dynamic> response;
    dynamic responseData;

    final refreshDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).toIso8601String();

    logger.d(
      'Dati di autenticazione: username: $username, password: $password',
    );

    // Chiamata per autenticare l'utente richiedendo il token
    try {
      // Definizione url per l'autenticazione
      url = '/api/auth/v1/authenticate';

      // Chiamata per eseguire l'autenticazione
      response = await HttpUtil().authentication(
        url,
        username,
        password,
      );

      Logger().d(response.statusCode);

      // Gestione Ambiente non raggiungibile
      if (response.statusCode! == 502) {
        throw CustomHttpException(labels.erroreAmbienteNonRaggiungibile);
      }

      // Gestione errore credenziali
      if (response.statusCode! >= 401) {
        throw CustomHttpException(labels.credenzialiNonValideOUtenteBloccato);
      }

      var responseData = response.data;

      token = responseData['X-CS-Access-Token'];

      // Salvo sul dispositivo il token dell'utente
      await Global.storageService.setString(
        AppConstants.STORAGE_USER_TOKEN,
        token,
      );
    } on CustomHttpException catch (e) {
      throw CustomHttpException(e.message);
    } catch (error) {
      throw "Funzione authenticate | Errore: ${error.toString()}";
    }

    HttpUtil().initialize();

    // Chiamata per estrarre le informazioni utente
    try {
      // Definizione url per l'autenticazione
      url = '/api/entities/v1/actor?filter[code]=$username';

      // Chiamata per eseguire l'autenticazione
      response = await HttpUtil().get(
        url,
      );

      // Gestione errore credenziali
      if (response.statusCode! >= 400) {
        throw CustomHttpException(labels.erroreAutenticazione);
      }

      responseData = json.decode(response.toString());

      // Recupero dell'attore associato e definizione delle informazioni
      // Generali
      var actorID = responseData['data'][0]['id'];
      var actorCodice = responseData['data'][0]['attributes']['code'];
      var actorNome = responseData['data'][0]['attributes']['fullName'];

      // Definisco l'utente
      user = User(
        actorId: actorID,
        actorCodice: actorCodice,
        actorNome: actorNome,
        username: username,
        password: password,
        token: token,
        refreshDate: refreshDate,
      );
    } on CustomHttpException catch (e) {
      throw CustomHttpException(e.message);
    } catch (error) {
      logger.d(error);
      throw "Funzione authenticate | Estrazione attore | Errore: ${error.toString()}";
    }

    logger.d(
      'Autenticazione: Token: $token, ActorID: ${user.actorId}, ActorCode: ${user.actorCodice}, Data scadenza: ${user.refreshDate.toString()}',
    );

    return user;
  }
}
