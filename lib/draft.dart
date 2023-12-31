import 'package:flutter/material.dart';

class FantasyLeagueDraft extends StatefulWidget {
  @override
  _FantasyLeagueDraftState createState() => _FantasyLeagueDraftState();
}

class _FantasyLeagueDraftState extends State<FantasyLeagueDraft> {
  List<String> users = ['User 1', 'User 2', 'User 3']; // Placeholder user data
  String? selectedPlayer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fantasy League Draft'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back navigation
            },
          ),
          Text('12:30', style: TextStyle(color: Colors.grey)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Draft Order', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Text('Pick one player at a time', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(),
                  title: Text(users[index]),
                  subtitle: Text('Turn: Pick player'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedPlayer,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPlayer = newValue;
                });
              },
              items: users.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {}, // Handle player skip action
                child: Text('Skip'),
              ),
              ElevatedButton(
                onPressed: () {}, // Handle next player action
                child: Text('Draft'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {}, // Handle go home action
                child: Text('Home'),
              ),
              TextButton(
                onPressed: () {}, // Handle opening favorites
                child: Text('Favorites'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}