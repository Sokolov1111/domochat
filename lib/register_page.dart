
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});


  @override
  State<RegisterPage> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();


  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey[800],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(height: 32,),
              _buildNameField(),
              SizedBox(height: 16,),
              _buildEmailField(),
              SizedBox(height: 16,),
              _buildPasswordField(),
              SizedBox(height: 16,),
              _buildRegisterButton(),
              SizedBox(height: 24,),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 20),
        AnimatedSwitcher(
            duration: Duration(microseconds: 500),
          child: Image.asset(
            "images/logo.jpg",
            key: ValueKey('logo'),
            height: 120,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Заполните форму ниже чтобы зарегистрироваться',
          style: TextStyle(
          color: Colors.blueGrey[600],
            fontSize: 14,
        ),
        )
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(labelText: 'Имя', prefixIcon: Icon(Icons.person_outline)),
      validator: (value) => value!.isEmpty ? 'Пожалуйста, введите ваше имя' : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Пожалуйста, введите email';
        //if (!RegExp())
        return null;
      },

    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Пароль',
        prefixIcon: Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() {
            _obscurePassword = !_obscurePassword;
          }),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return "Пожалуйста, введите пароль!";
        //if (value.length < 2) return "Пожалуйста, введите пароль!";
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
        onPressed: () {},
        child: Text('Зарегистрироваться', style: TextStyle(
          color: Colors.white
        ),),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Уже есть аккаунт?'),
        GestureDetector(
          onTap: (){},
          child: Text(
            ' Войти',
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}