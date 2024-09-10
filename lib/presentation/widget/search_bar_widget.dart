import 'package:eats/core/style/color.dart';
import 'package:flutter/material.dart';

import '../../core/style/strings_app.dart';

/// [SearchBarWidget] é um widget que exibe uma barra de pesquisa estilizada.
/// Esta barra de pesquisa inclui um ícone de busca, um campo de texto para inserir o termo de busca,
/// e um botão de filtro para aplicar ajustes nos resultados.
///
/// - Funcionamento:
///   - O campo de texto permite que o usuário digite o termo de busca.
///   - O ícone de filtro está presente para futuras funcionalidades de filtragem.
///   - O visual é definido pelo tema de cores da aplicação, com bordas arredondadas para um design moderno.
///
/// Referências:
/// - [AppTheme]: Define as cores e estilos utilizados na aplicação.

class SearchBarWidget extends StatelessWidget {
  /// Construtor padrão do widget.
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Define a aparência da barra de pesquisa com uma cor de fundo e bordas arredondadas.
      decoration: BoxDecoration(
        color: AppTheme.searchBarColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(
              Icons.search,
              color: AppTheme.secondaryColor,
            ),
          ),
          const Expanded(
            child: TextField(
              // Campo de texto para inserir o termo de busca.
              decoration: InputDecoration(
                hintText: StringsApp.search,
                hintStyle: TextStyle(
                  color: AppTheme.textInitial,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: AppTheme.secondaryColor,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.filterSearchBarColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.tune,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Função que será executada quando o botão de filtro for pressionado.
                  // Atualmente, o botão não possui funcionalidade.
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
