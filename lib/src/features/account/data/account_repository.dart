import '../domain/user.dart';

abstract class AccountRepository {
  Future<UserModel?> getCurrentUser();
}
