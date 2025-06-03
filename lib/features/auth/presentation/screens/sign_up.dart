import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/auth/data/repositories/auth_repositorie.dart';
import 'package:zenciti/features/auth/domain/usecase/login_use_case.dart';
import 'package:zenciti/features/auth/presentation/screens/login_screen.dart';
import 'package:zenciti/features/auth/presentation/widgets/auth_field.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/sign_up_event.dart';
import 'package:zenciti/features/auth/presentation/widgets/button_zenciti.dart';
import 'package:zenciti/features/auth/presentation/widgets/divider.dart';
import 'package:zenciti/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:zenciti/features/home/presentation/screens/home_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final textEmail = TextEditingController();
  final textUsername = TextEditingController();
  final textFirstName = TextEditingController();
  final textPhone = TextEditingController();
  final textAddress = TextEditingController();
  final textPassword = TextEditingController();
  final textLastName = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      SnackBar(
                        content: const Text("Registration successful!"),
                        action: SnackBarAction(
                          label: 'Login',
                          onPressed: () {
                            context.go('/');
                          },
                        ),
                      ),
                    );
                  } else if (state is SignUpFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Center(
                          //   child: Text(
                          //     "Explore Now",
                          //     style: TextStyle(
                          //       fontSize: 70,
                          //       color: AppColors.text,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),

                          const SizedBox(height: 30),
                          Text(
                            "Join Zenciti Today",
                            style: TextStyle(
                              fontSize: 30,
                              color: AppColors.greenPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 30),
                          AuthField(
                              textlabel: "Name",
                              controller: textFirstName,
                              description: "Please enter your name."),
                          const SizedBox(height: 15),
                          AuthField(
                              controller: textLastName,
                              textlabel: "Last Name",
                              description: "Please enter your Last name."),
                          const SizedBox(height: 15),
                          AuthField(
                              controller: textEmail,
                              textlabel: "Email",
                              description: "Please enter your email."),
                          const SizedBox(height: 15),
                          AuthField(
                              controller: textUsername,
                              textlabel: "Username",
                              description: "Please enter your username."),
                          const SizedBox(height: 15),
                          AuthField(
                              controller: textAddress,
                              textlabel: "Address",
                              description: "Please enter your address."),
                          const SizedBox(height: 15),
                          AuthField(
                            controller: textPassword,
                            textlabel: "Password",
                            description: "Please enter your password.",
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
                            description: "Please re-enter your password.",
                            textlabel: "Password",
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
                            child: ButtonBlack(
                              onPressed: () {
                                context.read<SignUpBloc>().add(
                                      SignUpSubmitted(
                                        email: textEmail.text,
                                        firstName: textFirstName.text,
                                        lastName: textLastName.text,
                                        address: textAddress.text,
                                        password: textPassword.text,
                                        username: textUsername.text,
                                        phone: textPhone.text,
                                      ),
                                    );
                                // context.go('/');
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
                      ),
                    ),
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
