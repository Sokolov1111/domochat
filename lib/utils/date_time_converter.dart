
class DateTimeConverter {
  const DateTimeConverter();

  static String formatTimeHHmm(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }
}