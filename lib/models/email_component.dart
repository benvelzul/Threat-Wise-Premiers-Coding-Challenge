import 'enums.dart';

class EmailComponent {
  final String text;
  final List<Indicator> indicators;

  const EmailComponent({
    required this.text,
    this.indicators = const [],
  });
}