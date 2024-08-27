import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart'; // Importe o PreferencesProvider
import '../widget/alergies_list_widget.dart';
import '../widget/button_default_widget.dart';
import '../widget/location_widget.dart';
import '../widget/preference_options_widget.dart';
import '../widget/text_username_widget.dart';
import '../widget/upload_widget.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PreferencesProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  UploadWidget(
                    ontap: () {},
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.47,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LocationWidget(),
                          const TextUsernameWidget(),
                          const SizedBox(height: 18),
                          PreferenceOptionsWidget(
                            title: 'Alergias',
                            onTap: () => _showAllergiesModal(context),
                          ),
                          const SizedBox(height: 18),
                          PreferenceOptionsWidget(
                            title: 'Dietas',
                            onTap: () => (),
                          ),
                          const SizedBox(height: 18),
                          PreferenceOptionsWidget(
                              title: 'Preferências', onTap: () => ()),
                          const SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ButtonDefaultlWidget(
                                  text: 'Salvar',
                                  width: 0.1,
                                  height: 16,
                                  color: const Color(0xffFBBE21),
                                  onPressed: () {},
                                ),
                              ])
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllergiesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 50,
      backgroundColor: Colors.white,
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
    );
  }

  // // Função para exibir o modal de dietas
  // void _showDietsModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
  //     ),
  //     builder: (context) {
  //       return const DietsListWidget();
  //     },
  //   );
  // }

  // // Função para exibir o modal de preferências
  // void _showPreferencesModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
  //     ),
  //     builder: (context) {
  //       return const PreferencesListWidget();
  //     },
  //   );
  // }
}
