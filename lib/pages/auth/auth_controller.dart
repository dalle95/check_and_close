import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';

import '/global.dart';

import '/common/data/user_api.dart';
import '/common/entities/user.dart';
import '/common/routes/names.dart';
import '/common/values/constant.dart';
import '/common/widgets/flutter_toast.dart';
import '/common/utils/error_util.dart';

import '/pages/auth/bloc/auth_blocs.dart';

class AuthController {
  final BuildContext context;

  const AuthController({required this.context});

  /// Funzione per gestire il login
  Future<void> gestisciLogIn() async {
    // Attivazione caricamento
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    try {
      // Richiamo lo stato del bloc AuthBloc per leggere le credenziali
      final state = context.read<AuthBloc>().state;
      // Definisco le credenziali
      String username = state.username;
      String password = state.password;
      if (username.isEmpty && password.isEmpty) {
        // Alter di validazione
        toastInfo(msg: "Username e password devono essere compilati");
      } else if (username.isEmpty) {
        // Alter di validazione
        toastInfo(msg: "L'username deve essere compilato");
      } else if (password.isEmpty) {
        // Alter di validazione
        toastInfo(msg: "La password deve essere compilata");
      }

      // Se ho username e password proseguo al login
      if (username.isNotEmpty && password.isNotEmpty) {
        // Estrazioni informazioni di autenticazione
        User user = await UserAPI.authenticate(
          username: username,
          password: password,
        );

        // Salvataggio informazioni di autenticazione sul dispositivo
        _saveDataOnDevice(user);
      }

      // Disattivazione caricamento
      EasyLoading.dismiss();
    } on CustomHttpException catch (e) {
      // Alter di validazione
      toastInfo(msg: e.message);
      // Disattivazione caricamento
      EasyLoading.dismiss();
    } catch (e) {
      Logger().d(e.toString());
      rethrow;
    }
  }

  /// Funzione per salvare i dati di autenticazione sul dispositivo
  Future<void> _saveDataOnDevice(User user) async {
    try {
      // Salvataggio dati sul dispositivo
      await Global.storageService.setString(
        AppConstants.STORAGE_USER_DATA,
        jsonEncode(user.toJson()),
      );

      Logger().d(
        "Credenziali salvate",
      );

      // Controllo se il context è presente e lancio la nuova pagina
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.HOME_PAGE,
          (route) => false,
        );
      }
    } catch (e) {
      Logger().d(
        "Errore nel salvataggio delle credenziali\n. Errore:\n${e.toString()}",
      );
    }
  }
}
