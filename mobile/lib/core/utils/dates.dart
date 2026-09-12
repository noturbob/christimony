/// Two differently-named date helpers so they can never be confused —
/// see `docs/mobile-v1-plan.md` §4.6.10.
///
/// `dob` is a bare civil date (`"1998-04-02"`) with no time-of-day or
/// timezone component. Converting it with `.toLocal()` shifts the day
/// whenever the device's UTC offset and the date's implied UTC-midnight
/// interpretation disagree — e.g. a UTC→IST conversion can silently move
/// a birthday by a day. Parse it as a pure calendar date instead.
DateTime parseCivilDate(String value) {
  final parts = value.split('-');
  return DateTime(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

/// `sent_at`, `matched_at`, `verified_at`, etc. are real UTC instants and
/// SHOULD be localized for display.
DateTime parseInstant(String value) => DateTime.parse(value).toLocal();
