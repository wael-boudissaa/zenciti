// features/auth/presentation/screens/sign_up.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/auth/presentation/widgets/auth_field.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/sign_up_event.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Form(
            child: BlocConsumer<SignUpBloc, SignUpState>(
              listener: (context, state) {
                if (state is SignUpSuccess) {
                  // Navigate to the next screen or show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign up successful!')),
                  );
                } else if (state is SignUpFailure) {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AuthField(
                      textlabel: "Email",
                      controller: textEmail,
                    ),
                    SizedBox(height: 15),
                    AuthField(
                      controller: textFirstName,
                      textlabel: "First name",
                    ),
                    SizedBox(height: 15),
                    AuthField(
                      controller: textLastName,
                      textlabel: "Last name",
                    ),
                    AuthField(
                      controller: textAddress,
                      textlabel: "Address",
                    ),
                    AuthField(
                      controller: textPhone,
                      textlabel: "Phone",
                    ),
                    AuthField(
                      controller: textPassword,
                      textlabel: "Password",
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Dispatch the SignUpSubmitted event
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
                      child: const Text('Sign Up'),
                    ),
                    if (state is SignUpLoading)
                      CircularProgressIndicator(), // Show a loading indicator
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
