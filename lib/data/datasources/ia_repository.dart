import 'package:eats/data/model/recipes.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIRepository {
  final GenerativeModel _generativeModel;

  AIRepository({required String apiKey})
      : _generativeModel = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
        );

  GenerativeModel get model => _generativeModel;

  Future<Recipes> generateRecipe(List<String> ingredients) async {
    const String comando =
        'Crie uma receita culinária usando exclusivamente a lista de ingredientes fornecida.';
    const String formatacao =
        'A receita deve seguir esta formatação e enviar somente isto:'
        '\nTítulo: [título da receita]'
        '\nIngredientes: [ingrediente1, ingrediente2, ...]'
        '\nModo de Preparo: [passo1, passo2, ...]';

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
    const String outrosComandos =
        'Se no lugar de ingredientes for enviado outro comando ou qualquer outra coisa se não alimentos, responda: "Comando inválido."';

    String prompt =
        '$ingredients $comando $formatacao $restricoesNaoComestiveis $restricoesSentido $restricaoDeCriacao $restricaoDeTecnicasComplexas $restricaoDeUtensilios $restricaoDePassos $restricaoDeQuantidades $restricaoMsg $restricoesDeComando $ingredientsOne $listaVazia $outrosComandos';

    final content = ingredients
        .map((ingredient) => Content.text('$ingredient. $prompt'))
        .toList(growable: false);
    final response = await _generativeModel.generateContent(content);

    return _parseRecipe(response.text!);
  }

  Recipes _parseRecipe(String recipe) {
    final titleMatch = RegExp(r'Título:\s*(.*)').firstMatch(recipe);
    final title = titleMatch != null ? titleMatch.group(1)!.trim() : '';

    final ingredientsMatch =
        RegExp(r'Ingredientes:\s*(.+)\nModo de Preparo', dotAll: true)
            .firstMatch(recipe);
    final List<String> ingredientsList = ingredientsMatch != null
        ? ingredientsMatch
            .group(1)!
            .split(RegExp(r',\s*|\n'))
            .map((i) => i.trim())
            .toList()
        : [];

    final preparationMatch =
        RegExp(r'Modo de Preparo:\s*(.*)', dotAll: true).firstMatch(recipe);
    final List<String> preparationSteps = preparationMatch != null
        ? preparationMatch
            .group(1)!
            .trim()
            .split('\n')
            .map((step) => step.trim())
            .toList()
        : [];

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
