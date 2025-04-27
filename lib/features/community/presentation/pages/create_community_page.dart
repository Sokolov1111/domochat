import 'package:domochat/features/community/presentation/bloc/community_bloc.dart';
import 'package:domochat/features/community/presentation/bloc/community_event.dart';
import 'package:domochat/features/community/presentation/bloc/community_state.dart';
import 'package:domochat/features/community/presentation/widgets/build_submit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({super.key});

  @override
  State<CreateCommunityPage> createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _statusController = TextEditingController();
  String _selectedStatus = 'owner';
  final _storage = FlutterSecureStorage();

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _houseController.dispose();
    _fullNameController.dispose();
    _apartmentController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _onCreate() {
    BlocProvider.of<CreateCommunityBloc>(context).add(
        CreateCommunitySubmitted(
          city: _cityController.text,
          street: _streetController.text,
          house: _houseController.text,
          creatorId: _storage.read(key: 'UserId').toString(),
          fullName: _fullNameController.text,
          apartment: _apartmentController.text,
          residentStatus: _statusController.text,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать сообщество',
        style: TextStyle(fontWeight: FontWeight.w600),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/homePage', (route) => false),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                _buildAddressSection(),
                const SizedBox(height: 24,),
                _buildPersonalInfoSection(),
                const SizedBox(height: 32,),
                BlocConsumer<CreateCommunityBloc, CreateCommunityState>(
                  listener: (context, state){
                    if (state is CreateCommunitySuccess) {
                      Navigator.pushNamedAndRemoveUntil(context, '/homePage', (route) => false);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Сообщество создано!")
                          ),
                      );
                    } else if (state is CreateCommunityFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(state.error)
                          ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is CreateCommunityLoading) {
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

  Widget _buildAddressSection() {
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
              'Адрес дома',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _cityController,
              icon: Icons.location_city_outlined,
              label: 'Город',
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
            _buildTextField(
              controller: _streetController,
              icon: Icons.streetview_outlined,
              label: 'Улица',
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
            _buildTextField(
              controller: _houseController,
              icon: Icons.numbers_outlined,
              label: 'Номер дома',
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
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
              'Ваши данные',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _fullNameController,
              icon: Icons.person_outline,
              label: 'ФИО',
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _apartmentController,
              icon: Icons.door_back_door_outlined,
              label: 'Номер квартиры',
              validator: (value) => value!.isEmpty ? 'Обязательное поле' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              items: const [
                DropdownMenuItem(value: 'owner', child: Text('Собственник')),
                DropdownMenuItem(value: 'tenant', child: Text('Арендатор')),
                DropdownMenuItem(
                  value: 'relative',
                  child: Text('Родственник'),
                ),
              ],
              //icon: Icon(Icons.verified_user_outlined, color: Colors.grey[600],),
              onChanged: (value) => _statusController.text = value!,
              // decoration: InputDecoration(
              //   labelText: 'Статус проживания',
              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10),
              //     borderSide: BorderSide.none,
              //   ),
              //   filled: true,
              //   fillColor: Colors.grey[200],
              // ),
              decoration: InputDecoration(
                labelText: "Статус проживания",
                icon: Icon(Icons.verified_user_outlined, color: Colors.grey[600],),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              dropdownColor: Colors.white,
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
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        icon: Icon(icon, color: Colors.grey[600],),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[800],
      ),
      validator: validator,
    );
  }
}
