import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eats/presentation/providers/banners_provider.dart';
import 'package:eats/presentation/providers/recipes_provider.dart';

import '../../core/routes/routes.dart';
import '../../core/style/color.dart';
import '../../core/style/images_app.dart';
import 'view/home_page.dart';
import 'view/perfil_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Lista de páginas para alternar
  final List<Widget> _pages = [
    const HomePage(),
    const PerfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesApp.generateRecipePage);
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        backgroundColor: Colors.white,
        child: Image.asset(
          ImageApp.appMiniIcon,
          height: 35,
        ),
      ),
    );
  }
}
