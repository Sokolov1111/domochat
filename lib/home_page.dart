import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final String _selectedCommunity = "My house";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _globalKey.currentState?.openDrawer(),
        ),
        title: Text(_selectedCommunity),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
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
              title: 'Create a community',
              color: Colors.blue,
              onTap: () => _createCommunity(),
            ),
            const SizedBox(height: 16,),
            _buildActionCard(
              icon: Icons.login,
              title: 'Join to community',
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: const Text("Sokolov Ivan"), 
              accountEmail: const Text("st. Dachnaya 8,"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJxo2NFiYcR35GzCk5T3nxA7rGlSsXvIfJwg&s"),

              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
              ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {},
          ),
          const Divider(),
          const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'My community',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
          ),
          ExpansionTile(
              leading: const Icon(Icons.apartment),
              title: const Text('House №8'),
              children: [
                _buildCommunityItem('Общий чат', Icons.chat),
                _buildCommunityItem('Важное', Icons.announcement),
                _buildCommunityItem('Доска объявлений', Icons.list_alt),
                _buildCommunityItem('Совместные поездки', Icons.directions_car),
              ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.apartment),
            title: const Text('House №9'),
            children: [
              _buildCommunityItem('Общий чат', Icons.chat),
              _buildCommunityItem('Важное', Icons.announcement),
              _buildCommunityItem('Доска объявлений', Icons.list_alt),
              _buildCommunityItem('Совместные поездки', Icons.directions_car),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityItem(String title, IconData icon) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20,),
      title: Text(title),
      onTap: () {},
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
          backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJxo2NFiYcR35GzCk5T3nxA7rGlSsXvIfJwg&s"),
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

  void _createCommunity() {}

  void _joinCommunity() {}
}
