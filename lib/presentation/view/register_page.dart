import 'package:eats/presentation/style/color.dart';
import 'package:eats/presentation/style/strings_app.dart';
import 'package:eats/presentation/widget/button_google_widget.dart';
import 'package:eats/presentation/widget/continue_with_widget.dart';
import 'package:eats/presentation/widget/page_default_auth.dart';
import 'package:eats/presentation/widget/text_widget.dart';
import 'package:flutter/material.dart';

import '../widget/button_default_widget.dart';
import '../widget/text_button_have_account_widget.dart';
import '../widget/text_password_input_widget.dart';
import '../widget/title_initial_widget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _nomeController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _senhaController = TextEditingController();
  // final TextEditingController _confirmarSenhaController =
  // TextEditingController();

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
                child: const Column(children: [
                  TextInputWidget(hint: StringsApp.labelEmail),
                  SizedBox(height: 40),
                  TextPasswordInputWidget(hint: StringsApp.labelPassword),
                  SizedBox(height: 40),
                  TextPasswordInputWidget(
                      hint: StringsApp.labelConfirmPassword),
                ])),
            const SizedBox(height: 20),
            const TextButtonHaveAccountWidget(),
            const SizedBox(height: 20),
            const ButtonDefaultlWidget(
              text: StringsApp.register,
              color: Color(0xffE1AA1E),
            ),
          ],
        ),
      ),
    ));
  }
}
