import 'package:flutter/material.dart';
import 'package:guia_restaurantes/viewmodels/sign_up_viewmodel.dart';

/// Tela visual de cadastro de usuário.
class SignUpPage extends StatefulWidget {
  // Cor vermelha inspirada no iFood usada como identidade visual da página.
  static const _ifoodRed = Color(0xFFEA1D2C);

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Instância da lógica de validação que criamos na ViewModel.
  final _viewModel = SignUpViewModel();

  // Controladores para capturar e ler o texto digitado em cada campo.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Estados locais da tela:
  bool _obscurePassword = true; // Controla se a senha está oculta ou visível.
  bool _acceptedTerms = false;  // Controla se o checkbox de termos foi marcado.
  bool _isLoading = false;      // Controla o estado de carregamento do botão.

  // Chave global usada para identificar, validar e salvar o formulário inteiro.
  final _formKey = GlobalKey<FormState>();

  /// Descarte de memória: limpa os controladores quando a tela for fechada.
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Criar conta'),
      ),
      body: SafeArea(
        // SingleChildScrollView evita que o teclado cubra os campos ou cause overflow na tela.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          // O widget Form gerencia o estado de validação de todos os TextFormFields filhos.
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),

                // Campo Nome
                _buildField(
                  label: 'Nome completo',
                  icon: Icons.person_outline,
                  controller: _nameController,
                  validator: _viewModel.validateName,
                ),
                const SizedBox(height: 16),

                // Campo E-mail
                _buildField(
                  label: 'E-mail',
                  icon: Icons.mail_outline,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _viewModel.validateEmail,
                ),
                const SizedBox(height: 16),

                // Campo Celular
                _buildField(
                  label: 'Celular',
                  icon: Icons.phone_outlined,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: _viewModel.validatePhone,
                ),
                const SizedBox(height: 16),

                // Campo Senha (com botão de alternar visibilidade)
                _buildField(
                  label: 'Senha',
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  validator: _viewModel.validatePassword,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Alterna a visibilidade da senha e atualiza a tela
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo Confirmar Senha
                _buildField(
                  label: 'Confirmar senha',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  controller: _confirmPasswordController,
                  validator: (value) =>
                      _viewModel.validatePasswordConfirmation(
                        value,
                        _passwordController.text,
                      ),
                ),
                const SizedBox(height: 8),

                // Checkbox de Termos de Uso
                _buildTermsCheckBox(),
                const SizedBox(height: 16),

                // Botão principal de envio
                _buildSubmitButton(),

                // Link para voltar à tela de Login
                _buildLoginLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói o cabeçalho com título e subtítulo de boas-vindas.
  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Falta pouco para matar a sua fome!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Text(
          'Preencha os seus dados para criar a sua conta.',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  /// Método reutilizável para criar campos de texto padronizados (`TextFormField`).
  Widget _buildField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextEditingController? controller,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: SignUpPage._ifoodRed, width: 2),
        ),
        floatingLabelStyle: const TextStyle(color: SignUpPage._ifoodRed),
      ),
    );
  }

  /// Processa a submissão do formulário.
  Future<void> _submit() async {
    // 1. valida os campos do formulário
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    // 2. confere se aceitou os termos
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aceite os termos de uso para continuar')),
      );
      return;
    }

    // 3. liga o indicador de carregamento
    setState(() {
      _isLoading = true;
    });

    // 4. pede o cadastro ao ViewModel e ESPERA a resposta
    final error = await _viewModel.register(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
    );

    // 5. se a tela foi fechada durante a espera, o método para aqui
    if (!mounted) return;

    // 6. desliga o carregamento
    setState(() {
      _isLoading = false;
    });

    // 7. se veio uma mensagem, houve erro: mostra e para
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    // 8. deu certo: avisa e volta para a tela de Perfil
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conta criada! Boas-vindas, ${_nameController.text.trim()}.'),
      ),
    );
    Navigator.pop(context);
  }

  /// Constrói o botão de acionamento do cadastro.
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: SignUpPage._ifoodRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Text(
        'Criar conta',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Constrói a caixa de seleção (Checkbox) dos termos e condições.
  Widget _buildTermsCheckBox() {
    return CheckboxListTile(
      value: _acceptedTerms,
      onChanged: (value) {
        setState(() {
          _acceptedTerms = value ?? false;
        });
      },
      activeColor: SignUpPage._ifoodRed,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text(
        'Li e aceito os termos de uso e a política de privacidade',
      ),
    );
  }

  /// Constrói o botão "Já tenho conta" para retornar à tela anterior.
  Widget _buildLoginLink(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(foregroundColor: SignUpPage._ifoodRed),
      child: const Text('Já tenho conta'),
    );
  }
}