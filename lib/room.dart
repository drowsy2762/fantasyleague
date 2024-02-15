import 'main.dart';

class Room {
  final int id;
  final List<String> users;

  Room(this.id, this.users);

  void addUser(user) {
    users.add(user);
    updateDatabase();
  }

  void removeUser(user) {
    users.remove(user);
    updateDatabase();
  }

  void updateDatabase() {
    try {
      supabase.from('rooms').update({'users': users});
    } catch (e) {
      print('Failed to update database: $e');
    }
  }

  int get numberOfUsers {
    return users.length;
  }
}