
import 'package:domochat/features/chat/domain/entities/message_entity.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>> fetchMessages(String conversationId);
  Future<MessageEntity> sendMessages(MessageEntity message, String conversationId);
}