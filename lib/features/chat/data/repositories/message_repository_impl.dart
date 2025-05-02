
import 'package:domochat/features/chat/data/datasources/message_remote_data_source.dart';
import 'package:domochat/features/chat/domain/entities/message_entity.dart';
import 'package:domochat/features/chat/domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MessageEntity>> fetchMessages(String conversationId) async {
    return await remoteDataSource.fetchMessages(conversationId);
  }

  @override
  Future<MessageEntity> sendMessages(MessageEntity message, String conversationId) async {
    return await remoteDataSource.sendMessages(message, conversationId);
  }



}