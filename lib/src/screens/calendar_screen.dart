import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_us/src/entity/schedule_room.dart';
import 'package:meet_us/src/state/calendar_state.dart';
import 'package:meet_us/src/screens/create_new_live_room_screen.dart';
import 'package:meet_us/src/screens/home_screen.dart';
import 'package:meet_us/src/widget/live_room_model_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  static const String routeName = 'calendar';

  @override
  Widget build(BuildContext context) {
    final calendarState = context.watch<CalendarState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _createNewRoom(context),
            icon: const Icon(Icons.add, color: Colors.blue),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            onCalendarCreated: (_) =>
                calendarState.getLiveRooms(DateTime.now()),
            firstDay: calendarState.firstDay,
            lastDay: calendarState.lastDay,
            focusedDay: calendarState.focusedDay,
            selectedDayPredicate: calendarState.selectedDayPredicate,
            onDaySelected: calendarState.onDaySelected,
            onPageChanged: calendarState.onPageChanged,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            eventLoader: calendarState.eventLoader,
          ),
          const Gap(16.0),
          Expanded(
            child: ListView.builder(
              itemCount: calendarState.selectedEvents.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    onTap: () => _onScheduleRoomTap(
                      context,
                      calendarState.selectedEvents[index],
                    ),
                    title: Text(
                      calendarState.selectedEvents[index].title,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _createNewRoom(BuildContext context) {
    context.push(
      '${HomeScreen.routeName}/${CalendarScreen.routeName}/${CreateNewLiveRoomScreen.routeName}',
    );
  }

  void _onScheduleRoomTap(BuildContext context, ScheduleRoom room) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 3 / 4,
      ),
      builder: (context) => LiveRoomModelBottomSheet(room: room),
    );
  }
}
