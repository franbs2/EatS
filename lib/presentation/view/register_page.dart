import 'package:eats/core/style/strings_app.dart';
import 'package:eats/presentation/widget/button_google_widget.dart';
import 'package:eats/presentation/widget/continue_with_widget.dart';
import 'package:eats/presentation/widget/page_default_auth.dart';
import 'package:eats/presentation/widget/text_widget.dart';
import 'package:flutter/material.dart';
import '../../core/style/color.dart';

import '../../core/routes/routes.dart';
import '../widget/button_default_widget.dart';
import '../widget/text_button_have_account_widget.dart';
import '../widget/text_password_input_widget.dart';
import '../widget/title_initial_widget.dart';
import 'package:eats/data/datasources/auth_methods.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  final AuthMethods _authMethods = AuthMethods();

  void _registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authMethods.signUpUser(
          email: _emailController.text,
          password: _senhaController.text,
          confirmPassword: _confirmarSenhaController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário registrado com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageDefaultAuth(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 12,
            ),
            const TitleInitialWidget(
              title: StringsApp.welcome,
              subtitle: StringsApp.happy,
              space: 8.0,
            ),
            const SizedBox(height: 24),
            const ButtonGoogleWidget(),
            const SizedBox(height: 24),
            const ContinueWithWidget(),
            const SizedBox(height: 40),
            Form(
                key: _formKey,
                child: Column(children: [
                  TextInputWidget(
                    hint: StringsApp.labelEmail,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  TextPasswordInputWidget(
                    hint: StringsApp.labelPassword,
                    controller: _senhaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  TextPasswordInputWidget(
                    hint: StringsApp.labelConfirmPassword,
                    controller: _confirmarSenhaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme sua senha';
                      }
                      return null;
                    },
                  ),
                ])),
            const SizedBox(height: 20),
            TextButtonHaveAccountWidget(
              onPressed: () =>
                  Navigator.of(context).pushNamed(RoutesApp.loginPage),
              title: StringsApp.haveAccount,
            ),
            const SizedBox(height: 20),
            ButtonDefaultlWidget(
              text: StringsApp.register,
              color: AppTheme.loginYellow,
              onPressed: () => _registerUser(context),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    ));
  }
}
