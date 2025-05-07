import 'package:domochat/features/community/presentation/widgets/build_submit_button.dart';
import 'package:domochat/features/resource/presentation/bloc/resource_bloc.dart';
import 'package:domochat/features/resource/presentation/bloc/resource_event.dart';
import 'package:domochat/features/resource/presentation/bloc/resource_state.dart';
import 'package:domochat/features/resource/presentation/pages/resources_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateResourcePage extends StatefulWidget {
  final String communityId;
  const CreateResourcePage({super.key, required this.communityId});

  @override
  State<CreateResourcePage> createState() => _CreateResourcePageState();
}

class _CreateResourcePageState extends State<CreateResourcePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final _storage = FlutterSecureStorage();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _onCreate() {
    BlocProvider.of<ResourceBloc>(context).add(
      CreateResourceSubmitted(
          communityId: widget.communityId,
          title: _titleController.text,
          description: _descriptionController.text,
          contactInfo: _contactController.text,
          category: _categoryController.text
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Новый контакт',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildMainInfoSection(),
                const SizedBox(height: 32,),
                BlocConsumer<ResourceBloc, ResourceState>(
                  listener: (context, state) {
                    if (state is CreateResourceSuccess) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResourcesPage(communityId: widget.communityId)),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Контакт создан!')
                        ),
                      );
                    } else if (state is ResourceErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(state.message)
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ResourceLoadingState) {
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return BuildSubmitButton(
                        text: 'Создать',
                        onPressed: _onCreate
                    );
                  },
                ),
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
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Основная информация',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 15,),
            _buildTextField(
              controller: _titleController,
              icon: Icons.title_outlined,
              label: 'Название',
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
            _buildTextField(
              controller: _descriptionController,
              icon: Icons.description_outlined,
              label: 'Описание',
              maxLines: 4,
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
            _buildTextField(
              controller: _contactController,
              icon: Icons.phone_outlined,
              label: 'Контактная информация',
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
            _buildTextField(
              controller: _categoryController,
              icon: Icons.category_outlined,
              label: 'Категория',
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        ),
        child: const Text(
          'Добавить контакт',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        )
    );
  }
}
