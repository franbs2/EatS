// Importações necessárias para o provedor de banners,
// incluindo o repositório de banners e o modelo de banners.
import 'package:eats/data/datasources/banners_repository.dart';
import 'package:eats/data/model/banners.dart';
import 'package:flutter/material.dart';

/// `BannersProvider` gerencia o estado dos banners no aplicativo,
/// incluindo a busca, atualização e exibição dos banners.
class BannersProvider extends ChangeNotifier {
  late BannersRepository
      _bannerRepository; // Repositório responsável por buscar os banners.
  List<Banners> _banners = []; // Lista de banners carregados.
  bool _isLoading =
      false; // Indica se a operação de carregamento está em andamento.
  String?
      _errorMessage; // Mensagem de erro, caso ocorra algum problema ao carregar os banners.

  /// Construtor que inicializa o `BannersProvider` com um `BannersRepository`.
  BannersProvider(BannersRepository bannerRepository) {
    _bannerRepository = bannerRepository;
  }

  /// Atualiza o repositório de banners e notifica os ouvintes.
  void updateRepository(BannersRepository bannerRepository) {
    _bannerRepository = bannerRepository;
    notifyListeners();
  }

  // Getters para expor os banners, o estado de carregamento e a mensagem de erro à interface de usuário.
  List<Banners> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Método para buscar os banners do repositório.
  /// Atualiza o estado de carregamento e trata possíveis erros durante o processo.
  Future<void> fetchBanners() async {
    _isLoading = true;
    notifyListeners();

    try {
      _banners = await _bannerRepository.getBanners();
      _errorMessage = null; // Zera a mensagem de erro em caso de sucesso.
    } catch (error) {
      _errorMessage =
          'Falha ao carregar banners: $error'; // Define a mensagem de erro em caso de falha.
    } finally {
      _isLoading = false; // Finaliza o estado de carregamento.
      notifyListeners();
    }
  }
}
