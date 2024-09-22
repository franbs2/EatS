import 'package:flutter/material.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Última atualização: 23 de setembro de 2024',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text(
                '1. Aceitação dos Termos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Ao utilizar o Eats, você concorda com estes Termos de Uso. Se você não concorda com estes termos, não utilize o aplicativo.',
              ),
              SizedBox(height: 20),
              Text(
                '2. Coleta de Informações',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Para utilizar o Eats, coletamos as seguintes informações:\n- Nome\n- Email\n- Ingredientes adicionados pelo usuário\n'
                'Essas informações são necessárias para personalizar a sua experiência e sugerir receitas adequadas aos ingredientes que você fornece.',
              ),
              SizedBox(height: 20),
              Text(
                '3. Uso das Informações',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'As informações coletadas são utilizadas para:\n- Criar e manter sua conta.\n- Sugerir receitas personalizadas com base nos ingredientes fornecidos.\n'
                '- Permitir que você salve receitas no aplicativo.',
              ),
              SizedBox(height: 20),
              Text(
                '4. Propriedade Intelectual',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Todo o conteúdo disponível no Eats, incluindo receitas, textos, gráficos e logos, é de propriedade do Eats ou de seus licenciantes e está protegido por direitos autorais e outras leis de propriedade intelectual.',
              ),
              SizedBox(height: 20),
              Text(
                '5. Responsabilidades do Usuário',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Você se compromete a:\n- Fornecer informações precisas e completas.\n- Não usar o aplicativo para fins ilegais ou não autorizados.\n'
                '- Respeitar os direitos de propriedade intelectual do Eats e de terceiros.',
              ),
              SizedBox(height: 20),
              Text(
                '6. Limitação de Responsabilidade',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'O Eats não se responsabiliza por danos diretos, indiretos ou consequenciais resultantes do uso ou incapacidade de uso do aplicativo. As receitas geradas são sugestões e devem ser testadas com cautela.',
              ),
              SizedBox(height: 20),
              Text(
                '7. Modificações dos Termos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'O Eats se reserva o direito de modificar estes Termos de Uso a qualquer momento. Alterações serão comunicadas por meio do aplicativo. O uso contínuo do aplicativo após a modificação constitui aceitação dos novos termos.',
              ),
              SizedBox(height: 20),
              Text(
                '8. Contato',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Se você tiver dúvidas sobre estes Termos de Uso, entre em contato conosco pelo email: eats.g4@gmail.com',
              ),
              SizedBox(height: 20),
              Text(
                'Obrigado por utilizar o Eats!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
