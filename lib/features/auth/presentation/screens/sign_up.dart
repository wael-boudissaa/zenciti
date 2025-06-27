import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenciti/app/config/theme.dart';
import 'package:zenciti/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:zenciti/features/auth/presentation/blocs/sign_up_event.dart';
import 'package:zenciti/features/home/presentation/screens/home_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final textFirstName = TextEditingController();
  final textLastName = TextEditingController();
  final textEmail = TextEditingController();
  final textUsername = TextEditingController();
  final textPassword = TextEditingController();
  final textPhone = TextEditingController();
  final textAddress = TextEditingController();

  bool passwordVisible = false;
  bool agreeTerms = false;
  bool subscribeNewsletter = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
            child: Form(
              child: BlocConsumer<SignUpBloc, SignUpState>(
                listener: (context, state) {
                  if (state is SignUpSuccess) {
                    // Show snackbar then go to home
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registration successful! Logging in...")),
                    );
                    Future.delayed(const Duration(milliseconds: 400), () {
                      // Option 1: If using GoRouter
                      context.go('/');
                      // Option 2: If you want to push to HomeScreen directly:
                      // Navigator.of(context).pushAndRemoveUntil(
                      //   MaterialPageRoute(builder: (_) => const HomeScreen()),
                      //   (route) => false,
                      // );
                    });
                  } else if (state is SignUpFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0, bottom: 16),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const Text(
                          "Create your account",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Join Zenciti to explore smart city services",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Name fields side by side
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "First name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    controller: textFirstName,
                                    decoration: InputDecoration(
                                      hintText: "John",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          color: AppColors.greenPrimary,
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Last name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    controller: textLastName,
                                    decoration: InputDecoration(
                                      hintText: "Doe",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          color: AppColors.greenPrimary,
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Email field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: textEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "johndoe@example.com",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: AppColors.greenPrimary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Username
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Username",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: textUsername,
                              decoration: InputDecoration(
                                hintText: "yourusername",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: AppColors.greenPrimary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Password
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Stack(
                              children: [
                                TextField(
                                  controller: textPassword,
                                  obscureText: !passwordVisible,
                                  decoration: InputDecoration(
                                    hintText: "At least 8 characters",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: AppColors.greenPrimary,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    suffixIcon: IconButton(
                                      icon: Icon(passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() =>
                                            passwordVisible = !passwordVisible);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                _StrengthBar(strength: 1),
                                _StrengthBar(),
                                _StrengthBar(),
                                _StrengthBar(),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Weak - Add uppercase letters and numbers",
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Phone number (with static +1 country code)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Phone number",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF9FAFB),
                                    border:
                                        Border.all(color: Color(0xFFD1D5DB)),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(14),
                                      bottomLeft: Radius.circular(14),
                                    ),
                                  ),
                                  child: Row(
                                    children: const [
                                      Text("+1",
                                          style: TextStyle(fontSize: 15)),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_drop_down,
                                          size: 18, color: Colors.grey),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: textPhone,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: "(555) 123-4567",
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(14),
                                          bottomRight: Radius.circular(14),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(14),
                                          bottomRight: Radius.circular(14),
                                        ),
                                        borderSide: BorderSide(
                                          color: AppColors.greenPrimary,
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Address
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: textAddress,
                              decoration: InputDecoration(
                                hintText: "Enter your address",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: AppColors.greenPrimary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Terms and newsletter checkboxes
                        Row(
                          children: [
                            Checkbox(
                              value: agreeTerms,
                              onChanged: (v) =>
                                  setState(() => agreeTerms = v ?? false),
                              activeColor: AppColors.greenPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: "I agree to the ",
                                  style: const TextStyle(
                                      color: Color(0xFF6B7280), fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: "Terms of Service",
                                      style: TextStyle(
                                          color: AppColors.greenPrimary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const TextSpan(text: " and "),
                                    TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(
                                          color: AppColors.greenPrimary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: subscribeNewsletter,
                              onChanged: (v) => setState(
                                  () => subscribeNewsletter = v ?? true),
                              activeColor: AppColors.greenPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                "I'd like to receive updates about Zenciti services, features and offers",
                                style: TextStyle(
                                    color: Color(0xFF6B7280), fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),

                        // Create account button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenPrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                              elevation: 2,
                            ),
                            onPressed: () {
                              if (!agreeTerms) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please agree to the terms.")),
                                );
                                return;
                              }
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
                            },
                            child: const Text("Create account"),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Already have account? Sign in
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              context.go('/'); // Or go to login screen
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                    color: Color(0xFF6B7280), fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: "Sign in",
                                    style: TextStyle(
                                      color: AppColors.greenPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (state is SignUpLoading)
                          const Center(child: CircularProgressIndicator()),
                      ],
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

class _StrengthBar extends StatelessWidget {
  final int strength; // 1 = filled, 0 = empty
  const _StrengthBar({this.strength = 0});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 5,
        decoration: BoxDecoration(
          color:
              strength > 0 ? AppColors.greenPrimary : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
