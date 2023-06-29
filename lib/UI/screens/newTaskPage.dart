import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NewTaskPage extends StatefulWidget {
  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TextEditingController _taskNameController = TextEditingController();
  final storage = new FlutterSecureStorage();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  void _createTask(BuildContext context) async {
    // Ler o userId do armazenamento seguro

    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      // Obter os valores do título, data de início e data de término
      String title = _taskNameController.text;
      String startDate = _startDate.toIso8601String().substring(0, 10);
      String endDate = _endDate
          .toIso8601String()
          .substring(0, 10); // Converter para string no formato ISO 8601

      if (title.isNotEmpty && _startDate != null && _endDate != null) {
        // Construir o corpo da requisição
        var requestBody = json.encode({
          'title': title,
          'startDate': startDate,
          'endDate': endDate,
          'authorId': userId,
        });

        var headers = {'Content-Type': 'application/json'};

        // Enviar a requisição para a API backend
        var response = await http.post(
          Uri.parse('http://localhost:3333/tasks'),
          headers: headers,
          body: requestBody,
        );

        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            msg: 'Task created successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pop(context, true);
        } else {
          // Falha ao criar a tarefa
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to create task"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Título vazio ou data de início/ término não selecionada
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Please enter a valid title and select start/end dates"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 16),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.grey[700],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Create New Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 64),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _taskNameController,
                      decoration: InputDecoration(
                        labelText: 'Task Name',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _selectStartDate(context),
                    icon: Image.asset('images/calendar.png',
                        width: 32, height: 32),
                    label: Text(
                      'Start Date',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(color: Colors.deepPurple),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _selectEndDate(context),
                    icon: Image.asset('images/calendar.png',
                        width: 32, height: 32),
                    label: Text(
                      'End Date',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(color: Colors.deepPurple),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 64),
              Padding(
                padding: EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      _createTask(context);
                    },
                    child: Text('Create'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 96, vertical: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
