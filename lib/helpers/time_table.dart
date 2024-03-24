import 'package:flutter/material.dart';
import 'package:final_640710063/models/todo_item.dart';
import 'dart:convert';
import 'package:dio/dio.dart';



class ToDoDetailDialog extends StatelessWidget {
  final TodoItem todoItem;

  const ToDoDetailDialog({Key? key, required this.todoItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todoItem.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('subtitle: ${todoItem.subtitle ?? ''}'),
            SizedBox(height: 8),
            Image.network(
              todoItem.image ?? '',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Icon(Icons.error, color: const Color.fromARGB(255, 3, 100, 179));
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  List<TodoItem> _todoItems = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            var dio = Dio(BaseOptions(responseType: ResponseType.plain));
            var response = await dio.get('https://cpsu-api-49b593d4e146.herokuapp.com');

            setState(() {
              var list = jsonDecode(response.data.toString()) as List<dynamic>;
              _todoItems = list.map((item) => TodoItem.fromJson(item)).toList();
            });
          },
          child: Text('Test API'),
        ),
        Expanded(
          child: _todoItems.isEmpty
              ? SizedBox.shrink()
              : ListView.builder(
                  itemCount: _todoItems.length,
                  itemBuilder: (context, index) {
                    var todoItem = _todoItems[index];
                    var imageURL = todoItem.image ?? '';
                    return ListTile(
                      title: Text(todoItem.title ?? ''),
                      subtitle: Text(todoItem.subtitle ??''),
                      trailing: imageURL.isNotEmpty
                          ? SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                imageURL,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Icon(Icons.error, color: const Color.fromARGB(255, 3, 100, 179));
                                },
                              ),
                            )
                          : SizedBox.shrink(),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ToDoDetailDialog(todoItem: todoItem),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}