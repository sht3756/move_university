import 'package:intl/intl.dart';

String formatDateTime(String date) {
  try {
    final DateTime parsedDate = DateTime.parse(date);

    final DateFormat formatter = DateFormat('yyyy년MM월dd일 HH시 mm분 ss초');

    return formatter.format(parsedDate);
  } catch (e) {
    return 'Invalid date format';
  }
}
