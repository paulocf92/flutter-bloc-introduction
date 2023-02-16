import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_introduction/pages/state_single_class/home_state.dart';
import 'package:flutter_bloc_introduction/repositories/cep_repository.dart';
import 'package:flutter_bloc_introduction/repositories/cep_repository_impl.dart';

class HomeSingleClassController extends Cubit<HomeState> {
  final CepRepository cepRepository = CepRepositoryImpl();

  HomeSingleClassController() : super(HomeState());

  Future<void> findCep(String cep) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final enderecoModel = await cepRepository.getCep(cep);
      emit(state.copyWith(
          enderecoModel: enderecoModel, status: HomeStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
