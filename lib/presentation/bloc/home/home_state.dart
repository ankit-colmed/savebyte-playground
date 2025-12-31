import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeLoadedState extends HomeState {
  final List<dynamic> items;

  const HomeLoadedState({required this.items});

  @override
  List<Object?> get props => [items];
}

class HomeErrorState extends HomeState {
  final String message;

  const HomeErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
