import 'dart:io';

import 'package:domochat/core/constants.dart';
import 'package:domochat/features/announcement/presentation/pages/announcements_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CreateAnnouncementPage extends StatefulWidget {
  final String communityId;
  const CreateAnnouncementPage({super.key, required this.communityId});

  @override
  State<CreateAnnouncementPage> createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final _storage = FlutterSecureStorage();
  final String baseUrl = ConstantsLinks.baseUrl;
  List<XFile> _selectedImages = [];

  Future<void> _pickImages() async {
    final List<XFile> images = await ImagePicker().pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    String token = await _storage.read(key: 'token') ?? '';
    if (_formKey.currentState!.validate()) {
      final uri = Uri.parse('$baseUrl/announcements/create');
      final request = http.MultipartRequest('POST', uri);

      request.fields['title'] = _titleController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['price'] = _priceController.text;
      request.fields['community_id'] = widget.communityId;

      for (final image in _selectedImages) {
        final file = await http.MultipartFile.fromPath(
            'images',
            image.path,
        );
        request.files.add(file);
      }

      request.headers['Authorization'] = 'Bearer $token';

      final response = await request.send();
      if (response.statusCode == 201) {
        print("Объявление добавилось");
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AnnouncementsListPage(communityId: widget.communityId,)),
        );
      } else {
        print("Ошибка");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Новое объявление',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.black,),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildMainInfoSection(),
                SizedBox(height: 24,),
                _buildImageUploadSection(),
                SizedBox(height: 32,),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
                'Основная информация',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey
                ),
            ),
            SizedBox(height: 15,),
            _buildTextField(
              controller: _titleController,
              icon: Icons.title_outlined,
              label: 'Заголовок объявления',
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
            _buildTextField(
              controller: _priceController,
              icon: Icons.currency_ruble_outlined,
              label: 'Цена',
              validator: (value) => value!.isEmpty ? 'Введите цену' : null,
            ),
            _buildTextField(
              controller: _descriptionController,
              icon: Icons.description_outlined,
              label: 'Описание',
              maxLines: 4,
              validator: (value) => value!.isEmpty ? 'Добавьте описание' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Фотографии',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey
              ),
            ),
            SizedBox(height: 15,),
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _selectedImages.length) {
                    return GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add_a_photo_outlined, color: Colors.grey[600],),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_selectedImages[index].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.close_outlined, color: Colors.red,),
                            onPressed: () => _removeImage(index),
                          )
                      )
                    ],
                  );
                }
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(
              vertical: 16, horizontal: 20),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800]),
        validator: validator,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
      child: Text('Опубликовать',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white)),
    );
  }
}
