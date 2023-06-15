import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/UI/screens/login.dart';
import '../../data/database.dart';
import '../../data/models/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState()=> _RegisterState();
}
class IUser{
  String name;
  String email;
  String password;

  IUser({required this.name, required this.email, required this.password});
}
class _RegisterState extends State<Register> {
  // This widget is the root of your application.

    final _formKey = GlobalKey<FormBuilderState>();
    late IUser user;

    @override
    void initState() {
      super.initState();
      user = IUser(name: '', email: '', password: '');
    }

    void _register(BuildContext context) {
      if (_formKey.currentState!.saveAndValidate()) {
        // Dados do formulário válidos
        String name = _formKey.currentState!.fields['username']!.value.toString();
        String email = _formKey.currentState!.fields['email']!.value.toString();
        String password = _formKey.currentState!.fields['password']!.value.toString();

        // Criar o usuário no banco de dados utilizando o UserDao
        IUser newUserObj = IUser(name: name, email: email, password: password);

        Provider.of<MyDatabase>(context, listen: false)
            .userDao
            .addUser(newUserObj)
            .then((value) {
          // Usuário cadastrado com sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Usuário cadastrado com sucesso.'),
              backgroundColor: Colors.green,
            ),
          );
        }).catchError((error) {
          // Ocorreu um erro ao cadastrar o usuário
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao cadastrar usuário. Tente novamente.'),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
          backgroundColor: Color.fromRGBO(192, 214, 252, 0.9019607843137255),
          body: Center(
              child: SizedBox(
                  width: 300,
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Hello",
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 50,
                            fontFamily: 'Imprima',
                          ),
                        ),
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'username',
                          decoration: const InputDecoration(labelText: 'Username'),
                          onChanged: (value) {
                            setState(() {
                              user.name = value!;
                            });
                          },
                        ),
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
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _register(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                          ),
                          child: Text("Register"),

                      ),
                    ]  ,
                  ),
                )
            )
        ),
      ),
    );
  }
}
