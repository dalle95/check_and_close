import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//import 'package:firebase_core/firebase_core.dart';

import 'global.dart';

import 'common/routes/routes.dart';
import 'common/themes/app_theme.dart';

Future<void> main() async {
  await Global.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...AppPages.allBlocProviders(context),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          theme: theme,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => FutureBuilder<Widget>(
                future: AppPages.generateRouteSettings(settings),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Mostra un indicatore di caricamento mentre attendi il risultato
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // Gestisci eventuali errori
                    return Scaffold(
                      body: Center(
                        child: Text('Errore: ${snapshot.error}'),
                      ),
                    );
                  } else {
                    // Quando i dati sono disponibili, costruisci il widget desiderato
                    return snapshot.data ??
                        const Scaffold(
                          body: Center(
                            child: Text('Errore: Nessun dato disponibile'),
                          ),
                        );
                  }
                },
              ),
              settings: settings,
            );
          },
        ),
      ),
    );
  }
}
