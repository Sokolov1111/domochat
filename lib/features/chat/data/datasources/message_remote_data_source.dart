
import 'dart:convert';

import 'package:domochat/core/constants.dart';
import 'package:domochat/features/chat/data/models/message_model.dart';
import 'package:domochat/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MessageRemoteDataSource {
  final String baseUrl = ConstantsLinks.baseUrl;
  final _storage = FlutterSecureStorage();

  Future<List<MessageEntity>> fetchMessages(String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/messages/$conversationId'),
      headers: {'Authorization': 'Bearer $token'}
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch Messages');
    }
  }

  Future<MessageEntity> sendMessages(MessageEntity message, String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';
    String senderId = await _storage.read(key: 'userId') ?? '';
    final response = await http.post(
      Uri.parse('$baseUrl/messages/$conversationId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'content': message.content}),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return MessageEntity(
        id: data['id'],
        conversationId: conversationId,
        senderId: senderId,
        content: message.content,
        createdAt: data['created_at'],
      );
    } else {
      throw Exception('Failed to send message: ${response.body}');
    }
  }

}