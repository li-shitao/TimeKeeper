class Event {
  final int id;
  final String title;
  final DateTime eventTime;
  final String description;

  Event({required this.id, required this.title, required this.eventTime, required this.description});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      eventTime: DateTime.parse(json['eventTime']),
      description: json['description'],
    );
  }
}
