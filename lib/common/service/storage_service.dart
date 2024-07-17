import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '/common/entities/user.dart';
import '/common/values/constant.dart';

class StorageService {
  late final FlutterSecureStorage _prefs;

  // Inizializzazione della classe
  Future<StorageService> init() async {
    _prefs = const FlutterSecureStorage();
    return this;
  }

  Future<void> setBool(String key, String value) async {
    return await _prefs.write(key: key, value: value);
  }

  Future<void> setString(String key, String value) async {
    return await _prefs.write(key: key, value: value);
  }

  Future<void> remove(String key) async {
    return await _prefs.delete(key: key);
  }

  // Controllo se è la prima apertura dell'app
  Future<bool> getDeviceFirstOpen() async {
    return await _prefs.read(
                key: AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME) ==
            "true"
        ? true
        : false;
  }

  // Controllo se l'utente è loggato
  Future<bool> getIsLoggedIn() async {
    return await _prefs.read(key: AppConstants.STORAGE_USER_DATA) == null
        ? false
        : true;
  }

  // Estrazione informazioni autenticazione
  Future<User> getUserProfile() async {
    String? profileOffline =
        await _prefs.read(key: AppConstants.STORAGE_USER_DATA);

    if (profileOffline != null && profileOffline.isNotEmpty) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(profileOffline);
        return User.fromJson(userMap);
      } catch (e) {
        // Gestisci l'errore di parsing JSON qui, se necessario
        Logger().d('Errore durante la decodifica del JSON: $e');
      }
    }
    return const User(); // Ritorna un oggetto User vuoto in caso di errore
  }

  // Estrazione del token di autenticazione
  Future<String?> getUserToken() async {
    return _prefs.read(key: AppConstants.STORAGE_USER_TOKEN);
  }

  // Estrazione url Ambiente
  Future<String?> getUrlAmbiente() async {
    return await _prefs.read(key: AppConstants.SERVER_API_URL);
  }
}
