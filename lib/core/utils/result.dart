import 'package:equatable/equatable.dart';

abstract class Result<T> extends Equatable {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;

  const Success({required this.data});

  @override
  List<Object?> get props => [data];
}

class Failure<T> extends Result<T> {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.error,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, error, stackTrace];
}