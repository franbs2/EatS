import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/style/color.dart';
import '../../core/style/strings_app.dart';
import '../providers/preferences_provider.dart';

/// O [DietsListWidget] é um widget que exibe uma lista de opções de dieta que os usuários podem selecionar.
///
/// - Objetivo:
///   - Este widget permite que os usuários escolham suas dietas preferidas a partir de uma lista de opções, usando checkboxes para seleção.
///   - Oferece botões para salvar ou cancelar as seleções feitas.
///
/// - Estrutura:
///   - O widget utiliza um [Column] para organizar verticalmente seus filhos.
///   - Inclui uma lista de [CheckboxListTile] para cada opção de dieta.
///   - Fornece botões de ação para cancelar ou salvar as seleções.

class DietsListWidget extends StatelessWidget {
  /// Construtor do widget, com a chave opcional para identificar o widget na árvore.
  const DietsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de opções de dietas carregada a partir das strings do aplicativo.
    const List<String> dietas = StringsApp.listDiets;
    // Obtém a instância do Provider para acessar e manipular as preferências do usuário.
    final preferencesProvider = Provider.of<PreferencesProvider>(context);

    return Padding(
      // Adiciona espaçamento ao redor do widget principal.
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        // Organiza os filhos verticalmente e centraliza o conteúdo.
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              StringsApp.selectDiets,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...dietas.map((diet) => CheckboxListTile(
                checkColor: AppTheme.secondaryColor,
                activeColor: AppTheme.primaryColor,
                title: Text(
                  diet,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                value: preferencesProvider.selectedDiets.contains(diet),
                onChanged: (bool? newValue) {
                  // Alterna a seleção da dieta no provedor de preferências.
                  preferencesProvider.toggleDiet(diet);
                },
              )),
          const SizedBox(height: 16),
          Row(
            // Organiza os botões horizontalmente e os posiciona com espaçamento.
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  StringsApp.cancel,
                  style: TextStyle(
                    color: AppTheme.atencionRed,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Salva as seleções feitas e fecha o diálogo.
                  preferencesProvider.saveDiets(context);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  StringsApp.save, // Texto do botão de salvar.
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.primaryColor, // Cor do texto do botão.
                    fontWeight: FontWeight.normal, // Peso da fonte do botão.
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
