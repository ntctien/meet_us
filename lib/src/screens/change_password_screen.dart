import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/utils/app_utils.dart';
import 'package:meet_us/src/widget/dialog_utils.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  static const routeName = 'changePassword';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordKey = GlobalKey<FormState>();
  final _newPasswordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _obscureTextOldPassword = ValueNotifier<bool>(true);
  final _obscureTextNewPassword = ValueNotifier<bool>(true);
  final _obscureTextConfirmPassword = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _obscureTextOldPassword,
              builder: (context, obscureText, _) {
                return Form(
                  key: _oldPasswordKey,
                  child: TextFormField(
                    controller: _oldPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Old Password',
                      suffixIcon: IconButton(
                        onPressed: () => _obscureTextOldPassword.value =
                            !_obscureTextOldPassword.value,
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: obscureText,
                    validator: _oldPasswordValidator,
                  ),
                );
              },
            ),
            const Gap(16.0),
            ValueListenableBuilder<bool>(
              valueListenable: _obscureTextNewPassword,
              builder: (context, obscureText, _) {
                return Form(
                  key: _newPasswordKey,
                  child: TextFormField(
                    controller: _newPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        onPressed: () => _obscureTextNewPassword.value =
                            !_obscureTextNewPassword.value,
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: obscureText,
                    validator: _newPasswordValidator,
                  ),
                );
              },
            ),
            const Gap(16.0),
            ValueListenableBuilder<bool>(
              valueListenable: _obscureTextConfirmPassword,
              builder: (context, obscureText, _) {
                return Form(
                  key: _confirmPasswordKey,
                  child: TextFormField(
                    controller: _confirmPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        onPressed: () => _obscureTextConfirmPassword.value =
                            !_obscureTextConfirmPassword.value,
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: obscureText,
                    validator: _confirmPasswordValidator,
                  ),
                );
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _onChangedPassword,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  String? _oldPasswordValidator(String? value) {
    if (value == null) {
      return 'Please fill old password';
    }
    final length = value.length;
    if (length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _newPasswordValidator(String? value) {
    if (value == null) {
      return 'Please fill new password';
    }
    final length = value.length;
    if (length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null) {
      return 'Please fill confirm new password';
    }
    final length = value.length;
    if (length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (_newPassword.text != _confirmPassword.text) {
      return 'Confirm password is not matched';
    }
    return null;
  }

  void _onChangedPassword() {
    AppUtils.dismissFocusNode(context);
    if (_oldPasswordKey.currentState?.validate() == false ||
        _newPasswordKey.currentState?.validate() == false ||
        _confirmPasswordKey.currentState?.validate() == false) {
      return;
    }
    final userState = context.read<UsersState>();
    DialogUtils.showLoading(context);
    userState
        .changePassword(
      _oldPassword.text,
      _newPassword.text,
      _confirmPassword.text,
    )
        .then((_) {
      DialogUtils.dismissLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Change Password Success'),
          ),
        ),
      );
      context.pop();
    }).onError((error, _) {
      DialogUtils.dismissLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Change Password Failed: $error'),
          ),
        ),
      );
    });
  }
}
