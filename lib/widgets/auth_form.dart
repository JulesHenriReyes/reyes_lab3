import 'package:flutter/material.dart';

import 'auth_fields.dart';

/// The login/registration form layout. Stateless: all state and logic live in
/// the parent screen and are passed in through the constructor.
class AuthForm extends StatelessWidget {
  const AuthForm({
    super.key,
    required this.formKey,
    required this.isLogin,
    required this.hidePassword,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onToggleVisibility,
    required this.onSubmit,
    required this.onSwitchForm,
  });

  final GlobalKey<FormState> formKey;
  final bool isLogin;
  final bool hidePassword;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onToggleVisibility;
  final VoidCallback onSubmit;
  final VoidCallback onSwitchForm;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isLogin ? 'Login' : 'Create Account',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          // Display the name field during registration.
          if (!isLogin) ...[
            NameField(controller: nameController),
            const SizedBox(height: 16),
          ],
          EmailField(controller: emailController),
          const SizedBox(height: 16),
          PasswordField(
            controller: passwordController,
            hidePassword: hidePassword,
            onToggleVisibility: onToggleVisibility,
          ),
          const SizedBox(height: 16),
          // Display confirmation during registration.
          if (!isLogin) ...[
            ConfirmPasswordField(
              controller: confirmPasswordController,
              passwordController: passwordController,
              hidePassword: hidePassword,
            ),
            const SizedBox(height: 16),
          ],
          ElevatedButton(
            onPressed: onSubmit,
            child: Text(isLogin ? 'Login' : 'Register'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onSwitchForm,
            child: Text(
              isLogin
                  ? 'No account yet? Register'
                  : 'Already have an account? Login',
            ),
          ),
        ],
      ),
    );
  }
}
