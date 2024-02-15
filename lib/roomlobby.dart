import 'dart:convert';
import 'user.dart';
import 'draft.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class RoomLobby extends StatefulWidget {
  final int room_id;

  RoomLobby({required this.room_id});

  @override
  _RoomLobbyState createState() => _RoomLobbyState(room_id: room_id);
}

class _RoomLobbyState extends State<RoomLobby> {
  final int room_id;
  List<String> users = [];

  _RoomLobbyState({required this.room_id});

  @override
  void initState() {
    super.initState();
    getRoomUsers();
  }

  void getoutRoom() async {
    try {
      final response = await supabase
          .from('rooms')
          .delete()
          .eq('room_id', room_id);
      print('response : $response');
    } catch (e) {
      print('Failed to get room users: $e');
    }
  }

  void getRoomUsers() async {
    try {
      final response = await supabase
          .from('rooms')
          .select()
          .eq('room_id', room_id);
      print('response : $response');
      List<String> newUsers = (jsonDecode(jsonEncode(response[0]['users'])) as List)
          .map((user) => Users(user).toString())
          .toList();
      updateUsers(newUsers);
    } catch (e) {
      print('Failed to get room users: $e');
    }
  }

  void updateUsers(List<String> newUsers) {
    setState(() {
      users = newUsers;
    });
  }

  void draftStart() async {
    try {
      final response = await supabase
          .from('rooms')
          .update({'started': true})
          .eq('room_id', room_id);
      print('response : $response');

      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FantasyLeagueDraft(room_id),),      );
    } catch (e) {
      print('Failed to start draft: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Lobby'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(users[index]),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                child: Text('방 나가기'),
                onPressed: () {
                  // TODO: 방을 나가는 로직을 구현하세요.
                  // TIME: 이건 나중에 구현 (일단 draft부터 완성후)
                },
              ),
              ElevatedButton(
                child: Text('시작'),
                onPressed: () {
                  // TODO: 게임을 시작하는 로직을 구현하세요.
                  draftStart();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}