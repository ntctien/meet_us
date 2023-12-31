import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/screens/home_screen.dart';
import 'package:meet_us/src/state/message_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/utils/app_utils.dart';
import 'package:meet_us/src/widget/dialog_utils.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  static const String routeName = 'createAccount';

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _obscureText = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => AppUtils.dismissFocusNode(context),
        child: Padding(
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
              ValueListenableBuilder(
                valueListenable: _obscureText,
                builder: (context, obscureText, _) {
                  return Form(
                    key: _passwordKey,
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              _obscureText.value = !_obscureText.value,
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      validator: _passwordValidator,
                      obscureText: obscureText,
                    ),
                  );
                },
              ),
              const Gap(16.0),
              Form(
                key: _nameKey,
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: 'Name',
                  ),
                  validator: _nameValidator,
                ),
              ),
              const Gap(24.0),
              FilledButton(onPressed: _onSignIn, child: const Text('Sign In')),
              const Spacer(flex: 2),
            ],
          ),
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

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill password';
    }
    return null;
  }

  void _onSignIn() async {
    AppUtils.dismissFocusNode(context);
    if (!(_emailKey.currentState?.validate() ?? false) ||
        !(_passwordKey.currentState?.validate() ?? false) ||
        !(_nameKey.currentState?.validate() ?? false)) {
      return;
    }
    final userState = context.read<UsersState>();
    final messageState = context.read<MessageState>();
    try {
      DialogUtils.showLoading(context);
      await userState.createAccount(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );
      DialogUtils.dismissLoading();
      if (mounted) {
        messageState.initializeSocket(
          userState.user!.token,
          userState.user!.displayName,
        );
        context.go(HomeScreen.routeName);
      }
    } catch (e) {
      DialogUtils.dismissLoading();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Sign Up Failed: $e'),
            ),
          ),
        );
      }
    }
  }
}
