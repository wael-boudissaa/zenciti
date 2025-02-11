import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/domain/usecase/register_use_case.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/login_event.dart';
import 'package:zenciti/features/auth/presentation/screens/home_screen.dart';
import 'package:zenciti/features/auth/presentation/screens/sign_up.dart';
import 'package:zenciti/features/auth/presentation/widgets/auth_field.dart';
import 'package:zenciti/features/auth/presentation/widgets/button_rushcoif.dart';
import 'package:zenciti/features/auth/presentation/widgets/divider.dart';
import 'package:zenciti/features/auth/presentation/widgets/google_sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'RushCoiff',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AuthField(
                    textlabel: 'Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 22),
                  AuthField(
                    textlabel: 'Password',
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 16),
                  ButtonRushCoif(
                    textstring: 'Se Connecter',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(
                              LoginSubmitted(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DividerOr(),
                  GoogleSignInButton(),
                  const Divider(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => SignUpBloc(
                                  RegisterUseCase(
                                    context.read<AuthRepositoryImpl>(),
                                  ),
                                ),
                            child: BlocConsumer<SignUpBloc, SignUpState>(
                              listener: (context, state) {
                                if (state is SignUpSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Sign up successful!')),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                } else if (state is SignUpFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.error)),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return const SignUp();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Dont have an account? Sign up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
