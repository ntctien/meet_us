import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_us/src/screens/change_password_screen.dart';
import 'package:meet_us/src/screens/home_screen.dart';
import 'package:meet_us/src/screens/login_screen.dart';
import 'package:meet_us/src/state/message_state.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/utils/app_utils.dart';
import 'package:meet_us/src/widget/dialog_utils.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  static const routeName = 'userProfile';

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _nameKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _localImage = ValueNotifier<XFile?>(null);

  @override
  void initState() {
    super.initState();
    final user = context.read<UsersState>().user!;
    _emailController.text = user.email;
    _nameController.text = user.name;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UsersState>().user!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => AppUtils.dismissFocusNode(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Gap(16.0),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,
                width: 128.0,
                height: 128.0,
                child: GestureDetector(
                  onTap: _onPickImage,
                  child: ValueListenableBuilder<XFile?>(
                    valueListenable: _localImage,
                    builder: (context, localImage, child) {
                      if (localImage == null) {
                        return child!;
                      }
                      return Image.file(
                        File(localImage.path),
                        fit: BoxFit.cover,
                        height: 128,
                        width: 128,
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: user.avatar,
                      fit: BoxFit.cover,
                      height: 128,
                      width: 128,
                      errorWidget: (ctx, url, error) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              AppUtils.getDisplayUserName(
                                user,
                                onlyFirstChar: true,
                              ),
                              style: const TextStyle(
                                fontSize: 64.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const Gap(32.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelText: 'Email',
                ),
                enabled: false,
              ),
              const Gap(16.0),
              Form(
                key: _nameKey,
                child: TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Name',
                  ),
                  validator: _nameValidator,
                ),
              ),
              const Gap(16.0),
              ElevatedButton(
                onPressed: _onNavigateToChangePasswordScreen,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 36.0,
                  ),
                ),
                child: const Text('Change Password'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 84.0,
                    vertical: 16.0,
                  ),
                ),
                child: const Text('Save'),
              ),
              const Gap(16.0),
            ],
          ),
        ),
      ),
    );
  }

  String? _nameValidator(String? value) {
    if (value == null) {
      return 'Please fill name';
    }
    if (value.length < 2) {
      return 'Name is not valid';
    }
    return null;
  }

  void _logout() {
    context.read<UsersState>().logout().then((_) {
      context.read<MessageState>().disposeSocket();
      context.go(LoginScreen.routeName);
    });
  }

  void _onPickImage() async {
    final ImagePicker picker = ImagePicker();
    _localImage.value = await picker.pickImage(source: ImageSource.gallery);
  }

  void _onNavigateToChangePasswordScreen() {
    context.push(
      '${HomeScreen.routeName}/${UserProfileScreen.routeName}/${ChangePasswordScreen.routeName}',
    );
  }

  void _onSave() {
    if (_nameKey.currentState?.validate() == false) {
      if (!_nameFocusNode.hasFocus) {
        _nameFocusNode.requestFocus();
      }
      return;
    }

    _nameFocusNode.unfocus();
    final userState = context.read<UsersState>();
    final newUser = userState.user!.copyWith(
      name: _nameController.text,
      avatar: _localImage.value?.path ?? userState.user!.avatar,
    );
    if (userState.user == newUser) {
      return;
    }

    DialogUtils.showLoading(context);
    userState
        .updateUserProfile(newUser, imagePath: _localImage.value?.path)
        .then((_) {
      DialogUtils.dismissLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Update Successfully'),
          ),
        ),
      );
    }).onError((error, _) {
      DialogUtils.dismissLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$error'),
          ),
        ),
      );
    });
  }
}
