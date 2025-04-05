import 'package:domochat/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              SizedBox(
                height: 32,
              ),
              _buildEmailField(),
              SizedBox(
                height: 16,
              ),
              _buildPasswordField(),
              SizedBox(
                height: 16,
              ),
              _buildLoginButton(),
              SizedBox(
                height: 24,
              ),
              _buildRegisterLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 1000),
          child: Image.asset(
            "images/logo.jpg",
            key: ValueKey('logo'),
            height: 120,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          'Заполните форму ниже, чтобы войти',
          style: TextStyle(
            color: Colors.blueGrey[600],
            fontSize: 14,
          ),
        )
      ],
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
          icon:
              Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
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

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Еще нет аккаунта?'),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
          },
          child: Text(
            ' Зарегистрироваться',
            style:
                TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
        onPressed: () {},
        child: Text(
          'Войти',
          style: TextStyle(color: Colors.white),
        ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
