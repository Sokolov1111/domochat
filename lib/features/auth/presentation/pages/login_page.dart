import 'package:domochat/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:domochat/features/auth/presentation/bloc/auth_event.dart';
import 'package:domochat/features/auth/presentation/pages/register_page.dart';
import 'package:domochat/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onLogin() {
    BlocProvider.of<AuthBloc>(context).add(
      LoginEvent(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(
                height: 32,
              ),
              AuthInputField(hint: "Введите логин", icon: Icons.email_outlined, controller: _emailController),
              SizedBox(
                height: 16,
              ),
              AuthInputField(hint: "Введите пароль", icon: Icons.password_outlined, controller: _passwordController),
              SizedBox(
                height: 16,
              ),
              BlocConsumer<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return AuthButton(
                        text: 'Войти',
                        onPressed: _onLogin
                    );
                  },
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      Navigator.pushNamedAndRemoveUntil(context, '/homePage', (route) => false);
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
          'Заполните форму ниже, чтобы войти',
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
        Text('Еще нет аккаунта?'),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
          child: Text(
            ' Зарегистрироваться',
            style:
            TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold,),
          ),
        ),
      ],
    );
  }
}
