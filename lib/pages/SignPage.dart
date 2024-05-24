import 'package:flutter/material.dart';

import '../domains/requests/login.dart';
import '../domains/requests/registration.dart';
import 'MainPage.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login / Registration'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          labelStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontSize: 18),
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: 'Login'),
            Tab(text: 'Register'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LoginForm(),
          RegisterForm(),
        ],
      ),
    );
  }
}

// Убедитесь, что импортированы все необходимые файлы, особенно тот, который содержит функцию login и MainPage.

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;  // Добавляем состояние загрузки

  Future<void> attemptLogin() async {
    setState(() {
      _isLoading = true;  // Включаем анимацию загрузки
    });
    try {
      final success = await login(_loginController.text, _passwordController.text);  // Вызываем функцию login
      if (success) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));  // Перенаправляем на MainPage
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed")));  // Ошибка входа
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred")));  // Ошибка сети или сервера
    } finally {
      setState(() {
        _isLoading = false;  // Выключаем анимацию загрузки
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _loginController,
            decoration: InputDecoration(
              hintText: 'Login',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : attemptLogin,  // Блокируем кнопку при загрузке
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)  // Показываем индикатор загрузки
                : Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}


class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _driverLicenseController = TextEditingController();
  final TextEditingController _drivingExperienceController = TextEditingController();

  bool _isLoading = false;

  Future<void> handleRegistration() async {
    setState(() {
      _isLoading = true;
    });
    bool registered = await register(
      login: _loginController.text,
      password: _passwordController.text,
      phone: _phoneController.text,
      fullName: _fullNameController.text,
      drivingExperience: int.parse(_drivingExperienceController.text),
      driverLicense: _driverLicenseController.text,
    );
    if (registered) {
      // Если регистрация успешна, выполнить логин
      bool loggedIn = await login(_loginController.text, _passwordController.text);
      if (loggedIn) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildTextField(_fullNameController, 'Full Name'),
            SizedBox(height: 10),
            buildTextField(_phoneController, 'Phone'),
            SizedBox(height: 10),
            buildTextField(_loginController, 'Login'),
            SizedBox(height: 10),
            buildTextField(_passwordController, 'Password', obscureText: true),
            SizedBox(height: 10),
            buildTextField(_driverLicenseController, 'Driver License'),
            SizedBox(height: 10),
            buildTextField(_drivingExperienceController, 'Driving Experience', keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : handleRegistration,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _fullNameController.dispose();
    _driverLicenseController.dispose();
    _drivingExperienceController.dispose();
    super.dispose();
  }
}

