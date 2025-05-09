import 'package:domochat/features/announcement/presentation/pages/announcements_list_page.dart';
import 'package:domochat/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_state.dart';
import 'package:domochat/features/auth/presentation/pages/profile_page.dart';
import 'package:domochat/features/chat/presentation/pages/chat_page.dart';
import 'package:domochat/features/community/data/models/community_model.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_list/community_list_bloc.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_list/community_list_event.dart';
import 'package:domochat/features/community/presentation/bloc/bloc_load_list/community_list_state.dart';
import 'package:domochat/features/resource/presentation/pages/resources_page.dart';
import 'package:domochat/features/trip/presentation/pages/trip_requests_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final String _selectedCommunity = "My house";
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
   super.initState();
   BlocProvider.of<CommunityListBloc>(context).add(FetchCommunities());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _globalKey.currentState?.openDrawer(),
        ),
        title: Text(
            "Добро пожаловать в Domochat",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active_outlined),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildActionCard(
              icon: Icons.group_add,
              title: 'Создать сообщество',
              color: Colors.blue,
              onTap: () => {
               Navigator.pushNamedAndRemoveUntil(context, '/createCommunityPage', (route) => false)
              },
            ),
            const SizedBox(height: 16,),
            _buildActionCard(
              icon: Icons.login,
              title: 'Присоединиться к сообществу',
              color: Colors.blue,
              onTap: () => _joinCommunity(),
            ),
            const SizedBox(height: 24,),
            const Text(
              'Активные объявления',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemBuilder: (context, index) => _buildNewsItem(index),
                    itemCount: 5,
                ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDrawer() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("error")),
                  );
                }
                if (state is AuthLoading) {
                  return Center(child: CircularProgressIndicator(),);
                }
                if (state is AuthSuccess) {
                  return UserAccountsDrawerHeader(
                    accountName: Text(state.user.username),
                    accountEmail: Text(state.user.email),
                    currentAccountPicture: const CircleAvatar(
                        backgroundImage: AssetImage("images/icon_logo_1.png")
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade800,
                    ),
                  );
                }
                return Center(child: Text('Ошибка загрузки'),);
              }
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
            ),
            const Divider(),
            const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'My community',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ),
            BlocBuilder<CommunityListBloc, CommunityListState>(
              builder: (context, state) {
                if (state is CommunityListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CommunityListLoaded) {
                  if (state.communityList.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Нет созданных сообществ"),
                    );
                  }
                  return Column(
                      children: state.communityList.map((community) =>
                          ExpansionTile(
                            leading: const Icon(Icons.apartment),
                            title: Text("${community.adressStreet}, ${community.adressHouse}"),
                            children: [
                              _buildCommunityItem(
                                  'Общий чат',
                                  Icons.chat,
                                  () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      ChatPage(community: community as CommunityModel, conversationId: community.conversationsId[0])
                                    ));
                                  },
                              ),
                              _buildCommunityItem('Важное', Icons.announcement, () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    ResourcesPage(communityId: community.id)
                                ));
                              }),
                              _buildCommunityItem('Доска объявлений', Icons.list_alt, (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    AnnouncementsListPage(communityId: community.id,)
                                ));
                              }),
                              _buildCommunityItem('Совместные поездки', Icons.directions_car, (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    TripRequestsPage()
                                ));
                              }),
                            ],
                          )
                      ).toList(),
                  );
                } else if (state is CommunityListError) {
                  return Text(state.message);
                }
                return const SizedBox.shrink();
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityItem(String title, IconData icon, void Function()? _onTap) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20,),
      title: Text(title),
      onTap: _onTap,
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: color,),
              const SizedBox(width: 16,),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsItem(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage("images/icon_logo_2.png"),
        ),
        title: const Text("Продам стол"),
        subtitle: const Text("В отличном состоянии,торг"),
        trailing: IconButton(
          icon: const Icon(Icons.message),
          onPressed: () {},
        ),
      ),
    );
  }

  void _joinCommunity() {}
}
