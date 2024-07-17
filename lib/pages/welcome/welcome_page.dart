import 'package:check_and_close/common/widgets/background_view.dart';
import 'package:check_and_close/common/widgets/drawer.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  static const routeName = '/home';

  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final sizeButton = const Size(350, 250);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      endDrawer: const MainDrawer(),
      body: Stack(
        children: [
          // Background
          const BackgroundView(),
          Container(
            alignment: Alignment.center,
            child: Image.asset("assets/images/check&close_logo.png"),
          ),
        ],
      ),
    );
  }
}
