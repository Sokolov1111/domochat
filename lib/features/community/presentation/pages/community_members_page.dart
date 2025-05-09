import 'package:domochat/features/community/domain/entities/member_entity.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_members_list/members_list_bloc.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_members_list/members_list_event.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_members_list/members_list_state.dart';
import 'package:flutter/material.dart';
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
                onPressed: () {},
              ),
            ),
          );
        }
    );
  }
}
