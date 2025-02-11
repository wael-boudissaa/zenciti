import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/domain/usecase/login_use_case.dart';
import 'package:zenciti/features/auth/presentation/screens/login_screen.dart';
import 'package:zenciti/features/auth/presentation/widgets/auth_field.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/sign_up_event.dart';
import 'package:zenciti/features/auth/presentation/widgets/button_rushcoif.dart';
import 'package:zenciti/features/auth/presentation/widgets/divider.dart';
import 'package:zenciti/features/auth/presentation/widgets/google_sign_in_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final textEmail = TextEditingController();
  final textFirstName = TextEditingController();
  final textPhone = TextEditingController();
  final textAddress = TextEditingController();
  final textPassword = TextEditingController();
  final textLastName = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
            return  Scaffold(
        // appBar:  Text('this is the text'),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Form(
                child: BlocConsumer<SignUpBloc, SignUpState>(
                  listener: (context, state) {
                    if (state is SignUpSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign up successful!')),
                      );
                    } else if (state is SignUpFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: const Text(
                            "RushCoiff",
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
      
                        const SizedBox(height: 30),
                        Center(
                          child: const Text(
                            "Creer votre compte",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AuthField(
                          textlabel: "Entrer votre Nom",
                          controller: textFirstName,
                        ),
                        const SizedBox(height: 15),
                        AuthField(
                            controller: textLastName,
                            textlabel: "Entrer votre Prenom",
                        ),
                        const SizedBox(height: 15),
                        AuthField(
                          controller: textEmail,
                          textlabel: "Entrer votre Email",
                        ),
                        const SizedBox(height: 15),
                        AuthField(
                          controller: textAddress,
                          textlabel: "Entrer votre Address",
                        ),
                        const SizedBox(height: 15),
                        AuthField(
                          controller: textPassword,
                          textlabel: "Entrer votre Password",
                          obscureText: passwordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        AuthField(
                          controller: textPhone,
                          textlabel: "Re-Entrer votre Password",
                          obscureText: passwordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ButtonRushCoif(
                            onPressed: () {
                              context.read<SignUpBloc>().add(
                                    SignUpSubmitted(
                                      email: textEmail.text,
                                      firstName: textFirstName.text,
                                      lastName: textLastName.text,
                                      address: textAddress.text,
                                      password: textPassword.text,
                                      phone: textPhone.text,
                                    ),
                                  );
                            },
                            textstring: "S'inscrire",
                          ),
                        ),
      
                        const SizedBox(height: 15),
                        DividerOr(),
                        const SizedBox(height: 15),
      
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height *
                                    0.05, // 5% above the bottom
                              ),
                              child: GoogleSignInButton(),
                            )),
                        // const SizedBox(height: 15),
      
                        // const SizedBox(height: 15),
                        // const  Divider(),
      
                        // Center(
                        //   child: TextButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => BlocProvider(
                        //               create: (context) => LoginBloc(
                        //                     LoginUseCase(
                        //                       context.read<AuthRepositoryImpl>(),
                        //                     ),
                        //                   ),
                        //             child: LoginScreen(),
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //     child: const Text('Already have an account? Login',style: TextStyle(color:Colors.blue,fontSize: 16),),
                        //   ),
                        // ),
      
                        if (state is SignUpLoading)
                          const Center(child: CircularProgressIndicator()),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
  }
}
