import 'package:flutter/material.dart';

import '../../core/routes/routes.dart';
import '../../core/style/color.dart';
import '../../core/style/images_app.dart';
import 'view/home_page.dart';
import 'view/my_recipes_page.dart';

/// [MainScreen] é um widget Stateful que serve como a tela principal do aplicativo.
/// Ele gerencia a navegação entre a página inicial e a página de perfil usando
/// um [BottomNavigationBar] e um [FloatingActionButton] para acessar uma página adicional.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key}); // Construtor do widget com chave opcional.

  @override
  State<MainScreen> createState() =>
      _MainScreenState(); // Cria o estado do widget.
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Índice da página selecionada na navegação inferior.

  // Lista de páginas para alternar na tela principal.
  final List<Widget> _pages = [
    const HomePage(), // Página inicial.
    MyRecipesPage(), 
  ];

  /// Atualiza o índice da página selecionada quando um item do BottomNavigationBar é tocado.
  ///
  /// @param [index] - O índice do item selecionado no BottomNavigationBar.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o índice da página selecionada.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [IndexedStack] exibe uma única página por vez com base no índice selecionado.
      // Utiliza a lista de páginas [_pages] para mostrar o conteúdo correspondente.

      body: IndexedStack(
        index: _selectedIndex, // Índice da página atual a ser exibida.
        children: _pages, // Lista de páginas a serem exibidas.
      ),

      // [BottomNavigationBar] permite a navegação entre as páginas principais.
      // Personaliza o estilo e comportamento do menu de navegação.

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Define o item atualmente selecionado.
        onTap: _onItemTapped, // Função chamada quando um item é tocado.
        backgroundColor:
            AppTheme.secondaryColor, // Cor de fundo do BottomNavigationBar.
        selectedItemColor: AppTheme.primaryColor, // Cor do item selecionado.
        unselectedItemColor: Colors.grey, // Cor dos itens não selecionados.
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Ícone para a página inicial.
            label: 'Início', // Rótulo para a página inicial.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt), // Ícone para a página de perfil.
            label: 'Minhas', // Rótulo para a página de perfil.
          ),
        ],
      ),

      //
      // [FloatingActionButton] é um botão flutuante centralizado na tela.
      // Navega para a página de geração de receita quando pressionado.

      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, // Localização do botão flutuante.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
              context,
              RoutesApp
                  .generateRecipePage); // Navega para a página de geração de receita.
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(50)), // Forma arredondada do botão.
        ),
        backgroundColor:
            AppTheme.secondaryColor, // Cor de fundo do botão flutuante.
        child: Image.asset(
          ImageApp.appMiniIcon, // Imagem exibida no botão flutuante.
          height: 35, // Altura da imagem do botão.
        ),
      ),
    );
  }
}
