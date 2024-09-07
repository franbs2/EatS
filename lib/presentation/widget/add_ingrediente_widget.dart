import 'package:flutter/material.dart';

class AddIngredienteWidget extends StatefulWidget {
  const AddIngredienteWidget({super.key});

  @override
  _AddIngredientesWidgetState createState() => _AddIngredientesWidgetState();
}

class _AddIngredientesWidgetState extends State<AddIngredienteWidget> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _addIngrediente();
  }

  void _addIngrediente() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeIngrediente(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredientes'),
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
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _removeIngrediente(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.green),
              label: const Text('Adicionar ingrediente'),
              onPressed: _addIngrediente,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.white, 
                side: const BorderSide(color: Colors.green), // Borda
              ),
            ),
          ],
        ),
      ),
    );
  }
}
