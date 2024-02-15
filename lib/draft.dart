import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config.dart';
import 'main.dart';

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
  List<String> users = [];
  int currentTurn = 0;

  String get currentUser => users.isNotEmpty ? users[currentTurn] : '';

  void nextTurn() {
    currentTurn = (currentTurn + 1) % users.length;
  }

  Future<void> getRoomUsers(int roomId) async {
    try {
      final response =
          await supabase.from('rooms').select('users').eq('room_id', roomId);
      List<Map<String, dynamic>> newUsers =
          (jsonDecode(jsonEncode(response[0]['users'])) as List)
              .map((user) => jsonDecode(user) as Map<String, dynamic>)
              .toList();
      users = newUsers.map((user) => user['user_uid'] as String).toList();
    } catch (e) {
      print('Failed to get room users: $e');
    }
  }
}

class FantasyLeagueDraft extends StatefulWidget {
  final room_id;

  FantasyLeagueDraft(this.room_id);

  @override
  _FantasyLeagueDraftState createState() => _FantasyLeagueDraftState(room_id);
}

class _FantasyLeagueDraftState extends State<FantasyLeagueDraft> {
  List<Player> players = []; // Add this line인
  List<String> users = [];
  String? selectedUser;
  Player? selectedPlayer;
  String? selectedTeam;
  String? selectedPosition;

  final room_id;
  late final DraftState draftState = DraftState();

  // users는 rooms 테이블에 있는 users 컬럼을 가져와야함

  _FantasyLeagueDraftState(this.room_id);

  @override
  void initState() {
    super.initState();
    initPlayers();
    draftState.getRoomUsers(room_id);
  }

  void getRoomUsers() async {
    try {
      final response =
          await supabase.from('rooms').select('users').eq('room_id', room_id);
      print('response1 : $response');
      List<String> newUsers = (response[0]['users'] as List)
          .map((user) => Users(user).toString())
          .toList();
      users.addAll(newUsers);
      print('users : $users');
    } catch (e) {
      print('Failed to get room users: $e');
    }
  }

  Future<void> initPlayers() async {
    try {
      final response =
      await supabase
          .from('players').select('jurseynumber, name, team, position');

      final data = response as List<Map<String, dynamic>>;
      players = data.map((playerData) => Player(
        playerData['name'] ?? '',
        playerData['id'] ?? '',
        playerData['jurseynumber'].toString() ?? '',
        playerData['team'] ?? '',
        playerData['position'] ?? '',
      )).toList();

      print('players: $players');
    } catch (e) {
      print('Failed to get players: $e');
    }
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
                child: DropdownButton<String>(
                  value: selectedUser,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUser = newValue;
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Draft Order tab
            // Draft Order tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Draft Order',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Text('Pick one player at a time',
                    style: TextStyle(color: Colors.grey)),
                Text('Current turn: ${draftState.currentUser}'),
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
                        items: players.map((player) => player.team).map<DropdownMenuItem<String>>((String value) {
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
                          items: players
                              .where((player) => player.team == selectedTeam)
                              .map((player) => player.position)
                              .toSet()
                              .map<DropdownMenuItem<String>>((String value) {
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
                          items: players
                              .where((player) =>
                                  player.team == selectedTeam &&
                                  player.position == selectedPosition)
                              .map<DropdownMenuItem<Player>>((Player value) {
                            return DropdownMenuItem<Player>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // My Team tab
            Center(child: Text('No content')),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
                onPressed: () {
                  setState(() {
                    draftState.nextTurn();
                  });
                },
                child: Text('Next Turn'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
