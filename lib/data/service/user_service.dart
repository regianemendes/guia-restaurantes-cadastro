import 'package:guia_restaurantes/models/user.dart';
import 'package:guia_restaurantes/data/network/requester.dart';

class UserService {

  final Requester _requester = Requester();

  Future<void> postUser(User user) async {
    await _requester.post('/api/v1/auth/register', user.toJson());
  }
}