import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:meet_us/src/entity/schedule_room.dart';
import 'package:meet_us/src/service/calendar_service.dart';

class CalendarState extends ChangeNotifier {
  final CalendarService _calendarService;

  CalendarState(this._calendarService);

  Map<String, Map<String, ScheduleRoom>> _liveRoomsByMonth =
      <String, Map<String, ScheduleRoom>>{};
  UnmodifiableMapView<String, Map<String, ScheduleRoom>> get liveRoomsByMonth =>
      UnmodifiableMapView<String, Map<String, ScheduleRoom>>(_liveRoomsByMonth);
  List<ScheduleRoom> _selectedEvents = <ScheduleRoom>[];
  UnmodifiableListView<ScheduleRoom> get selectedEvents =>
      UnmodifiableListView(_selectedEvents);
  DateTime _focusedDay = DateTime.now();
  DateTime get focusedDay => _focusedDay;
  DateTime? _selectedDay;
  DateTime? get selectedDay => _selectedDay;
  final firstDay = DateTime.now().subtract(const Duration(days: 30));
  final lastDay = DateTime.now().add(const Duration(days: 365 * 2));

  Future<List<ScheduleRoom>> getLiveRooms(DateTime date) async {
    try {
      final rooms = await _calendarService.getLiveRooms(date);
      if (rooms.isEmpty) {
        return [];
      }
      final roomMapByMonth =
          Map<String, Map<String, ScheduleRoom>>.from(_liveRoomsByMonth);
      for (final room in rooms) {
        final roomMap = roomMapByMonth[room.key] ?? <String, ScheduleRoom>{};
        roomMap[room.id] = room;
        roomMapByMonth[room.key] = roomMap;
      }
      _liveRoomsByMonth = roomMapByMonth;
      notifyListeners();
      return rooms;
    } catch (e) {
      debugPrint('$e');
    }
    return [];
  }

  Future<void> createNewLiveRoom(
    String title,
    DateTime startTime,
    DateTime endTime,
    List<String> participantIds,
  ) {
    return _calendarService.createLiveRoom(
      title,
      startTime,
      endTime,
      participantIds,
    );
  }

  bool selectedDayPredicate(DateTime day) {
    return _isSameDay(_selectedDay, day);
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    _selectedEvents = eventLoader(selectedDay);
    notifyListeners();
  }

  void onPageChanged(DateTime focusedDay) async {
    _focusedDay = focusedDay;
    notifyListeners();
    getLiveRooms(focusedDay);
  }

  List<ScheduleRoom> eventLoader(DateTime day) {
    return (_liveRoomsByMonth['${day.day}-${day.month}-${day.year}'] ??
            <String, ScheduleRoom>{})
        .values
        .toList();
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
