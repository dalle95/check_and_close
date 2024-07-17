import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '/common/widgets/background_view.dart';
import '/common/widgets/buttons.dart';
import '/common/widgets/text_field.dart';

import '/pages/auth/bloc/auth_blocs.dart';
import '/pages/auth/bloc/auth_events.dart';
import '/pages/auth/bloc/auth_states.dart';

import '/pages/auth/auth_controller.dart';

import '/common/widgets/text_base.dart';
import '/common/widgets/logos.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return BackgroundView(
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap(75.h),
                      buildLogo(),
                      Gap(70.h),
                      reusableTitleText(
                        'Login',
                        fontSize: 20,
                        color: Colors.white70,
                        fontWeight: FontWeight.normal,
                      ),
                      Gap(30.h),
                      buildTextField(
                        hintText: "Username",
                        textType: "username",
                        iconName: "user",
                        foregroundColor: Colors.blue,
                        func: (value) {
                          context.read<AuthBloc>().add(
                                UsernameEvent(value),
                              );
                        },
                      ),
                      Gap(10.h),
                      buildTextField(
                        hintText: "Password",
                        textType: "password",
                        iconName: "verified",
                        foregroundColor: Colors.blue,
                        func: (value) {
                          context.read<AuthBloc>().add(
                                PasswordEvent(value),
                              );
                        },
                      ),
                      Gap(50.h),
                      // Pulsante per login
                      buildElevatedButton(
                        title: "Connetti",
                        function: () =>
                            AuthController(context: context).gestisciLogIn(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
