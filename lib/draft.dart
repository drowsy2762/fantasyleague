<<<<<<< HEAD
import 'dart:math';

class Player {
  String name;
  int rank;
  String position;
  String team;

  Player(this.name, this.rank, this.position, this.team);
}

class Draft {
  List<Player> players;
  List<String> teams;
  int currentPick = 0;

  Draft(this.players, this.teams) {
    currentPick = 0;
    players.sort((a, b) => a.rank.compareTo(b.rank));
  }

  Player? getNextPick() {
    // modify the return type to Player?
    if (currentPick >= players.length) {
      return null;
    }

    Player pick = players[currentPick];
    currentPick++;
    return pick;
  }

  void makePick(Player player, String team) {
    player.team = team;
  }

  void trade(Player player1, Player player2) {
    String temp = player1.team;
    player1.team = player2.team;
    player2.team = temp;
  }

  void printDraftBoard() {
    print('Draft Board:');
    for (int i = 0; i < players.length; i++) {
      Player player = players[i];
      String pickNumber = (i + 1).toString().padLeft(2);
      String playerName = player.name.padRight(20);
      String playerPosition = player.position.padRight(5);
      String playerTeam = player.team.padRight(10);
      print('$pickNumber $playerName $playerPosition $playerTeam');
    }
  }
}

void main() {
  List<Player> players = [
    Player('LeBron James', 1, 'SF', ''),
    Player('Kevin Durant', 2, 'SF', ''),
    Player('James Harden', 3, 'SG', ''),
    Player('Anthony Davis', 4, 'PF', ''),
    Player('Giannis Antetokounmpo', 5, 'PF', ''),
    Player('Stephen Curry', 6, 'PG', ''),
    Player('Kawhi Leonard', 7, 'SF', ''),
    Player('Joel Embiid', 8, 'C', ''),
    Player('Nikola Jokic', 9, 'C', ''),
    Player('Luka Doncic', 10, 'PG', ''),
  ];

  List<String> teams = ['Team A', 'Team B', 'Team C', 'Team D'];

  Draft draft = Draft(players, teams);

  while (true) {
    Player? pick = draft.getNextPick();
    if (pick == null) {
      break;
    }

    draft.printDraftBoard();
    print('Current pick: ${draft.currentPick}');
    print('Next pick: ${pick.name}');

    int teamIndex = Random().nextInt(draft.teams.length);
    String team = draft.teams[teamIndex];

    draft.makePick(pick, team);
    print('Pick made: ${pick.name} to $team');
  }
}
=======
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
>>>>>>> 408a80a (일단 main과 draftpage 분리 성공)
