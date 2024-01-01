import 'package:flutter/material.dart';

class FantasyLeagueDraft extends StatefulWidget {
  @override
  _FantasyLeagueDraftState createState() => _FantasyLeagueDraftState();
}

class Player {
  final String name;

  Player(this.name);
}

class User {
  final String name;
  final List<Player> team = [];

  User(this.name);
}

class _FantasyLeagueDraftState extends State<FantasyLeagueDraft> {
  List<String> users = ['User 1', 'User 2', 'User 3']; // Placeholder user data
  String? selectedPlayer;
  String? selectedTab;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fantasy League Draft'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Draft Order'),
              Tab(text: 'Player Draftnow'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Draft Order tab
            Column(
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
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey, // background
                        onPrimary: Colors.white, // foreground
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {}, // Handle next player action
                      child: Text('Draft'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey, // background
                        onPrimary: Colors.white, // foreground
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // My Team tab
            Center(child: Text('No content')),
          ],
        ),
      ),
    );
  }
}