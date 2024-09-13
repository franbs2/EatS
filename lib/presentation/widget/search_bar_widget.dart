import 'package:flutter/material.dart';
import '../../core/style/color.dart';
import '../../core/style/strings_app.dart';

/// [SearchBarWidget] é um widget que exibe uma barra de pesquisa estilizada.
/// Esta barra de pesquisa inclui um ícone de busca, um campo de texto para inserir o termo de busca,
/// e um botão de filtro para aplicar ajustes nos resultados.
///
class SearchBarWidget extends StatefulWidget {
  /// Controlador para o campo de texto, permitindo acessar e controlar o valor digitado.
  final TextEditingController controller;

  /// Callback chamado quando o texto no campo de busca muda.
  final ValueChanged<String>? onChanged;

  /// Callback chamado quando o texto no campo de busca é enviado (pressiona "Enter").
  final ValueChanged<String>? onSubmitted;

  /// Construtor do widget, aceita [searchController], [onChanged] e [onSubmitted] como parâmetros.
  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _isEmpty = true;

  @override
  /// Adiciona um listener ao controlador de texto para atualizar o estado quando o texto mudar.
  void initState() {
    super.initState();
    widget.controller.addListener(_checkIfEmpty);
  }


  @override
  /// Remove o listener do controlador de texto e chama o [dispose] do estado pai.
  /// Isso é necessário para evitar vazamentos de memória, pois o controlador de texto
  /// pode manter uma referência ao estado do widget mesmo após o widget ser descartado.
  void dispose() {
    widget.controller.removeListener(_checkIfEmpty);
    super.dispose();
  }


  /// Atualiza o estado interno para refletir se o texto no campo de busca est  vazio ou n o.
  ///
  /// Isso   chamado sempre que o texto no campo de busca muda, e   usado para
  /// controlar a visibilidade do bot o de limpar o campo de busca.
  void _checkIfEmpty() {
    setState(() {
      _isEmpty = widget.controller.text.isEmpty;
    });
  }

  /// Limpa o campo de busca e notifica o listener sobre a mudan a no texto.
  ///
  /// Isso   chamado quando o usu rio clica no bot o de limpar o campo de busca.
  /// O controlador de texto   limpo, e o listener   notificado sobre a mudan a
  /// no texto com uma chamada para o callback [onChanged] com um par metro vazio.
  /// O estado   atualizado para refletir que o campo de busca est  vazio.
  void _clearSearch() {
    widget.controller.clear();
    widget.onChanged?.call('');
    setState(() {
      _isEmpty = true;
    });
  }

  @override
  /// Cria o widget da barra de pesquisa com o estilo de design definido.
  ///
  /// Este widget inclui um campo de texto para inserir o termo de busca,
  /// um bot o de limpar o campo e um bot o de filtro para aplicar ajustes
  /// nos resultados. O estilo do widget   definido com uma cor de fundo e
  /// bordas arredondadas. O campo de texto   estilizado com uma cor de texto
  /// e sem bordas. O bot o de limpar o campo   estilizado com uma cor de texto
  /// e sem bordas.
  ///
  /// - Par metros:
  ///   - [controller] ([TextEditingController]): Controlador do campo de texto.
  ///   - [onChanged] ([ValueChanged<String>]): Fun o chamada quando o texto no
  ///     campo de texto muda.
  ///   - [onSubmitted] ([ValueChanged<String>]): Fun o chamada quando o texto no
  ///     campo de texto   enviado (enter).
  ///
  Widget build(BuildContext context) {
    return Container(
      // Define a aparência da barra de pesquisa com uma cor de fundo e bordas arredondadas.
      decoration: BoxDecoration(
        color: AppTheme.searchBarColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: IconButton(
              icon: Icon(
                _isEmpty ? Icons.search : Icons.clear,
                color: AppTheme.secondaryColor,
              ),
              onPressed: _isEmpty ? null : _clearSearch,
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              // Campo de texto para inserir o termo de busca.
              decoration: const InputDecoration(
                hintText: StringsApp.search,
                hintStyle: TextStyle(
                  color: AppTheme.textInitial,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                color: AppTheme.secondaryColor,
                decoration: TextDecoration.none,
              ),
              // Executa o callback onChanged quando o texto é alterado
              onChanged: widget.onChanged,
              // Executa o callback onSubmitted quando o texto é enviado (enter)
              onSubmitted: widget.onSubmitted,
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
                  // Adicione lógica de filtro aqui se necessário.
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
