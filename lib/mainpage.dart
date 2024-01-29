// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'draft.dart';
//
// class SupabaseAuthRequiredWidget {
//   final Widget child;
//
//   const SupabaseAuthRequiredWidget({required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<SupabaseUser >(
//       stream: Supabase.instance.client.auth.userChanges,
//       builder: (context, snapshot) {
//         if (snapshot.data == null) {
//           return Login();
//         } else {
//           return child;
//         }
//       },
//     );
//   }
// }
//
// class SupabaseUser {
//
// }
//
// class MyApp extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fantasy League'),
//       ),
//       body: Center(
//         child: MaterialButton(
//           color: Colors.blue,
//           textColor: Colors.white,
//           child: Text('Go to Draft Page'),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) =>
//                   SupabaseAuthRequiredWidget(
//                     child: DraftPage(),
//                   )),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
