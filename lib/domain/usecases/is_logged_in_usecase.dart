import '../repositories/auth_repository.dart';

class IsLoggedInUseCase {
  final AuthRepository repository;

  IsLoggedInUseCase({required this.repository});

  Future<bool> call() async {
    return await repository.isLoggedIn();
  }
}