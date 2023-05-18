import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:taskapp/UI/screens/register.dart';
import 'package:gap/gap.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState()=> _LoginState();
}
class User{
  String email;
  String password;

  User({required this.email, required this.password});
}
class _LoginState extends State<Login> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();

    final user = User(email: "", password: "");

    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        backgroundColor:  Color.fromRGBO(192, 214, 252, 0.9019607843137255),
        body:

        Center(

            child: SizedBox(
                width: 300,

                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Hello",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 50,
                              fontFamily: 'Imprima'
                          )
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
                        // Print the text value write into TextField

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
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),),);
                        },
                        child: Text("Register",
                            style: TextStyle(
                                color: Colors.purple)),

                      ),
                      const Gap(20),
                      ElevatedButton(

                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),

                        child: Text("Login"),

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
