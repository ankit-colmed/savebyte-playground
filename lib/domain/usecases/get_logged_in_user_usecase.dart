import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetLoggedInUserUseCase {
  final AuthRepository repository;

  GetLoggedInUserUseCase({required this.repository});

  Future<User?> call() async {
    return await repository.getLoggedInUser();
  }
}