import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taskapp/UI/screens/login.dart';
import 'package:taskapp/UI/screens/updateAccount.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'newTaskPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class Task {
  final int id;
  final String title;

  Task({required this.id, required this.title});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
    );
  }
}

// ignore: must_be_immutable
class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final storage = new FlutterSecureStorage();

  late Future<List<Task>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = fetchTasks();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<List<Task>> fetchTasks() async {
    String? userId = await storage.read(key: "userId");
    var headers = {'Content-Type': 'application/json'};
    final response = await http.get(
      Uri.parse('http://localhost:3333/tasks?userId=$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> tasksJson = data['tasks'];
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                String? userId = await storage.read(key: "userId");
                if (userId != null) {
                  // Enviar a solicitação para excluir o usuário usando o ID recuperado
                  await _deleteUser(userId, context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteTask(BuildContext context, int taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteTask(taskId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(int taskId) async {
    var response = await http.delete(
      Uri.parse('http://localhost:3333/tasks/$taskId'),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Task deleted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      // Atualize a lista de tarefas após a exclusão
      setState(() {
        // Chame novamente a função fetchTasks para buscar as tarefas atualizadas
        _tasks = fetchTasks();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to delete task',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _deleteUser(String userId, BuildContext context) async {
    // Aqui você pode fazer a solicitação para excluir o usuário usando o ID fornecido
    // Exemplo:
    var response = await http.delete(
      Uri.parse('http://localhost:3333/users/$userId'),
    );

    if (response.statusCode == 200) {
      // Exclusão do usuário bem-sucedida
      // Limpar os dados de autenticação e redirecionar para a tela de login
      await storage.deleteAll();
      Fluttertoast.showToast(
        msg: 'Account deleted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      // Falha ao excluir o usuário
      Fluttertoast.showToast(
        msg: 'Failed to delete account',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Color.fromRGBO(192, 214, 252, 0.9019607843137255),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.person_pin),
            onPressed: _openDrawer,
            color: Colors.black,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Update Account'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateAccountPage()));
              },
            ),
            ListTile(
              title: Text('Delete Account'),
              onTap: () {
                _confirmDeleteAccount(context);
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Color.fromRGBO(192, 214, 252, 0.9019607843137255),
        child: Column(
          children: [
            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Text(
                          'Olá,',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Container(
                      height: 50,
                      width: 70,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewTaskPage(),
                            ),
                          ).then((refresh) {
                            if (refresh != null && refresh) {
                              setState(() {
                                _tasks = fetchTasks();
                              });
                            }
                          });
                        },
                        child: Text(
                          '+Add' + '\n Task',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Poppins'),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurple),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 64),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Tasks',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Task>>(
                future: _tasks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final tasks = snapshot.data!;
                    return ListView.builder(
                      key: ValueKey(snapshot.data?.length),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Card(
                            child: ListTile(
                              leading: Icon(
                                Icons.event_note,
                                color: Colors.deepPurple,
                              ),
                              title: Text(task.title),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDeleteTask(context, task.id);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('No tasks created'),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
