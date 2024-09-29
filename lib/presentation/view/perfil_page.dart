import 'dart:async';

import 'package:eats/core/routes/routes.dart';
import 'package:eats/core/style/strings_app.dart';
import 'package:eats/presentation/providers/preferences_provider.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:eats/services/google_sign_in_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/style/color.dart';
import '../widget/alergies_list_widget.dart';
import '../widget/diets_list_widget.dart';
import '../widget/preference_options_widget.dart';
import '../widget/text_username_widget.dart';

/// Página de perfil do usuário.
///
/// A [PerfilPage] exibe informações e opções relacionadas ao perfil do usuário, incluindo
/// imagem de perfil, nome de usuário, localização, e preferências alimentares como alergias e dietas.
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o provedor de dados do usuário para acessar as informações do perfil.
    final userProvider = Provider.of<UserProvider>(context);
    // Obtém o provedor de métodos de autenticação para permitir logout.
    final googleSignIn = Provider.of<GoogleSignInService>(context);

    return Scaffold(
      backgroundColor:
          AppTheme.secondaryColor, // Define a cor de fundo do Scaffold.
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Exibe a imagem de perfil do usuário como um fundo de tela.
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.55,
                      minHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.memory(
                        userProvider.profileImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 36, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 28,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ), // Ícone de voltar.
                        // Menu de opções no canto superior direito.
                        PopupMenuButton(
                            offset: const Offset(0, 50),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16))),
                            icon: const Icon(
                              Icons.menu_sharp,
                              size: 28,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            itemBuilder: (context) {
                              return [
                                // Opção para editar o perfil.
                                PopupMenuItem(
                                  onTap: () => Navigator.pushNamed(
                                      context, RoutesApp.editPefilPage,
                                      arguments: true),
                                  child: const SizedBox(
                                    child: Text(
                                      'Editar Perfil',
                                      style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                // Opção para visualizar dados pessoais (não implementada).
                                PopupMenuItem(
                                  onTap: () => {
                                    Navigator.pushNamed(
                                        context, RoutesApp.termsOfUsePage)
                                  },
                                  child: const Text('Termos de Uso',
                                      style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.normal)),
                                ),
                                // Opção para sair da conta.
                                PopupMenuItem(
                                  onTap: () async {
                                    googleSignIn.signOutFromGoogle();
                                    Navigator.of(context).pop();
                                    Timer(const Duration(milliseconds: 500),
                                        () {
                                      if (context.mounted) {
                                        userProvider.clearUser();
                                      }
                                    });
                                  },
                                  child: const Text('Sair',
                                      style: TextStyle(
                                          color: AppTheme.atencionRed,
                                          fontWeight: FontWeight.normal)),
                                ),
                              ];
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Widget para exibir o nome de usuário.
                    TextUsernameWidget(
                      username: userProvider.user!.username,
                    ),

                    const SizedBox(height: 26),
                    // Widget para exibir opções de alergias.
                    PreferenceOptionsWidget(
                      title: 'Alergias',
                      onTap: () => _showAllergiesModal(context),
                      subtitle: StringsApp.add,
                    ),
                    const SizedBox(height: 18),
                    // Widget para exibir opções de dietas.
                    PreferenceOptionsWidget(
                      title: 'Dietas',
                      onTap: () => _showDietsModal(context),
                      subtitle: StringsApp.add,
                    ),
                    const SizedBox(height: 18),
                    // Widget para exibir preferências (não implementado).
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Exibe um modal com a lista de alergias do usuário.
  void _showAllergiesModal(BuildContext context) {
    final preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      elevation: 50,
      backgroundColor: AppTheme.secondaryColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(42.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 24),
          child: ListView(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Desativa a rolagem do ListView
            children: const [
              AllergiesListWidget(),
            ],
          ),
        );
      },
    ).then((_) => preferencesProvider.resetSelectedAllergies());
  }

  /// Exibe um modal com a lista de dietas do usuário.
  void _showDietsModal(BuildContext context) {
    final preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      elevation: 50,
      backgroundColor: AppTheme.secondaryColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(42.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 24),
          child: ListView(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Desativa a rolagem do ListView
            children: const [
              DietsListWidget(),
            ],
          ),
        );
      },
    ).then((_) => preferencesProvider.resetSelectedDiets());
  }
}
