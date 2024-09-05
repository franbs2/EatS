import 'package:eats/data/datasources/banners_repository.dart';
import 'package:eats/data/model/banners.dart';
import 'package:flutter/material.dart';

class BannersProvider extends ChangeNotifier {
  late BannersRepository _bannerRepository;
  List<Banners> _banners = [];
  bool _isLoading = false;
  String? _errorMessage;

  BannersProvider(BannersRepository bannerRepository) {
    _bannerRepository = bannerRepository;
  }

//metodo para atualizar o repositório
  void updateRepository(BannersRepository bannerRepository) {
    _bannerRepository = bannerRepository;
    notifyListeners();
  }

//getters
  List<Banners> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

//método para buscar os banners
  Future<void> fetchBanners() async {
    _isLoading = true;
    notifyListeners();

    try {
      _banners = await _bannerRepository.getBanners();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Falha ao carregar banners: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
