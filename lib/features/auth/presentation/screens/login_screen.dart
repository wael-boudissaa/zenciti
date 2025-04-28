import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/domain/usecase/register_use_case.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/login_event.dart';
import 'package:zenciti/features/auth/presentation/screens/home_screen.dart';
import 'package:zenciti/features/auth/presentation/screens/sign_up.dart';
import 'package:zenciti/features/auth/presentation/screens/sign_up_presentation.dart';
import 'package:zenciti/features/auth/presentation/widgets/auth_field.dart';
import 'package:zenciti/features/auth/presentation/widgets/button_zenciti.dart';
import 'package:zenciti/features/auth/presentation/widgets/divider.dart';
import 'package:zenciti/features/auth/presentation/widgets/google_sign_in_button.dart';

import 'package:forui/forui.dart';
import 'package:zenciti/features/home/presentation/screens/home_page.dart';

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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            // mainAxisAlignment:MainAxisAlignment.start
                            'New User?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            child: const Text(
                              // mainAxisAlignment:MainAxisAlignment.start
                              'Create an account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.greenPrimary,
                              ),
                            ),
                            // onPressed: () {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => BlocProvider(
                            //         create: (context) => SignUpBloc(
                            //           RegisterUseCase(
                            //             context.read<AuthRepositoryImpl>(),
                            //           ),
                            //         ),
                            //         child: const SignUp(),
                            //       ),
                            //     ),
                            //   );
                            // },
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                          create: (context) => SignUpBloc(
                                            RegisterUseCase(
                                              context
                                                  .read<AuthRepositoryImpl>(),
                                            ),
                                          ),
                                          child: const SignUpPresentation(),
                                        )),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      FTextField(
                        controller: _emailController,
                        label: const Text('Email Address'),
                        hint: 'example@gmail.com',
                        maxLines: 1,
                      ),
                      const SizedBox(height: 22),
                      // AuthField(
                      //   textlabel: 'Password',
                      //   controller: _passwordController,
                      // ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonBlack(
                            textstring: 'Se Connecter',
                            onPressed: () {
                              // if (_formKey.currentState!.validate()) {
                              //   context.read<LoginBloc>().add(
                              //         LoginSubmitted(
                              //           email: _emailController.text.trim(),
                              //           password:
                              //               _passwordController.text.trim(),
                              //         ),
                              //       );
                              // }
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => Home_Page(),
                              //     ));
                                context.go('/home');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DividerOr(),

                      const SizedBox(height: 25),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GoogleSignInButton(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FilledButton.tonal(
                                onPressed: () {},
                                child: Text('Tonal Button'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GoogleSignInButton(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Image.asset('assets/images/login_page.png'),
              ),
            ],
          );
        },
      ),
    );
  }
}














                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => BlocProvider(
                  //           create: (context) => SignUpBloc(
                  //             RegisterUseCase(
                  //               context.read<AuthRepositoryImpl>(),
                  //             ),
                  //           ),
                  //           child: BlocConsumer<SignUpBloc, SignUpState>(
                  //             listener: (context, state) {
                  //               if (state is SignUpSuccess) {
                  //                 ScaffoldMessenger.of(context).showSnackBar(
                  //                   const SnackBar(
                  //                       content: Text('Sign up successful!')),
                  //                 );
                  //                 Navigator.pushReplacement(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) => LoginScreen()),
                  //                 );
                  //               } else if (state is SignUpFailure) {
                  //                 ScaffoldMessenger.of(context).showSnackBar(
                  //                   SnackBar(content: Text(state.error)),
                  //                 );
                  //               }
                  //             },
                  //             builder: (context, state) {
                  //               return const SignUp();
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   child: const Text(
                  //     'Dont have an account? Sign up',
                  //     style: TextStyle(
                  //       color: Colors.blue,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
