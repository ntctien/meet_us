import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_us/src/entity/user.dart';
import 'package:meet_us/src/state/calendar_state.dart';
import 'package:meet_us/src/widget/custom_autocomplete_options_view_builder.dart';
import 'package:meet_us/src/state/users_state.dart';
import 'package:meet_us/src/utils/app_utils.dart';
import 'package:meet_us/src/widget/dialog_utils.dart';
import 'package:provider/provider.dart';

class CreateNewLiveRoomScreen extends StatefulWidget {
  const CreateNewLiveRoomScreen({super.key});

  static const routeName = 'createNewLiveRoom';

  @override
  State<CreateNewLiveRoomScreen> createState() =>
      _CreateNewLiveRoomScreenState();
}

class _CreateNewLiveRoomScreenState extends State<CreateNewLiveRoomScreen> {
  final _titleKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  String _keyword = '';
  FocusNode? _searchFocus;
  final _date = ValueNotifier<DateTime>(DateTime.now());
  final _startTime = ValueNotifier<DateTime>(DateTime.now());
  final _endTime =
      ValueNotifier<DateTime>(DateTime.now().add(const Duration(minutes: 30)));
  final _participants = ValueNotifier<Set<User>>({});
  List<User> _lastSearchOptions = <User>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Create Live Room'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _titleKey,
              child: TextFormField(
                controller: _title,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  hintText: 'Live Room Title',
                ),
                validator: _titleValidator,
              ),
            ),
            const Gap(16.0),
            ValueListenableBuilder<DateTime>(
              valueListenable: _date,
              builder: (context, date, _) {
                return TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormat('dd/MM/yyyy', 'vi_VN').format(date),
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onTap: _pickDateTime,
                );
              },
            ),
            const Gap(16.0),
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<DateTime>(
                    valueListenable: _startTime,
                    builder: (context, date, _) {
                      return TextField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: DateFormat('HH:mm', 'vi_VN').format(date),
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            labelText: 'Start time'),
                        onTap: () => _pickTime(_startTime),
                      );
                    },
                  ),
                ),
                const Gap(16.0),
                Expanded(
                  child: ValueListenableBuilder<DateTime>(
                    valueListenable: _endTime,
                    builder: (context, date, _) {
                      return TextField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: DateFormat('HH:mm', 'vi_VN').format(date),
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            labelText: 'End time'),
                        onTap: () => _pickTime(
                          _endTime,
                          minimumDate: _startTime.value,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const Gap(16.0),
            Autocomplete<User>(
              optionsBuilder: _optionBuilder,
              onSelected: _onSelected,
              displayStringForOption: (_) => '',
              optionsViewBuilder: (
                context,
                onSelected,
                options,
              ) {
                return CustomAutocompleteOptionsViewBuilder<User>(
                  displayForOption: (user) => ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: user.avatar,
                      fit: BoxFit.cover,
                      height: 24,
                      width: 24,
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
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                    title: Text(user.displayName),
                  ),
                  maxOptionsHeight: 200.0,
                  onSelected: _onSelected,
                  options: options,
                );
              },
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                _searchFocus = focusNode;
                return TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Search by name or email',
                  ),
                  focusNode: focusNode,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              },
            ),
            const Gap(16.0),
            Expanded(
              child: ValueListenableBuilder<Set<User>>(
                valueListenable: _participants,
                builder: (context, users, _) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final user = users.elementAt(index);
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: user.avatar,
                          fit: BoxFit.cover,
                          height: 24,
                          width: 24,
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
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                        title: Text(user.displayName),
                        trailing: IconButton(
                          onPressed: () => _onRemoveParticipant(user),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      );
                    },
                    itemCount: users.length,
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _onCreateLiveRoom,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 84.0,
                  vertical: 16.0,
                ),
              ),
              child: const Text('Create Live Room'),
            ),
          ],
        ),
      ),
    );
  }

  String? _titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fill Live Room Title';
    }
    return null;
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date.value,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.day,
    );
    if (date != null) {
      _date.value = date;
      _startTime.value = DateTime(date.year, date.month, date.day,
          _startTime.value.hour, _startTime.value.minute);
      _endTime.value = DateTime(date.year, date.month, date.day,
          _endTime.value.hour, _endTime.value.minute);
    }
  }

  void _pickTime(
    ValueNotifier<DateTime> time, {
    DateTime? minimumDate,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 216.0,
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            minimumDate: minimumDate,
            initialDateTime: time.value,
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            onDateTimeChanged: (date) => time.value = date,
          ),
        ),
      ),
    );
  }

  FutureOr<Iterable<User>> _optionBuilder(
    TextEditingValue textEditingValue,
  ) async {
    final userState = context.read<UsersState>();
    _keyword = textEditingValue.text;
    final options = await userState.searchUsersByKeyword(_keyword);

    if (_keyword != textEditingValue.text) {
      return _lastSearchOptions;
    }

    _lastSearchOptions = options;
    return options;
  }

  void _onSelected(User selection) {
    _searchFocus?.unfocus();
    final users = Set<User>.from(_participants.value);
    users.add(selection);
    _participants.value = users;
  }

  void _onRemoveParticipant(User user) {
    final users = Set<User>.from(_participants.value);
    users.remove(user);
    _participants.value = users;
  }

  void _onCreateLiveRoom() {
    if (_startTime.value.compareTo(_endTime.value) != -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Start time must be before end time'),
          ),
        ),
      );
      return;
    }
    final calendarState = context.read<CalendarState>();
    DialogUtils.showLoading(context);
    calendarState
        .createNewLiveRoom(
      _title.text,
      _startTime.value,
      _endTime.value,
      _participants.value.map((e) => e.uid).toList(),
    )
        .then((_) {
      DialogUtils.dismissLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          content: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Create Live Room Success'),
          ),
        ),
      );
      calendarState.getLiveRooms(_startTime.value);
      context.pop();
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
