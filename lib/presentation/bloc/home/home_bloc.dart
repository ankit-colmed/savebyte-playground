import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitialState()) {
    on<HomeInitEvent>(_onInitEvent);
    on<HomeRefreshEvent>(_onRefreshEvent);
  }

  Future<void> _onInitEvent(
      HomeInitEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(const HomeLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const HomeLoadedState(items: []));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  Future<void> _onRefreshEvent(
      HomeRefreshEvent event,
      Emitter<HomeState> emit,
      ) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const HomeLoadedState(items: []));
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }
}