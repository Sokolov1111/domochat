class TripRequest {
  final String from;
  final String to;
  final String date;
  final String time;
  final String authorName;
  final double authorRating;

  TripRequest({required this.from, required this.to, required this.date, required this.time, required this.authorName, required this.authorRating});
}