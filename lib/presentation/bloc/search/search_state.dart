import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {
  const SearchInitialState();
}

class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

class SearchLoadedState extends SearchState {
  final List<String> results;
  final List<String> history;

  const SearchLoadedState({
    required this.results,
    required this.history,
  });

  @override
  List<Object?> get props => [results, history];
}

class SearchEmptyState extends SearchState {
  final List<String> history;

  const SearchEmptyState({required this.history});

  @override
  List<Object?> get props => [history];
}

class SearchErrorState extends SearchState {
  final String message;

  const SearchErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SearchHistoryLoadedState extends SearchState {
  final List<String> history;

  const SearchHistoryLoadedState({required this.history});

  @override
  List<Object?> get props => [history];
}