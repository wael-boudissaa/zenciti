import 'package:flutter/material.dart';
import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/auth/presentation/screens/login_screen.dart';
import 'package:zenciti/features/auth/presentation/screens/sign_up.dart';
import 'package:zenciti/features/auth/presentation/widgets/button_zenciti.dart';
import 'package:zenciti/features/auth/presentation/widgets/button_zenciti_container.dart';
import 'package:zenciti/features/auth/presentation/widgets/button_zenciti_white.dart';
import 'package:zenciti/features/auth/presentation/widgets/divider.dart';
import 'package:zenciti/features/auth/presentation/widgets/google_sign_in_button.dart';

class SignUpPresentation extends StatefulWidget {
  const SignUpPresentation({super.key});

  @override
  State<SignUpPresentation> createState() => _SignUpPresentationState();
}

class _SignUpPresentationState extends State<SignUpPresentation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(17.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Explore Now",
                  style: TextStyle(
                    fontSize: 65,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Join Zenciti Today",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                // Add your widgets here

                SizedBox(height: 30),

                GoogleSignInButton(),
                SizedBox(height: 30),

                GoogleSignInButton(),

                DividerOr(),

                SizedBox(height: 50),
                Center(
                  child: ButtonZencitiContainer(
                      textButton: "Create an account",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        );
                      }),
                ),

                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Already have an account? Sign in",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                ),
                Center(
                    child: ButtonZencitiWhite(
                        textButton: "Sign in",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }
}
