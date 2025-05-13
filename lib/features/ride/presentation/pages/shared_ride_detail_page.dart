import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:domochat/core/constants.dart';
import 'package:domochat/features/chat/presentation/pages/chat_page.dart';
import 'package:domochat/features/ride/data/models/ride_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedRideDetailPage extends StatelessWidget {
  final _storage = FlutterSecureStorage();
  final RideModel ride;
  SharedRideDetailPage({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали поездки'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[800]!, Colors.blue[600]! ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRouteCard(),
                    const SizedBox(height: 24,),
                    _buildDateTimeSection(),
                    const SizedBox(height: 24,),
                    _buildDescriptionSection(),
                    const SizedBox(height: 24,),
                    _buildAuthorSection(),
                  ],
                ),
              )
          ),
          _buildDiscussButton(context),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLocationRow(
              icon: Icons.my_location_outlined,
              city: ride.departureCity,
              street: ride.departureStreet,
              house: ride.departureHouse,
              label: 'Место отправления',
            ),
            const SizedBox(height: 16,),
            Divider(height: 1, color: Colors.grey[700],),
            const SizedBox(height: 16,),
            _buildLocationRow(
              icon: Icons.location_on_outlined,
              city: ride.arrivalCity,
              street: ride.arrivalStreet,
              house: ride.arrivalHouse,
              label: 'Место прибытия',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String city,
    required String street,
    required String house,
    required String label
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.blue[800],
          size: 28,
        ),
        const SizedBox(width: 12,),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4,),
                Text(
                  '$city, $street, $house',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
        )
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Card(
      elevation: 2,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildDateTimeItem(
              icon: Icons.calendar_today_outlined,
              value: ride.departureTime.substring(0, 10),
            ),
            Container(
              height: 30,
              width: 1,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            _buildDateTimeItem(
              icon: Icons.access_time_outlined,
              value: ride.departureTime.substring(11, 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeItem({
    required IconData icon,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.blue[800],
          ),
          const SizedBox(width: 8,),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Описание',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              ride.description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.4,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage("images/icon_logo_2.png"),
            ),
            const SizedBox(width: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Организатор',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  ride.authorName,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
          label: const Text(
            'Обсудить поездку',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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
                  'participantId': ride.authorId
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
                      recipientName: ride.authorName,
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
}
