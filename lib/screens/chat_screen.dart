
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final client = Supabase.instance.client;

  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    await client.from('messages').insert({
      'text': text,
      'user_id': client.auth.currentUser!.id,
    });
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messages = client.from('messages').stream(primaryKey: ['id']).order('created_at');

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: messages,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final data = snapshot.data!;
                return ListView(
                  children: data.map<Widget>((msg) {
                    return ListTile(title: Text(msg['text']));
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: messageController, decoration: const InputDecoration(hintText: "Type message..."))),
                IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
