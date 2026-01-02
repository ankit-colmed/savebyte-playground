import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<String> _searchHistory = [];
  List<String> _searchResults = [];

  SearchBloc() : super(const SearchInitialState()) {
    on<SearchInitEvent>(_onInitEvent);
    on<SearchQueryEvent>(_onSearchQueryEvent);
    on<SearchClearEvent>(_onClearEvent);
    on<SearchHistoryEvent>(_onHistoryEvent);
    on<DeleteSearchHistoryEvent>(_onDeleteHistoryEvent);
  }

  Future<void> _onInitEvent(
      SearchInitEvent event,
      Emitter<SearchState> emit,
      ) async {
    emit(const SearchLoadingState());
    try {
      // Load search history from local storage
      await Future.delayed(const Duration(milliseconds: 500));
      _searchHistory = ['Flutter', 'Dart', 'Clean Architecture', 'BLoC'];
      emit(SearchEmptyState(history: _searchHistory));
    } catch (e) {
      emit(SearchErrorState(message: e.toString()));
    }
  }

  Future<void> _onSearchQueryEvent(
      SearchQueryEvent event,
      Emitter<SearchState> emit,
      ) async {
    if (event.query.trim().isEmpty) {
      emit(SearchEmptyState(history: _searchHistory));
      return;
    }

    emit(const SearchLoadingState());
    try {
      // Simulate API call to search
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock search results
      _searchResults = _mockSearchResults(event.query);

      // Add to history if not already present
      if (!_searchHistory.contains(event.query)) {
        _searchHistory.insert(0, event.query);
        if (_searchHistory.length > 10) {
          _searchHistory.removeLast();
        }
      }

      if (_searchResults.isEmpty) {
        emit(SearchEmptyState(history: _searchHistory));
      } else {
        emit(SearchLoadedState(
          results: _searchResults,
          history: _searchHistory,
        ));
      }
    } catch (e) {
      emit(SearchErrorState(message: 'Search failed: ${e.toString()}'));
    }
  }

  Future<void> _onClearEvent(
      SearchClearEvent event,
      Emitter<SearchState> emit,
      ) async {
    _searchResults.clear();
    emit(SearchEmptyState(history: _searchHistory));
  }

  Future<void> _onHistoryEvent(
      SearchHistoryEvent event,
      Emitter<SearchState> emit,
      ) async {
    emit(SearchHistoryLoadedState(history: _searchHistory));
  }

  Future<void> _onDeleteHistoryEvent(
      DeleteSearchHistoryEvent event,
      Emitter<SearchState> emit,
      ) async {
    _searchHistory.removeWhere((item) => item == event.query);
    if (state is SearchLoadedState) {
      emit(SearchLoadedState(
        results: _searchResults,
        history: _searchHistory,
      ));
    } else {
      emit(SearchEmptyState(history: _searchHistory));
    }
  }

  /// Mock search results based on query
  List<String> _mockSearchResults(String query) {
    final allItems = [
      'Flutter Tutorial',
      'Flutter Best Practices',
      'Flutter Performance',
      'Flutter Widgets',
      'Flutter State Management',
      'Flutter Navigation',
      'Dart Language Guide',
      'Dart Collections',
      'Clean Architecture',
      'SOLID Principles',
      'Design Patterns',
      'BLoC Pattern',
      'Riverpod',
      'Provider',
    ];

    return allItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}