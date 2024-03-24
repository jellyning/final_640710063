import 'dart:convert';
import 'package:flutter/material.dart';
import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';
import '../models/todo_item.dart';
import '../helpers/color_utils.dart';
import '../helpers/my_list_tile.dart';
import '../helpers/my_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> _todoItems = [];
  late TextEditingController _searchController;
  late TextEditingController _urlSearchController;
  late TextEditingController _webTypeController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _urlSearchController = TextEditingController();
    _webTypeController = TextEditingController();
    _loadTodoItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _urlSearchController.dispose();
    _webTypeController.dispose();
    super.dispose();
  }

  Future<void> _loadTodoItems() async {
    try {
      final data = await ApiCaller().get("todos");
      List<dynamic> web= jsonDecode(data);
      setState(() {
        _todoItems = web.map((e) => TodoItem.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "todos",
        params: {
          "userId": 1,
          "title": "ทดสอบๆๆๆๆๆๆๆๆๆๆๆๆๆๆ",
          "completed": true,
        },
      );
      Map map = jsonDecode(data);
      String text =
          'ส่งข้อมูลสำเร็จ\n\n - id: ${map['id']} \n - userId: ${map['userId']} \n - title: ${map['title']} \n - completed: ${map['completed']}';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> _handleShowDialog() async {
    await showOkDialog(
      context: context,
      title: "This is a title",
      message: "This is a message",
    );
  }

  Future<void> _handleSearch() async {
    String searchText = _searchController.text;
    try {
      final data = await ApiCaller().get("search", params: {"query": searchText});
      List list = jsonDecode(data);
      setState(() {
        _todoItems = list.map((e) => TodoItem.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> _handleUrlSearch() async {
    String url = _urlSearchController.text;
    // โค้ดสำหรับค้นหา URL ในระบบ
    // ใส่โค้ดการค้นหา URL ที่นี่
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Webby Fondue\nระบบรายงานเว็บเลวๆ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('*ต้องกรอกข้อมูล', style: textTheme.bodyText1),
            const SizedBox(height: 8.0),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'URL*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _urlSearchController,
              decoration: InputDecoration(
                hintText: 'รายละเอียด',
                border: OutlineInputBorder(),
              ),
            ),
             Text('ระบุประเภทเว็บเลว*', style: textTheme.bodyText1),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  final item = _todoItems[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.title),
                      subtitle: Text('User ID: ${item.id}'),
                     // trailing: Icon(item.image ? Icons.check : null),
                    ),
                  );
                },
              ),
            ),
            Expanded(
  child: ListView.builder(
    itemCount: _todoItems.length,
    itemBuilder: (context, index) {
      final item = _todoItems[index];
      return Card(
        child: ListTile(
          title: Text(item.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.subtitle),
              SizedBox(height: 8),
              if (item.image != null)
                Image.network(
                  item.image,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      );
    },
  ),
),

            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _handleApiPost,
              child: const Text('Test POST API'),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _handleShowDialog,
              child: const Text('Show OK Dialog'),
            ),
          ],
          
        ),
      ),
    );
  }
}