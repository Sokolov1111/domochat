import 'dart:convert';

import 'package:domochat/core/constants.dart';
import 'package:domochat/utils/community_codec.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JoinCommunityPage extends StatefulWidget {
  const JoinCommunityPage({super.key});

  @override
  State<JoinCommunityPage> createState() => _JoinCommunityPageState();
}

class _JoinCommunityPageState extends State<JoinCommunityPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final _storage = FlutterSecureStorage();
  String _selectedResidentStatus = 'owner';
  bool _isLoading = false;


  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      //final communityId = CommunityCodec.decode(_codeController.text.trim());

      final response = await http.post(
        Uri.parse('${ConstantsLinks.baseUrl}/communities/join'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _storage.read(key: 'token')}'
        },
        body: jsonEncode({
          'community_id': _codeController.text,
          'full_name': _fullNameController.text,
          'apartment': _apartmentController.text,
          'resident_status': _selectedResidentStatus,
        }),
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заявка успешно отправлена!'))
        );
      } else if (response.statusCode == 400 &&
          responseBody['error']?.contains('already have')) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Вы уже отправили заявку в это сообщество'))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonDecode(response.body)['error']))
        );
      }
    }
    on FormatException {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный код сообщества'))
      );
    } catch (e) {
      print('Error submitting request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e is FormatException
              ? 'Неверный формат данных'
              : 'Ошибка соединения: ${e.toString()}'))
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вступление в сообщество'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildCodeInputSection(),
              const SizedBox(height: 24,),
              _buildUserInfoSection(),
              const SizedBox(height: 32,),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInputSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Код сообщества',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 15,),
          TextFormField(
            controller: _codeController,
            decoration: InputDecoration(
              labelText: 'Введите 8-значный код',
              hintText: 'Пример: ABCD1111',
              prefixIcon: const Icon(Icons.group_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите код сообщества';
              }
              return null;
            },
          ),
          const SizedBox(height: 10,),
          Text(
            'Код можно получить у адмнистратора или другого участника сообщества',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Ваши данные',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 15,),
            TextFormField(
              controller: _fullNameController,
              decoration: _buildInputDecoration('ФИО', Icons.person_outline),
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
            const SizedBox(height: 12,),
            TextFormField(
              controller: _apartmentController,
              decoration: _buildInputDecoration('Квартира', Icons.apartment_outlined),
            ),
            const SizedBox(height: 12,),
            DropdownButtonFormField<String>(
                value: _selectedResidentStatus,
                items: const [
                  DropdownMenuItem(
                      value: 'owner',
                      child: Text('Собственник'),
                  ),
                  DropdownMenuItem(
                    value: 'tenant',
                    child: Text('Арендатор'),
                  ),
                ],
                decoration: _buildInputDecoration(
                  'Статус проживания',
                  Icons.assignment_ind_outlined
                ),
                onChanged: (value) => setState(() => _selectedResidentStatus = value!)
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey)
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16)
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
        onPressed: _isLoading ? null : _submitRequest,
        icon: _isLoading
            ? const SizedBox.shrink()
            : const Icon(Icons.send_outlined, size: 24,),
        label:  _isLoading
            ? const CircularProgressIndicator()
            : const Text('Отправить заявку', style: TextStyle(fontSize: 16),),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
    );
  }
}
