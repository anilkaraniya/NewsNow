import 'package:intl/intl.dart';

String? dateFormatterYMD(DateTime? date) {
  return DateFormat("yMMMMd").format(date!);
}
