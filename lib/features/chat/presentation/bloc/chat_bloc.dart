
import 'dart:async';

import 'package:domochat/core/socket_service.dart';
import 'package:domochat/features/chat/domain/entities/message_entity.dart';
import 'package:domochat/features/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:domochat/features/chat/presentation/bloc/chat_event.dart';
import 'package:domochat/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchMessagesUseCase fetchMessagesUseCase;

  final List<MessageEntity> _messages = [];
  final SocketService _socketService = SocketService();
  final _storage = FlutterSecureStorage();

  ChatBloc({required this.fetchMessagesUseCase}) : super(ChatLoadingState()) {
    on<LoadMessageEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessageEvent>(_onReceiveMessage);
  }

  Future<void> _onLoadMessages(LoadMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    try {
      final messages = await fetchMessagesUseCase(event.conversationId);
      _messages.clear();
      _messages.addAll(messages);


      await _socketService.connect();
      _socketService.socket.emit('joinConversation', event.conversationId);

      _socketService.onNewMessage((data) {
        add(ReceiveMessageEvent(data));
      });
      emit(ChatLoadedState(List.from(_messages)));
    } catch (error) {
      print(error);
      emit(ChatErrorState('Failed to load messages'));
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    String userId = await _storage.read(key: 'userId') ?? '';
    final newMessage = {
      'conversationId' : event.conversationId,
      'content': event.content,
      'senderId': userId,
    };
    _socketService.socket.emit('sendMessage', newMessage);
  }

  Future<void> _onReceiveMessage(ReceiveMessageEvent event, Emitter<ChatState> emit) async {
    try {
      print("step2 - receive event called");
      print(event.message);
      final message = MessageEntity(
        id: event.message['id'],
        conversationId: event.message['conversation_id'],
        senderId: event.message['sender_id'],
        content: event.message['content'],
        createdAt: event.message['created_at'],
      );
      _messages.add(message);
      emit(ChatLoadedState(List.from(_messages)));
    } catch (e) {
      print('Error parsing message: $e');
    }
  }
}