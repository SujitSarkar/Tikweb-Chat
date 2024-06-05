import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/home_service.dart';

abstract class HomeState {}

class InitialState extends HomeState {}

class LoadingState extends HomeState {}

final homeProvider = StateNotifierProvider<HomeController, HomeState>(
    (ref) => HomeController(HomeService()));

class HomeController extends StateNotifier<HomeState> {
  HomeController(this._homeService) : super(InitialState());
  final HomeService _homeService;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserStream() {
    return _homeService.getUserStream();
  }
}
