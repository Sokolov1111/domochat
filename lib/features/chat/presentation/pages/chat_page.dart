import 'package:domochat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:domochat/features/chat/presentation/bloc/chat_event.dart';
import 'package:domochat/features/chat/presentation/bloc/chat_state.dart';
import 'package:domochat/features/community/data/models/community_model.dart';
import 'package:domochat/features/community/presentation/pages/community_members_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatPage extends StatefulWidget {
  final CommunityModel community;
  final String conversationId;

  const ChatPage({
    super.key,
    required this.community,
    required this.conversationId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final _storage = FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();
  String userId = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatBloc>(context).add(LoadMessageEvent(widget.conversationId));
    fetchUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  fetchUserId() async {
    userId = await _storage.read(key: 'userId') ?? '';
    setState(() {
      userId = userId;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(
        SendMessageEvent(widget.conversationId, content),
      );
      WidgetsBinding.instance.addPostFrameCallback((_){
        _scrollToBottom();
      });
    }
    _messageController.clear();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.community.adressStreet}, ${widget.community.adressHouse} (Общий чат)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CommunityMembersPage(communityId: widget.community.id),
                  ),
                );
              },
              icon: Icon(Icons.people_alt_outlined),
          ),

        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: BlocConsumer<ChatBloc, ChatState> (
                builder: (context, state) {
                  if (state is ChatLoadingState) {
                    return Center(child: CircularProgressIndicator(),);
                  } else if(state is ChatLoadedState) {
                    return
                        ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(20),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];
                            final isSentMessage = message.senderId == userId;
                            if (isSentMessage) {
                              return _buildSentMessage(context, message.content, message.createdAt);
                            } else {
                              return _buildReceivedMessage(context, message.content, message.createdAt);
                            }
                          }
                        );
                  } else if (state is ChatErrorState) {
                    return Center(child: Text(state.message),);
                  }
                  return Center(child: Text("No messages found"),);
                }, listener: (context, state) {
                  if (state is ChatLoadedState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  }
              },
              )
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context, String message, String createdAt) {
   // DateTime dateTime = DateTime.parse(createdAt.replaceAll('', 'T'));
   // String time = "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4,),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  createdAt,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, String message, String createdAt) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                createdAt,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Написать сообщение...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}