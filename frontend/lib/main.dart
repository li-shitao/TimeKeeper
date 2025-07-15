import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'add_event_screen.dart';
import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EventListScreen(),
    );
  }
}

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

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late Future<List<Event>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
  }

  Future<List<Event>> fetchEvents() async {
    final dbHelper = DatabaseHelper();
    try {
      // NOTE: Replace with your actual backend URL
      final response = await http.get(Uri.parse('http://localhost:8080/api/events'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        final events = jsonResponse.map((event) => Event.fromJson(event)).toList();
        await dbHelper.clearEvents();
        for (var event in events) {
          await dbHelper.insertEvent(event);
        }
        return events;
      } else {
        // If server fails, try to load from local DB
        return await dbHelper.getEvents();
      }
    } catch (e) {
      // If any network error, load from local DB
      return await dbHelper.getEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: Center(
        child: FutureBuilder<List<Event>>(
          future: futureEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index].title),
                    subtitle: Text(snapshot.data![index].description),
                    trailing: Text(snapshot.data![index].eventTime.toIso8601String()),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          );
          if (result == true) {
            setState(() {
              futureEvents = fetchEvents();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
