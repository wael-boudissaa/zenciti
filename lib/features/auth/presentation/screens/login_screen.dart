import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/domain/usecase/register_use_case.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/login_event.dart';
import 'package:zenciti/features/auth/presentation/screens/sign_up.dart';
import 'package:zenciti/features/auth/presentation/screens/sign_up_presentation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    // Main color variables for easy access
    final Color primary = AppColors.greenPrimary;
    final Color borderGray = const Color(0xFFD1D5DB);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.go('/home');
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
                child: Column(
                  children: [
                    // Header
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          "Welcome back",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Sign in to your Zenciti account",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),

                    // Form
                    Padding(
                      padding: const EdgeInsets.only(top: 34, bottom: 12),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Email",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 5),
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Positioned(
                                      left: 15,
                                      child: Icon(Icons.email_outlined,
                                          color: Colors.grey[400], size: 22),
                                    ),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: "Enter your email",
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 17, horizontal: 44),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide:
                                              BorderSide(color: borderGray),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: primary, width: 2),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Password field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Password",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          fontSize: 14),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Implement forgot password navigation
                                      },
                                      child: Text(
                                        "Forgot password?",
                                        style: TextStyle(
                                            color: primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Positioned(
                                      left: 15,
                                      child: Icon(Icons.lock_outline,
                                          color: Colors.grey[400], size: 22),
                                    ),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: !passwordVisible,
                                      decoration: InputDecoration(
                                        hintText: "Enter your password",
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 17, horizontal: 44),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide:
                                              BorderSide(color: borderGray),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: primary, width: 2),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey[400],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Remember me
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (v) =>
                                      setState(() => rememberMe = v ?? false),
                                  activeColor: primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const Text(
                                  "Remember me",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            // Sign in button
                            const SizedBox(height: 4),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                  elevation: 2,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginBloc>().add(
                                          LoginSubmitted(
                                            email: _emailController.text.trim(),
                                            password:
                                                _passwordController.text.trim(),
                                          ),
                                        );
                                  }
                                },
                                child: const Text("Sign in"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Row(
                        children: [
                          const Expanded(
                              child: Divider(
                                  thickness: 1, color: Color(0xFFD1D5DB))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "or continue with",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          const Expanded(
                              child: Divider(
                                  thickness: 1, color: Color(0xFFD1D5DB))),
                        ],
                      ),
                    ),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _SocialButton(
                          icon: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/4/4a/Logo_2013_Google.png',
                            width: 20,
                            height: 20,
                          ),
                          label: "Google",
                          onTap: () {/* Google sign-in */},
                        ),
                        _SocialButton(
                          icon: const Icon(Icons.apple,
                              color: Colors.black, size: 22),
                          label: "Apple",
                          onTap: () {/* Apple sign-in */},
                        ),
                        _SocialButton(
                          icon: const Icon(Icons.facebook,
                              color: Color(0xFF1877F3), size: 22),
                          label: "Facebook",
                          onTap: () {/* Facebook sign-in */},
                        ),
                        _SocialButton(
                          icon: const Icon(Icons.alternate_email,
                              color: Color(0xFF1DA1F2), size: 22),
                          label: "Twitter",
                          onTap: () {/* Twitter sign-in */},
                        ),
                      ],
                    ),

                    // Sign up section
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 16),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => SignUpBloc(
                                          RegisterUseCase(
                                            context.read<AuthRepositoryImpl>(),
                                          ),
                                        ),
                                        child: const SignUpPresentation(),
                                      )),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 15),
                              children: [
                                TextSpan(
                                  text: "Sign up",
                                  style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Terms
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text.rich(
                        TextSpan(
                          text: "By signing in, you agree to the ",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(
                              text: "Terms of Service",
                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(text: ", including "),
                            TextSpan(
                              text: "Cookie Use",
                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(text: "."),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 11),
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

