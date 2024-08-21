import 'package:eats/core/routes/routes.dart';
import 'package:eats/data/datasources/auth_methods.dart';
import 'package:eats/presentation/widget/text_password_input_widget.dart';
import 'package:eats/presentation/widget/text_widget.dart';
import 'package:flutter/material.dart';
import '../../core/style/strings_app.dart';
import '../widget/button_default_widget.dart';
import '../widget/button_google_widget.dart';
import '../widget/continue_with_widget.dart';
import '../widget/page_default_auth.dart';
import '../widget/text_button_have_account_widget.dart';
import '../widget/title_initial_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();

  void _loginUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authMethods.loginUser(
          email: _emailController.text,
          password: _senhaController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário conectado com sucesso!')),
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
            const SizedBox(height: 12),
            const TitleInitialWidget(
              title: StringsApp.welcomeLogin,
              subtitle: StringsApp.happy,
              space: 8.0,
            ),
            const SizedBox(height: 32),
            const ButtonGoogleWidget(),
            const SizedBox(height: 32),
            const ContinueWithWidget(),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextInputWidget(
                    hint: StringsApp.email,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  TextPasswordInputWidget(
                      hint: StringsApp.password,
                      controller: _senhaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        return null;
                      }),
                ],
              ),
            ),
            const SizedBox(height: 48),
            TextButtonHaveAccountWidget(
              onPressed: () =>
                  Navigator.of(context).pushNamed(RoutesApp.registerPage),
              title: StringsApp.dontHaveAccount,
            ),
            const SizedBox(height: 24),
            ButtonDefaultlWidget(
              text: StringsApp.login,
              color: const Color(0xffE1AA1E),
              onPressed: () {
                _loginUser(context);
              },
            ),
          ],
        ),
      ),
    ));
  }
}
