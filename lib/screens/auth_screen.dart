import 'package:flutter/material.dart';

import '../models/user_account.dart';
import '../widgets/auth_form.dart';
import 'welcome_screen.dart';

/// Owns the form state, controllers, and login/register logic.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // TODO: replace with your own name and section.
  static const String _appName = 'Campus Access';
  static const String _studentInfo = 'Juan Dela Cruz  |  Section BSIT-1A';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLogin = true;
  bool _hidePassword = true;

  // Temporary storage: lives only in memory, so it resets on app restart.
  UserAccount? _registeredUser;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _switchForm() {
    setState(() {
      _isLogin = !_isLogin;
      _hidePassword = true;
    });
    _formKey.currentState?.reset();
    _clearFields();
  }

  void _toggleVisibility() => setState(() => _hidePassword = !_hidePassword);

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    _isLogin ? _login() : _register();
  }

  void _register() {
    _registeredUser = UserAccount(
      name: _nameController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      password: _passwordController.text,
    );
    _showMessage('Registration successful! Please log in.');
    _switchForm();
  }

  void _login() {
    final user = _registeredUser;
    if (user == null) {
      _showMessage('Please register an account first.');
      return;
    }

    final email = _emailController.text.trim().toLowerCase();
    if (email != user.email || _passwordController.text != user.password) {
      _showMessage('Incorrect email or password.');
      return;
    }

    _clearFields();
    _formKey.currentState?.reset();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WelcomeScreen(
          userName: user.name,
          onLogout: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AuthForm(
                    formKey: _formKey,
                    isLogin: _isLogin,
                    hidePassword: _hidePassword,
                    nameController: _nameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    onToggleVisibility: _toggleVisibility,
                    onSubmit: _submitForm,
                    onSwitchForm: _switchForm,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _studentInfo,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
