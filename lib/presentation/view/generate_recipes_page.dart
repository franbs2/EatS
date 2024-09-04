import 'package:eats/presentation/widget/button_default_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/style/color.dart';
import '../../data/datasources/ia_repository.dart';

class GenerateRecipesPage extends StatefulWidget {
  const GenerateRecipesPage({super.key});

  @override
  State<GenerateRecipesPage> createState() => _GenerateRecipesPageState();
}

class _GenerateRecipesPageState extends State<GenerateRecipesPage> {
  late AIRepository _aiRepository;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _addIngrediente();
    _aiRepository = context.read<AIRepository>();
  }

  void _addIngrediente() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeIngrediente(int index) {
    if (_controllers.length > 1) {
      setState(() {
        _controllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crie sua receita'),
        centerTitle: true,
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
                              labelText: 'Ingrediente ${index + 1}',
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppTheme.primaryColor,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppTheme.primaryColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (index == _controllers.length - 1)
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline,
                                color: Colors.green, size: 28),
                            onPressed: _addIngrediente,
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.red, size: 28),
                            onPressed: () => _removeIngrediente(index),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: ButtonDefaultlWidget(
                  text: 'Gerar receita',
                  color: AppTheme.loginYellow,
                  width: 0.1 / 2,
                  height: 14,
                  onPressed: () async {
                    final ingredients = _controllers
                        .map((controller) => controller.text)
                        .toList();
                    final response =
                        await _aiRepository.generateRecipe(ingredients);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
