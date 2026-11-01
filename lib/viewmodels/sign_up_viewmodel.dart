import 'package:guia_restaurantes/models/user.dart';
import 'package:guia_restaurantes/data/repositories/user_repository.dart';
import 'package:guia_restaurantes/data/network/requester.dart';

class SignUpViewModel {

  final UserRepository _repository = UserRepository();

  // Valida nome: não pode ser vazio e precisa ter pelo menos 3 letras.
  String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Informe seu nome';
    if (name.length < 3) return 'O nome deve ter pelo menos 3 letras';
    return null;
  }

  // Valida e-mail: verifica se está vazio e se segue o formato padrão (ex@domínio.com).
  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Informe o seu e-mail';

    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
    if (!emailRegex.hasMatch(email)) return 'E-mail inválido';
    return null;
  }

  // Valida celular: remove símbolos e exige exatamente 11 dígitos (DDD + 9 números).
  String? validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'Informe o seu celular';
    if (digits.length != 11) return 'Informe o DDD e os 9 dígitos do celular';
    return null;
  }

  // Valida senha: não pode ser vazia e exige no mínimo 6 caracteres.
  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Crie uma senha';
    if (password.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    return null;
  }

  // Valida confirmação: verifica se foi preenchido e se é idêntico à senha digitada.
  String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirme a sua senha';
    if (value != password) return 'As senhas não conferem';
    return null;
  }

  Future<String?> register({
    required String name,
    required String email,
    required String phone,
    required String password }) async {

    // monta o usuário com os dados que a View entregou
    final user = User(
        name: name,
        email: email,
        phone: phone,
        password: password);

    try {
      await _repository.createUser(user);
      return null;                          // deu certo
    } on RequestException catch (e) {
      return e.message;                     // a mensagem que o Requester montou
    } catch (_) {
      return 'Não foi possível criar a conta. Tente novamente.';
    }
  }
}