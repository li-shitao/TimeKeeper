import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'add_event_screen.dart';
import 'database_helper.dart';
import 'models/event.dart';

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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureEvents = fetchEvents();
          });
        },
        child: Center(
          child: FutureBuilder<List<Event>>(
            future: futureEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No events found.');
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final event = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            event.title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8.0),
                          Text(event.description),
                          const SizedBox(height: 8.0),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '${event.eventTime.toLocal()}'.split(' ')[0],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
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
