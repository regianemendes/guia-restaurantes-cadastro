import 'package:guia_restaurantes/models/user.dart';
import 'package:guia_restaurantes/data/service/user_service.dart';

class UserRepository {

  final UserService _service = UserService();

  Future<void> createUser(User user) async {
    await _service.postUser(user);
  }
}
