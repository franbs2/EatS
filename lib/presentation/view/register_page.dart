import 'package:eats/core/style/strings_app.dart';
import 'package:eats/presentation/view/login_page.dart';
import 'package:eats/presentation/widget/button_google_widget.dart';
import 'package:eats/presentation/widget/continue_with_widget.dart';
import 'package:eats/presentation/widget/page_default_auth.dart';
import 'package:eats/presentation/widget/text_widget.dart';
import 'package:flutter/material.dart';
import '../../core/style/color.dart';

import '../widget/button_default_widget.dart';
import '../widget/text_button_have_account_widget.dart';
import '../widget/text_password_input_widget.dart';
import '../widget/title_initial_widget.dart';
import 'package:eats/data/datasources/auth_methods.dart';

/// Página de registro do usuário. Permite que o usuário se registre fornecendo email e senha.
///
/// A [RegisterPage] é composta por um formulário de registro, com campos para email, senha e confirmação de senha.
/// Além disso, fornece opções de login com Google, e links para a página de login existente.
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // Chave global para o formulário. Usada para validar e acessar o estado do formulário.
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto de email, senha e confirmação de senha.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  // Instância do provedor de métodos de autenticação.
  final AuthMethods _authMethods = AuthMethods();

  /// Função responsável por registrar o usuário.
  ///
  /// Valida o formulário e, se válido, tenta registrar o usuário utilizando o provedor de autenticação.
  /// Exibe mensagens de sucesso ou erro usando SnackBars.
  ///
  /// @param [context] O contexto da build atual.
  void _registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Tenta registrar o usuário.
        await _authMethods.signUpUser(
          context: context,
          email: _emailController.text,
          password: _senhaController.text,
          confirmPassword: _confirmarSenhaController.text,
        );
        if (context.mounted) {
          // Exibe uma mensagem de sucesso após o registro bem-sucedido.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário registrado com sucesso!')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          // Exibe uma mensagem de erro caso algo dê errado durante o registro.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
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
                title: StringsApp.welcome, // Texto de boas-vindas.
                subtitle: StringsApp.happy, // Subtítulo de boas-vindas.
                space: 8.0,
              ),
              const SizedBox(height: 24),
              const ButtonGoogleWidget(), // Widget para login com Google.
              const SizedBox(height: 24),
              const ContinueWithWidget(), // Widget para continuar com opções adicionais.
              const SizedBox(height: 40),
              Form(
                key: _formKey, // Define a chave do formulário para validação.
                child: Column(children: [
                  TextInputWidget(
                    hint: StringsApp
                        .labelEmail, // Texto de sugestão para o campo de email.
                    controller:
                        _emailController, // Controlador para o campo de email.
                    validator: (value) {
                      // Função de validação para o campo de email.
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um email'; // Mensagem de erro caso o campo esteja vazio.
                      }
                      return null; // Retorna nulo se a validação for bem-sucedida.
                    },
                  ),
                  const SizedBox(height: 40),
                  TextPasswordInputWidget(
                    hint: StringsApp
                        .labelPassword, // Texto de sugestão para o campo de senha.
                    controller:
                        _senhaController, // Controlador para o campo de senha.
                    validator: (value) {
                      // Função de validação para o campo de senha.
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha'; // Mensagem de erro caso o campo esteja vazio.
                      }
                      return null; // Retorna nulo se a validação for bem-sucedida.
                    },
                  ),
                  const SizedBox(height: 40),
                  TextPasswordInputWidget(
                    hint: StringsApp
                        .labelConfirmPassword, // Texto de sugestão para o campo de confirmação de senha.
                    controller:
                        _confirmarSenhaController, // Controlador para o campo de confirmação de senha.
                    validator: (value) {
                      // Função de validação para o campo de confirmação de senha.
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme sua senha'; // Mensagem de erro caso o campo esteja vazio.
                      }
                      return null; // Retorna nulo se a validação for bem-sucedida.
                    },
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              TextButtonHaveAccountWidget(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage()), // Navega para a página de login.
                  (Route<dynamic> route) =>
                      false, // Remove todas as rotas anteriores da pilha.
                ),
                title: StringsApp
                    .haveAccount, // Texto do botão para usuários que já possuem uma conta.
              ),
              const SizedBox(height: 20),
              ButtonDefaultlWidget(
                text: StringsApp.register, // Texto do botão de registro.
                color: AppTheme.loginYellow, // Cor do botão de registro.
                onPressed: () => _registerUser(
                    context), // Função chamada ao pressionar o botão.
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
