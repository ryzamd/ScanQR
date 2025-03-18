import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/core/constants/button_name.dart';
import 'package:scan_qr/core/constants/string_contants.dart';
import 'package:scan_qr/presentation/blocs/auth/auth_bloc.dart';
import 'package:scan_qr/presentation/blocs/auth/auth_event.dart';
import 'package:scan_qr/presentation/blocs/auth/auth_state.dart';
import 'package:scan_qr/presentation/routes/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

     double heightTest = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
     double widthTest = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, AppRouter.dashboard);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF58A8C6),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: heightTest,
                width: widthTest,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            ImageConstant.logoImage,
                            width: 130,
                            height: 130,
                          ),
                        ),
                        Image.asset(
                          ImageConstant.titleImage,
                          width: 250,
                          height: 30,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 360,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _usernameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: StringKey.userNameLoginTitle,
                                      hintStyle: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.7),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withValues(alpha: 0.1),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: StringKey.passwordLoginTitle,
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.white70,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.1),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: const Size(0, 30),
                                      ),
                                      child: Text(
                                        ButtonNameConstant.forgotPasswordButton,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      return ElevatedButton(
                                        onPressed: state is AuthLoading
                                            ? null
                                            : () {
                                                if (_formKey.currentState!.validate()) {
                                                  context.read<AuthBloc>().add(
                                                    LoginRequested(
                                                      username: _usernameController.text,
                                                      password: _passwordController.text,
                                                    ),
                                                  );
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: const Color(0xFF58A8C6),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          minimumSize: const Size(double.infinity, 50),
                                          elevation: 2,
                                        ),
                                        child: state is AuthLoading
                                            ? const CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58A8C6)),
                                              )
                                            : Text(
                                                ButtonNameConstant.loginButton,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 150,
                                    height: 30,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        debugPrint('Can pop: ${Navigator.canPop(context)}');
                                        Navigator.pushNamed(context, AppRouter.register);
                                      }, 
                                      child: const Text("Register")
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        '© 2025 ScanQR. All rights reserved',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}