import 'package:domochat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_event.dart';
import 'package:domochat/features/auth/presentation/pages/login_page.dart';
import 'package:domochat/features/auth/presentation/widgets/auth_button.dart';
import 'package:domochat/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onRegister() {
    BlocProvider.of<AuthBloc>(context).add(
      RegisterEvent(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text
      ),
    );
  }

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
          //key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(
                height: 32,
              ),
              AuthInputField(hint: "Введите имя", icon: Icons.person_outline, controller: _usernameController),
              SizedBox(
                height: 16,
              ),
              AuthInputField(hint: "Введите логин", icon: Icons.email_outlined, controller: _emailController),
              SizedBox(
                height: 16,
              ),
              AuthInputField(hint: "Введите пароль", icon: Icons.password_outlined, controller: _passwordController, isPassword: true,),
              SizedBox(
                height: 16,
              ),
              BlocConsumer<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return AuthButton(
                        text: 'Зарегистрироваться',
                        onPressed: _onRegister
                    );
                  }, 
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error))
                      );
                    }
                  }
              ),
              SizedBox(
                height: 24,
              ),
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
          'Заполните форму ниже, чтобы зарегистрироваться',
          style: TextStyle(
            color: Colors.blueGrey[600],
            fontSize: 14,
          ),
        )
      ],
    );
  }


  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Уже есть аккаунт?'),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text(
            ' Войти',
            style:
                TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
