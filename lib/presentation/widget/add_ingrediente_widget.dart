import 'package:eats/core/style/strings_app.dart';
import 'package:flutter/material.dart';

/// Um widget para adicionar e remover ingredientes em uma lista.
///
/// Este widget permite ao usuário adicionar múltiplos campos de entrada para
/// ingredientes, onde cada campo pode ser removido individualmente. O layout
/// é baseado em uma lista de campos de texto e um botão para adicionar novos
/// campos. A funcionalidade é gerenciada através de um [StatefulWidget]
/// para permitir a modificação dinâmica do número de campos.

class AddIngredienteWidget extends StatefulWidget {
  /// Cria uma instância do widget [AddIngredienteWidget].

  const AddIngredienteWidget({super.key});

  @override
  State<AddIngredienteWidget> createState() => _AddIngredientesWidgetState();
}

class _AddIngredientesWidgetState extends State<AddIngredienteWidget> {
  /// Lista que mantém os controladores de texto para os campos de ingrediente.
  ///
  /// Cada [TextEditingController] é responsável por gerenciar o texto de um
  /// campo de entrada para um ingrediente específico.
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    // Adiciona o primeiro campo de ingrediente ao inicializar o estado.
    _addIngrediente();
  }

  /// Adiciona um novo campo de ingrediente à lista de controladores.
  ///
  /// Esta função cria um novo [TextEditingController] e o adiciona à lista
  /// [_controllers]. Em seguida, atualiza o estado do widget para refletir
  /// a adição do novo campo.
  void _addIngrediente() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  /// Remove um campo de ingrediente com base no índice fornecido.
  ///
  /// Esta função remove o controlador de texto da lista [_controllers] e
  /// atualiza o estado do widget para refletir a remoção do campo. O índice
  /// determina qual campo será removido.
  void _removeIngrediente(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringsApp.ingredientTitle),
        // Adiciona um título à AppBar do Scaffold.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              labelText:
                                  '${StringsApp.ingredientTitle} ${index + 1}',
                              // Rotula o campo com "Ingrediente" seguido do número do campo.
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _removeIngrediente(index),
                          // Botão para remover o campo de ingrediente.
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Adiciona um botão para adicionar um novo campo de ingrediente.
            ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.green),
              label: const Text(StringsApp.addIngredient),
              onPressed: _addIngrediente,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                side: const BorderSide(
                    color: Colors.green), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
