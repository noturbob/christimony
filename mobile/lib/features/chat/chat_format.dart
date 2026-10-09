import 'package:intl/intl.dart';

DateTime _day(DateTime t) => DateTime(t.year, t.month, t.day);

int _daysAgo(DateTime t, DateTime now) =>
    (_day(now).difference(_day(t)).inHours / 24).round(); // DST-safe

/// Thread day separators: "Today", "Yesterday", "Mon, Mar 3".
String dayLabel(DateTime t, {DateTime? now}) =>
    switch (_daysAgo(t, now ?? DateTime.now())) {
      0 => 'Today',
      1 => 'Yesterday',
      _ => DateFormat('EEE, MMM d').format(t),
    };

String timeLabel(DateTime t) => DateFormat.jm().format(t);

/// Inbox row time: the time today, then "Yesterday", the weekday this
/// week, and the date after that.
String inboxTime(DateTime t, {DateTime? now}) =>
    switch (_daysAgo(t, now ?? DateTime.now())) {
      0 => timeLabel(t),
      1 => 'Yesterday',
      < 7 => DateFormat.E().format(t),
      _ => DateFormat.MMMd().format(t),
    };

bool sameDay(DateTime a, DateTime b) => _day(a) == _day(b);
