
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> saveMessage(String text, String? imageUrl) async {
  await supabase.from('messages').insert({
    'text': text,
    'image_url': imageUrl,
    'user_id': supabase.auth.currentUser!.id,
  });
}
