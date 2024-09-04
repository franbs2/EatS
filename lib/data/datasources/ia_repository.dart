import 'package:eats/data/model/recipes.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIRepository {
  final GenerativeModel _generativeModel;

  AIRepository({required String apiKey})
      : _generativeModel = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
        );

  GenerativeModel get model => _generativeModel;

  Future<Recipes?> generateRecipe(List<String> ingredients) async {
    const String comando =
        'Crie uma receita culinária usando exclusivamente a lista de ingredientes fornecida.';
    const String formatacao =
        'A receita deve seguir esta formatação e enviar somente isto:'
        '\nTítulo: [título da receita]'
        '\nIngredientes: [ingrediente1, ingrediente2, ...]'
        '\nModo de Preparo: [passo1, passo2, ...]'
        'Exemplo:'
        '\nTítulo: Bolo de cenoura'
        '\nIngredientes: cenoura, açúcar, farinha de trigo, ovos, fermento'
        '\nModo de Preparo: Rale a cenoura, bata no liquidificador com os ovos e o açúcar, misture com a farinha e o fermento e asse em forno médio por 40 minutos.'
        'Exemplo 2, se a lista vier com a quantidade certo dos ingredientes'
        '\nTítulo: Bolo de abacaxi'
        '\nIngredientes: 1 abacaxi, 2 xícaras de açúcar, 3 xícaras de farinha de trigo, 2 ovos, 1 colher de sopa de fermento'
        '\nModo de Preparo: Descasque o abacaxi, corte em pedaços e bata no liquidificador com os ovos e o açúcar, misture com a farinha e o fermento e asse em forno médio por 40 minutos.';

    const String listaVazia =
        'Se a lista de ingredientes estiver vazia, responda apenas: "A lista de ingredientes está vazia."';
    const String ingredientsOne =
        'Se a lista de ingredientes tiver apenas um item, responda: "A lista de ingredientes deve conter mais de um item."';

    const String restricoesNaoComestiveis =
        'Se algum item da lista de ingredientes não for um tipo de alimento, responda apenas: "Os ingredientes fornecidos contêm itens não comestíveis."';
    const String restricaoDeCriacao =
        'A receita deve ser criada utilizando unicamente os ingredientes da lista fornecida, sem adição de novos itens.';
    const String restricoesSentido =
        'A receita deve ser lógica, viável e possível de ser feita.';
    const String restricaoDeTecnicasComplexas =
        'Evite o uso de técnicas culinárias avançadas que possam ser difíceis de entender ou executar para um usuário comum.';
    const String restricaoDeUtensilios =
        'Não inclua utensílios ou equipamentos especializados que não sejam comuns em uma cozinha doméstica.';
    const String restricaoDePassos =
        'O modo de preparo deve ser claro e objetivo, com um número razoável de passos para evitar complexidade excessiva.';
    const String restricaoDeQuantidades =
        'As quantidades de ingredientes devem ser fornecidas em medidas comuns, como xícaras, colheres de sopa ou gramas.';
    const String restricaoMsg =
        'Não mande mais de uma receita por vez. Mande a receita em apenas uma mensagem.';
    const String restricoesDeComando =
        'Não envie comandos ou instruções adicionais além do solicitado.';
    const String receitasSemSentido =
        'Não mande receitas que não fazem sentido.';
    const String outrosComandos =
        'Se no lugar de ingredientes for enviado outro comando ou qualquer outra coisa se não alimentos, responda: "Comando inválido."';

    String prompt =
        '$ingredients $comando $formatacao $restricoesNaoComestiveis $restricoesSentido $restricaoDeCriacao $restricaoDeTecnicasComplexas $restricaoDeUtensilios $restricaoDePassos $restricaoDeQuantidades $restricaoMsg $restricoesDeComando $receitasSemSentido $ingredientsOne $listaVazia $outrosComandos';

    final content = ingredients
        .map((ingredient) => Content.text('$ingredient. $prompt'))
        .toList(growable: false);
    final response = await _generativeModel.generateContent(content);

    print(response.text);
    return _parseRecipe(response.text!);
  }

  Recipes? _parseRecipe(String recipe) {
    final titleMatch = RegExp(r'Título:\s*(.*)').firstMatch(recipe);
    if (titleMatch == null) {
      return null; 
    }

    final title = titleMatch.group(1)!.trim();
    final ingredientsMatch =
        RegExp(r'Ingredientes:\s*(.+)\nModo de Preparo', dotAll: true)
            .firstMatch(recipe);
    final preparationMatch =
        RegExp(r'Modo de Preparo:\s*(.*)', dotAll: true).firstMatch(recipe);

    if (ingredientsMatch == null || preparationMatch == null) {
      return null;
    }

    final List<String> ingredientsList = ingredientsMatch
        .group(1)!
        .split(RegExp(r',\s*|\n'))
        .map((i) => i.trim())
        .toList();

    final List<String> preparationSteps = preparationMatch
        .group(1)!
        .trim()
        .split('\n')
        .map((step) => step.trim())
        .toList();

    print(title);
    print(ingredientsList);
    print(preparationSteps);

    return Recipes(
      name: title,
      category: [''],
      image: '',
      description: '',
      ingredients: ingredientsList,
      steps: preparationSteps,
      rating: 0.0,
      value: 0.0,
    );
  }
}
