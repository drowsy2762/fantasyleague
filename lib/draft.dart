import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config.dart';

class Player {
  final String name;
  final String id;
  final String jurseynum;
  final String team;
  final String position;

  Player(this.name, this.id, this.jurseynum, this.team, this.position);

  @override
  String toString() {
    return 'Player(name: $name, id: $id, jurseynum: $jurseynum, team: $team, position: $position)';
  }
}

class DraftState {
  List<User> users;
  int currentTurn;

  DraftState(this.users, this.currentTurn);

  User get currentUser => users[currentTurn];

  void nextTurn() {
    currentTurn = (currentTurn + 1) % users.length;
  }
}


class User {
  final String name;
  final List<Player> team = [];

  User(this.name);

  Future<void> draftPlayer(Player player) {
    team.add(player);
    return SupabaseClient(Config.supabaseUrl, Config.supabaseKey)
        .from('teams')
        .upsert({'userId': name, 'playerName': player.name});
  }
}

class FantasyLeagueDraft extends StatefulWidget {
  final DraftState draftState;

  FantasyLeagueDraft(this.draftState);

  @override
  _FantasyLeagueDraftState createState() => _FantasyLeagueDraftState();
}

class _FantasyLeagueDraftState extends State<FantasyLeagueDraft> {
  List<Player> players = []; // Add this line
  List<User> users = [User('User 1'), User('User 2'), User('User 3')]; // Placeholder user data
  Player? selectedPlayer;
  String? selectedTeam;
  String? selectedPosition;

  @override
  void initState() {
    super.initState();
    initPlayers();
    loadPlayers();
  }

  Future<void> initPlayers() async {
    final response = await SupabaseClient(Config.supabaseUrl, Config.supabaseKey)
        .from('players')
        .select('jurseynumber, name, team, position');

    print(response);
  }

  Future<void> loadPlayers() async {
    final response = await SupabaseClient(Config.supabaseUrl, Config.supabaseKey)
        .from('players')
        .select('jurseynumber, name, team, position');

    final data = response as List<Map<String, dynamic>>;

  }

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
              Tab(
                child:
                DropdownButton<Player>(
                  value: selectedPlayer,
                  onChanged: (Player? newValue) {
                    setState(() {
                      selectedPlayer = newValue;
                    });
                  },
                  items: users[0].team.map<DropdownMenuItem<Player>>((Player value) {
                    return DropdownMenuItem<Player>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ),
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
                Text('Current turn: ${widget.draftState.currentUser.name}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.draftState.nextTurn();
                    });
                  },
                  child: Text('Next Turn'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Team selection
                      DropdownButton<String>(
                        value: selectedTeam,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTeam = newValue;
                            selectedPosition = null;
                            selectedPlayer = null;
                          });
                        },
                        items: players.map((player) => player.team).toSet().map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      if (selectedTeam != null)
                        DropdownButton<String>(
                          value: selectedPosition,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPosition = newValue;
                              selectedPlayer = null;
                            });
                          },
                          items: players.where((player) => player.team == selectedTeam).map((player) => player.position).toSet().map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      if (selectedPosition != null)
                        DropdownButton<Player>(
                          value: selectedPlayer,
                          onChanged: (Player? newValue) {
                            setState(() {
                              selectedPlayer = newValue;
                            });
                          },
                          items: players.where((player) => player.team == selectedTeam && player.position == selectedPosition).map<DropdownMenuItem<Player>>((Player value) {
                            return DropdownMenuItem<Player>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {}, // Handle player skip action
                      child: Text('Skip'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: selectedPlayer == null ? null : () async {
                        await users[0].draftPlayer(selectedPlayer!);
                        setState(() {
                          selectedPlayer = null;
                        });
                      },
                      child: Text('Draft'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
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