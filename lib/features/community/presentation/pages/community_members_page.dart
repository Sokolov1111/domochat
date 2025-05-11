import 'dart:convert';

import 'package:domochat/core/constants.dart';
import 'package:domochat/features/chat/presentation/pages/chat_page.dart';
import 'package:domochat/features/community/domain/entities/member_entity.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_members_list/members_list_bloc.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_members_list/members_list_event.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_members_list/members_list_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CommunityMembersPage extends StatefulWidget {
  final String communityId;
  const CommunityMembersPage({super.key, required this.communityId});

  @override
  State<CommunityMembersPage> createState() => _CommunityMembersPageState();
}

class _CommunityMembersPageState extends State<CommunityMembersPage> {
  final _storage = FlutterSecureStorage();
  String userId = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MembersListBloc>(context).add(FetchMembers(communityId: widget.communityId));
    fetchUserId();
  }

  fetchUserId() async {
    userId = await _storage.read(key: 'userId') ?? '';
    setState(() {
      userId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Участники сообщества',
          style: TextStyle(
            color: Colors.blue[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: BlocBuilder<MembersListBloc, MembersListState>(
        builder: (context, state) {
          if (state is MembersListLoading) {
            return Center(child: CircularProgressIndicator(),);
          } else if (state is MembersListLoaded) {
            if (state.membersList.isEmpty) {
              return Center(child: Text('Нет участников'),);
            }
            return _buildMembersItem(state.membersList);
          } else if (state is MembersListError) {
            return Center(
              child: Text('Ошибка загрузки ${state.message}'),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMembersItem(List<MemberEntity> members)  {
    return ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          final Map<String, String> status = {
            "owner" : "Владелец",
            "tenant" : "Арендатор"
          };
          String name = member.fullName;
          if(member.userId == userId) {
            name += ' (Вы)';
          }
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage("images/icon_logo_2.png"),
              ),
              title: Text(
                name
              ),
              subtitle: Text(
                'кв.${member.apartment} (${status[member.residentStatus]})'
              ),
              trailing: IconButton(
                icon: const Icon(Icons.message_outlined),
                onPressed: () async {
                  final token = await _storage.read(key: 'token');
                  final currentUserId = await _storage.read(key: 'userId');

                  if (currentUserId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ошибка авторизации'))
                    );
                    return;
                  }
                  try {
                    final response = await http.post(
                      Uri.parse('${ConstantsLinks.baseUrl}/conversations/private'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode({
                        'participantId': member.userId
                      }),
                    );

                    if (response.statusCode == 200 || response.statusCode == 201) {
                      final data = jsonDecode(response.body);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  conversationId: data['conversationId'],
                                  isPrivateChat: true,
                                  recipientName: member.fullName,
                              ),
                          ),
                      );
                    } else {
                      throw Exception('Ошибка сервера: ${response.statusCode}');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка создания чата: ${e.toString()}'))
                    );
                  }
                },
              ),
            ),
          );
        }
    );
  }
}
