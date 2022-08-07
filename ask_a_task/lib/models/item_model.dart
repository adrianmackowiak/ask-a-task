import 'package:intl/intl.dart';

class ItemModel {
  final String id;
  final String title;
  final String description;
  final String imageURL;
  final DateTime relaseDate;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.relaseDate,
  });

  String daysLeft() {
    return relaseDate.difference(DateTime.now()).inDays.toString();
  }

  String releaseDateFormatted() {
    return DateFormat.MMMEd().format(relaseDate);
  }
}
