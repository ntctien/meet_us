import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/screens/home_screen.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/utils/app_utils.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  static const String routeName = 'createAccountScreen';

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/app_icon.png',
              width: 150.0,
              height: 150.0,
            ),
            const Gap(24.0),
            Text(
              'Create New Account',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Form(
              key: _emailKey,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: 'Email',
                ),
                validator: _emailValidator,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const Gap(16.0),
            Form(
              key: _passwordKey,
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: 'Password',
                ),
                validator: _passwordValidator,
              ),
            ),
            const Gap(24.0),
            FilledButton(onPressed: _onSignIn, child: const Text('Sign In')),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null) {
      return 'Please fill email';
    }
    if (AppUtils.isEmail(value)) {
      return null;
    }
    return 'Email is invalid';
  }

  String? _passwordValidator(String? value) {
    if (value == null) {
      return 'Please fill password';
    }
    final length = value.length;
    if (length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  void _onSignIn() async {
    if (!(_emailKey.currentState?.validate() ?? false) ||
        !(_passwordKey.currentState?.validate() ?? false)) {
      return;
    }
    final userState = context.read<UsersState>();
    try {
      await userState.createAccount(
        _emailController.text,
        _passwordController.text,
      );
      if (mounted) {
        context.go(HomeScreen.routeName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }
}
