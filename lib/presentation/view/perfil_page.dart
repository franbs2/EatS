import 'package:eats/core/routes/routes.dart';
import 'package:eats/data/datasources/auth_methods.dart';
import 'package:eats/presentation/providers/preferences_provider.dart';
import 'package:eats/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/style/color.dart';
import '../widget/alergies_list_widget.dart';
import '../widget/diets_list_widget.dart';
import '../widget/location_widget.dart';
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
    final authmethods = Provider.of<AuthMethods>(context);

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor, // Define a cor de fundo do Scaffold.
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                // Exibe a imagem de perfil do usuário como um fundo de tela.
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Image.memory(
                    userProvider.profileImage!,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Menu de opções no canto superior direito.
                      PopupMenuButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16))),
                          icon: const Icon(
                            Icons.menu_sharp,
                            size: 28,
                            color: Colors.white,
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
                                onTap: () => {},
                                child: const Text('Meus dados',
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.normal)),
                              ),
                              // Opção para sair da conta.
                              PopupMenuItem(
                                onTap: () => authmethods.logOut(context),
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
                // Exibe o conteúdo do perfil abaixo da imagem de perfil.
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.52,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Widget para exibir a localização do usuário.
                        const LocationWidget(),
                        const SizedBox(height: 12),
                        // Widget para exibir o nome de usuário.
                        TextUsernameWidget(
                          username: userProvider.user!.username,
                        ),
                        const SizedBox(height: 20),
                        // Widget para exibir opções de alergias.
                        PreferenceOptionsWidget(
                          title: 'Alergias',
                          onTap: () => _showAllergiesModal(context),
                        ),
                        const SizedBox(height: 18),
                        // Widget para exibir opções de dietas.
                        PreferenceOptionsWidget(
                          title: 'Dietas',
                          onTap: () => _showDietsModal(context),
                        ),
                        const SizedBox(height: 18),
                        // Widget para exibir preferências (não implementado).
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Exibe um modal com a lista de alergias do usuário.
  ///
  /// Utiliza o [PreferencesProvider] para gerenciar e atualizar as alergias selecionadas.
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
        return const Padding(
          padding: EdgeInsets.only(top: 24),
          child: SingleChildScrollView(child: AllergiesListWidget()),
        );
      },
    ).then((_) => preferencesProvider.resetSelectedAllergies());
  }

  /// Exibe um modal com a lista de dietas do usuário.
  ///
  /// Utiliza o [PreferencesProvider] para gerenciar e atualizar as dietas selecionadas.
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
        return const Padding(
          padding: EdgeInsets.only(top: 24),
          child: SingleChildScrollView(child: DietsListWidget()),
        );
      },
    ).then((_) => preferencesProvider.resetSelectedDiets());
  }
}
