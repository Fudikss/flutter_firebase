import 'package:flutter/material.dart';
import 'package:flutter_firebase/chat-room-screen.dart';

class ChatListWidget extends StatelessWidget {
  const ChatListWidget({Key? key, required this.uidList, required this.uid, required this.name, required this.rid, required this.rname}) : super(key: key);

  final List<dynamic> uidList;
  final String uid;
  final String name;
  final String rid;
  final String rname;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatRoomScreen(rname: rname, rid: rid, uid: uid, name: name))
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              child: Text("P"),
            ),
            SizedBox(width: 16,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rname, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(rid)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
