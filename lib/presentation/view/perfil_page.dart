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

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Não precisa mais criar um novo PreferencesProvider aqui.
    final userProvider = Provider.of<UserProvider>(context);
    final authmethods = Provider.of<AuthMethods>(context);

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.white,
                      ),
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
                              PopupMenuItem(
                                onTap: () => {},
                                child: const SizedBox(
                                  child: Text(
                                    'Editar Perfil',
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () => {},
                                child: const Text('Meus dados',
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.normal)),
                              ),
                              PopupMenuItem(
                                onTap: () => authmethods.logOut(context),
                                child: const Text('Sair',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 229, 85, 74),
                                        fontWeight: FontWeight.normal)),
                              ),
                            ];
                          }),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.52,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LocationWidget(),
                        const SizedBox(height: 12),
                        TextUsernameWidget(
                          username: userProvider.user!.username,
                        ),
                        const SizedBox(height: 20),
                        PreferenceOptionsWidget(
                          title: 'Alergias',
                          onTap: () => _showAllergiesModal(context),
                        ),
                        const SizedBox(height: 18),
                        PreferenceOptionsWidget(
                          title: 'Dietas',
                          onTap: () => _showDietsModal(context),
                        ),
                        const SizedBox(height: 18),
                        PreferenceOptionsWidget(
                            title: 'Preferências', onTap: () => ()),
                        const SizedBox(height: 18),
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
