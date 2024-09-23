import 'package:flutter/material.dart';

/// [PreferenceOptionsWidget] é um widget que exibe uma opção de preferência em um layout de botão.
/// Este widget mostra um título e um ícone de seta apontando para a direita, indicando uma ação possível.
///
/// - Parâmetros:
///   - [title] ([String]): O título que será exibido pelo widget, indicando a opção de preferência.
///   - [onTap] ([VoidCallback]): A função de callback que será chamada quando o usuário clicar na opção.
///
/// - Funcionamento:
///   - Quando o widget é clicado, o método [onTap] é chamado, permitindo definir ações personalizadas.
///   - O widget é estilizado com um contêiner que possui bordas arredondadas e sombra para dar um efeito de botão elevado.
///   - Exibe o título da opção e um texto adicional "Adicionar" junto com um ícone de seta para a direita, estilizados para parecerem desativados.
///
/// Referências:
/// - [VoidCallback]: Função de callback que é acionada ao clicar no widget.
/// - [StringsApp]: Classe que contém as strings usadas na aplicação.
/// - [ImageApp]: Classe que contém as imagens usadas na aplicação.

class PreferenceOptionsWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  /// Construtor do widget que exige um título e uma função de callback.
  const PreferenceOptionsWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Define o comportamento ao clicar no widget.
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              // Exibe o texto adicional e o ícone de seta.
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
