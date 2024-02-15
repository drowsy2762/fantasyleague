import 'main.dart';
import 'dart:convert';

// 이건 유저가 지금 어떤것을 소유하고 있나 알려주는건데 필요한가?
// 필요없는거같은데 기록을 어떤식으로 해야하지?
// TODO: user.dart

class Users {
  final String user_uid;
  List<int> room_id = [];

  Users(this.user_uid) {
    supabase
        .from('users')
        .select('room_id')
        .eq('user_uid', user_uid)
        .then((response) {
          room_id = (response as List).map((item) => item['room_id'] as int).toList();
    });
  }

  Future<void> joinRoom(int room_id) async {
    this.room_id.add(room_id);
    await updateDatabase();
  }

  Future<void> leaveRoom(int room_id) async {
    this.room_id.remove(room_id);
    await updateDatabase();
  }

  Future<void> updateDatabase() async {
    try {
      await supabase.from('users').update({'room_id': room_id});
    } catch (e) {
      print('Failed to update database: $e');
    }
  }

  @override
  String toString() {
    return user_uid;
  }
}