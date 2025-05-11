import 'dart:convert';

import 'package:domochat/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CommunityManagementPage extends StatefulWidget {
  final String communityId;
  const CommunityManagementPage({super.key, required this.communityId});

  @override
  State<CommunityManagementPage> createState() => _CommunityManagementPageState();
}

class _CommunityManagementPageState extends State<CommunityManagementPage> {
  final _storage = const FlutterSecureStorage();
  List<dynamic> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchJoinRequests();
  }

  Future<void> _fetchJoinRequests() async {
    final token = await _storage.read(key: 'token');
    try {
      final response = await http.get(
        Uri.parse('${ConstantsLinks.baseUrl}/communities/${widget.communityId}/requests'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        setState(() {
          _requests = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching requests: $e');
    }
  }

  Future<void> _processRequest(String requestId, String status) async {
    final token = await _storage.read(key: 'token');
    try {
      final response = await http.post(
        Uri.parse('${ConstantsLinks.baseUrl}/communities/${widget.communityId}/requests/process'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'request_id': requestId,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _requests.removeWhere((req) => req['id'] == requestId);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка обработки запроса'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление сообществом'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : _requests.isEmpty
            ? const Center(child: Text('Нет новых заявок'),)
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _requests.length,
                itemBuilder: (context, index) {
                  final request = _requests[index];
                  return _buildRequestCard(request);
                }
            )
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('ФИО', request['full_name'], Icons.person_outline),
            _buildInfoRow('Квартира', request['apartment'], Icons.house_outlined),
            _buildInfoRow('Статус', _parseResidentStatus(request['resident_status']), Icons.assignment_ind_outlined),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  'Отклонить',
                  Colors.red,
                  Icons.close_outlined,
                  () => _processRequest(request['id'], 'rejected'),
                ),
                _buildActionButton(
                  'Одобрить',
                  Colors.green,
                  Icons.check_outlined,
                      () => _processRequest(request['id'], 'approved'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12,),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500),),
          Text(value.isNotEmpty ? value : 'не указано'),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        icon: Icon(icon, size: 20,),
        label: Text(text),
    );
  }

  String _parseResidentStatus (String status) {
    return {
      'owner' : 'Собственник',
      'tenant' : 'Арендатор',
      'relative' : 'Родственник',
    }[status] ?? 'Не указан';
  }
}
