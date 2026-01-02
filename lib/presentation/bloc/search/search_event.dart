import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchInitEvent extends SearchEvent {
  const SearchInitEvent();
}

class SearchQueryEvent extends SearchEvent {
  final String query;

  const SearchQueryEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class SearchClearEvent extends SearchEvent {
  const SearchClearEvent();
}

class SearchHistoryEvent extends SearchEvent {
  const SearchHistoryEvent();
}

class DeleteSearchHistoryEvent extends SearchEvent {
  final String query;

  const DeleteSearchHistoryEvent({required this.query});

  @override
  List<Object?> get props => [query];
}