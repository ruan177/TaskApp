import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:taskapp/UI/screens/register.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../data/database.dart';
import 'homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState()=> _LoginState();
}
class UserType{
  String email;
  String password;

  UserType({required this.email, required this.password});
}
class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormBuilderState>();
  UserType user = UserType(email: '', password: '');

  void _login(BuildContext context) async {
    if (formKey.currentState!.saveAndValidate()) {
      String email = formKey.currentState!.fields['email']!.value.toString();
      String password = formKey.currentState!.fields['password']!.value.toString();

      UserType userObj = UserType(email: email, password: password);
      UserData? userData = await Provider.of<MyDatabase>(context, listen: false)
          .userDao
          .findUserByEmail(userObj.email);

      if (userData != null && userData.password == userObj.password) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Credenciais inválidas. Verifique seu email e senha.'),
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
                        decoration: const InputDecoration(labelText: 'Password'),
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

