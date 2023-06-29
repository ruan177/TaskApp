import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:taskapp/UI/screens/register.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class UserType {
  String email;
  String password;

  UserType({required this.email, required this.password});
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormBuilderState>();
  UserType user = UserType(email: '', password: '');

  final storage = new FlutterSecureStorage();

  Future<void> _login(BuildContext context) async {
    if (formKey.currentState!.saveAndValidate()) {
      String email = formKey.currentState!.fields['email']!.value.toString();
      String password =
          formKey.currentState!.fields['password']!.value.toString();

      UserType userObj = UserType(email: email, password: password);

      // Construir o corpo da requisição
      var requestBody = json.encode({
        'email': userObj.email,
        'password': userObj.password,
      });

      var headers = {'Content-Type': 'application/json'};

      // Enviar a requisição para a API backend
      var response = await http.post(
        Uri.parse('http://localhost:3333/login'),
        headers: headers,
        body: requestBody,
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        String userId = responseData['id'].toString();

        // Armazenar o ID do usuário com a biblioteca flutter_secure_storage
        await storage.write(key: 'userId', value: userId);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid email or password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        backgroundColor: Color.fromRGBO(192, 214, 252, 0.9019607843137255),
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: SizedBox(
                width: 300,
                child: FormBuilder(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Hello',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 50,
                          fontFamily: 'Imprima',
                        ),
                      ),
                      const Gap(20),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(labelText: 'Email'),
                        onChanged: (value) {
                          setState(() {
                            user.email = value!;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'password',
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        onChanged: (value) {
                          setState(() {
                            user.password = value!;
                          });
                        },
                      ),
                      const Gap(20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                      const Gap(20),
                      ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
