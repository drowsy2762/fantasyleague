import 'package:fantasyleague/roomlobby.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fantasyleague/main.dart';
import 'package:fantasyleague/room.dart';
import 'package:fantasyleague/user.dart';
import 'dart:convert';
import 'package:fantasyleague/colors.dart' as colors;

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final List<Room> rooms = [];

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  Future<void> getRooms() async {
    try {
      final response =
      await supabase.from('rooms').select().eq('started', false);
      print('response : $response');

      List<Room> newRooms = []; // 새로운 방 리스트를 생성합니다.

      for (var roomData in response) {
        int roomId = roomData['room_id'];
        List<String> users = (jsonDecode(jsonEncode(roomData['users'])) as List)
            .map((user) => Users(user).toString())
            .toList();

        final room = Room(roomId, users);
        newRooms.add(room); // 새로운 방 리스트에 방을 추가합니다.
      }

      setState(() {
        this.rooms.clear();
        this.rooms.addAll(newRooms); // 기존의 방 리스트를 새로운 방 리스트로 교체합니다.
      });
    } catch (e) {
      print('Failed to get rooms: $e');
    }
    print(rooms);
  }
  // 방을 생성하는 함수입니다.
  Future<int> createRoom(String roomName) async {
    int roomId = -1;
    try {
      final response =
          await supabase.from('rooms').select().count(CountOption.exact);
      final count = response.count;
      final room = Room(count, []);

      final User? supabaseUser = supabase.auth.currentUser;
      if (supabaseUser != null) {
        final users = Users(supabaseUser.id);
        users.joinRoom(count);
        room.addUser(users.toString());
      }
      
      await supabase.from('rooms').insert({
        'room_id': count,
        'users': room.users.map((user) => user.toString()).toList()
      });

      setState(() {
        rooms.add(room);
      });

      roomId = count;

      print(response);

    } catch (e) {
      print('Failed to create room: $e');
    }

    return roomId;
  }
  // 방에 참가하는 함수입니다.
  Future<void> joinRoom(int roomId) async {
    try {
      final User? supabaseUser = supabase.auth.currentUser;
      final response = await supabase
          .from('rooms')
          .select()
          .eq('room_id', roomId)
          .eq('started', false)
          .single();

      if (response != null && response is Map<String, dynamic>) {
        Set<String> updateusers = (response['users'] as List<dynamic>)
            .map((user) => user.toString())
            .toSet();
        updateusers.add(supabaseUser!.id);
        print('updateusers : $updateusers');
        await supabase
            .from('rooms')
            .update({'users': updateusers.toList()})
            .eq('room_id', roomId);
      }
    } catch (e) {
      print('Failed to join room: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main page'),
      ),
      body: RefreshIndicator(
        onRefresh: getRooms,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to Fantasy League'),
              ElevatedButton(
                onPressed: () async {
                  int roomId = await createRoom('Room Name');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoomLobby(room_id: roomId)),
                  );
                },
                child: Text('Create Room'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return Card(
                      // Set the shape of the card using a rounded rectangle border with a 8 pixel radius
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Set the clip behavior of the card
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      // Define the child widgets of the card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Display an image at the top of the card that fills the width of the card and has a height of 160 pixels
                          Image.asset(
                            'assets/images/lobby.jpg',
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                          // Add a container with padding that contains the card's title, text, and buttons
                          Container(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Display the card's title using a font size of 24 and a dark grey color
                                Text(
                                  "Room ${room.id}",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                // Add a space between the title and the text
                                Container(height: 10),
                                // Display the card's text using a font size of 15 and a light grey color
                                Text(
                                  "Users: (${room.numberOfUsers} users)",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                // Add a row with two buttons spaced apart and aligned to the right side of the card
                                Row(
                                  children: <Widget>[
                                    // Add a spacer to push the buttons to the right side of the card
                                    const Spacer(),
                                    // Add a text button labeled "EXPLORE" with transparent foreground color and an accent color for the text
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.transparent,
                                      ),
                                      child: const Text(
                                        "Join Room",
                                        style: TextStyle(
                                            color: colors.AppColors.marinBlue),
                                      ),
                                      onPressed: () {
                                        joinRoom(room.id);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RoomLobby(room_id: room.id)),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Add a small space between the card and the next widget
                          Container(height: 5),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
