
import 'dart:ui';

import 'package:domochat/features/auth/data/models/user_model.dart';
import 'package:domochat/features/auth/domain/entities/user_entity.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_event.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String avatarUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мой профиль'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: Icon(Icons.settings_outlined)
          )
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState> (
        builder: (context, state) {
          if (state is AuthSuccess) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAvatarSection(context, state.user),
                  SizedBox(height: 24,),
                  _buildProfileCard(context, state.user),
                  SizedBox(height: 24,),
                  _buildStateSection(),
                  SizedBox(height: 24,),
                  _buildActionSection(context),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context, UserModel user) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt_outlined, color: Colors.white,),
                onPressed: () => _changePhoto(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 8,),
        Text(
          user.username,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          user.email,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, UserModel user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthSuccess) {
                    return _buildEditableField(
                      title: 'Имя',
                      value: state.user.username,
                      onEdit: () => _editUsernameField(context, state.user)
                    );
                  }
                  return CircularProgressIndicator();
                },
                listener: (context, state) {
                  if (state is UsernameUpdatedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Имя успешно изменено!')),
                    );
                  }
                }
            ),
            Divider(),
            _buildEditableField(
              title: 'Email',
              value: user.email,
              onEdit: () => {},
            ),
            Divider(),
            _buildInfoField(
              title: 'Дата регистрации',
              value: '11 12 2002'
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(color: Colors.grey),),
      subtitle: Text(value, style: TextStyle(fontSize: 16),),
      trailing: IconButton(
        icon: Icon(Icons.edit_outlined, color: Colors.blue,),
        onPressed: onEdit,
      ),
    );
  }

  Widget _buildInfoField({
    required String title,
    required String value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(color: Colors.grey),),
      subtitle: Text(value, style: TextStyle(fontSize: 16),),
    );
  }

  Widget _buildStateSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('2', 'Комьюнити'),
            _buildStatItem('0', 'Объявлений'),
            _buildStatItem('27', 'Личных чатов'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        SizedBox(height: 4,),
        Text(label, style: TextStyle(color: Colors.grey),),
      ],
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.favorite_outline, color: Colors.red,),
          title: Text('Избранное'),
          onTap: (){},
        ),
        ListTile(
          leading: Icon(Icons.help_outline, color: Colors.green,),
          title: Text('Помощь'),
          onTap: (){},
        ),
        SizedBox(height: 16,),
        ElevatedButton(
            onPressed: () => _logout(context),
            child: Text('Выйти из аккаунта'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100])
        ),
      ],
    );
  }

  void _changePhoto(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt_outlined),
              title: Text('Сделать фото'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.photo_album_outlined),
              title: Text('Выбрать из галереи'),
              onTap: () {},
            ),
          ],
        )
    );
  }

  void _editUsernameField(BuildContext context, UserModel user) {
    final TextEditingController controller = TextEditingController(
      text: user.username,
    );

    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Изменить имя'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Новое имя',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Отмена'),
            ),
            TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    BlocProvider.of<AuthBloc>(context).add(
                      UpdateUsernameEvent(newUsername: controller.text)
                    );
                    Navigator.pop(ctx);
                  }
                },
                child: Text('Сохранить'),
            ),
          ],
        )
    );
  }

  void _logout(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Выйти из аккаунта?'),
          content: Text('Вы уверены, что хотите выйти?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                //context.read<AuthBloc>().add(LogoutEvent())
              },
              child: Text('Выйти', style: TextStyle(color: Colors.red),),
            )
          ],
        )
    );
  }
}