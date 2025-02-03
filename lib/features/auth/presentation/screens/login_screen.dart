// presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/login_event.dart';
import 'package:zenciti/features/auth/presentation/screens/home_screen.dart';
import 'package:zenciti/features/auth/presentation/widgets/auth_field.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
              Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => BlocProvider.value(
    value: context.read<LoginBloc>(),
    child: HomeScreen(),
  )));

          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                AuthField(
                    textlabel: 'Email',
                  controller: _emailController,
                ),
                AuthField(
                    textlabel: 'Password',
                  controller: _passwordController,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(LoginSubmitted (email:_emailController.text.trim(),password:_passwordController.text.trim(),));
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
