import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeInitEvent extends HomeEvent {
  const HomeInitEvent();
}

class HomeRefreshEvent extends HomeEvent {
  const HomeRefreshEvent();
}