// ignore: file_names
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class DateTimeHelper {
  static bool isBeforeWeek(DateTime date) {
    DateTime fromWeek = DateTime.now().subtract(const Duration(days: 6));
    if (date.isBefore(fromWeek)) {
      return true;
    } else {
      return false;
    }
  }

  static String formatDateTime(DateTime dateTime) {
    final DateFormat format = DateFormat('dd/MM/yyyy hh:mm:ss');
    return format.format(dateTime);
  }

  static String formatTheDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }
}
