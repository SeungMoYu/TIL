// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Today\'s ToDo List',
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _allToDo = [];
  bool _showCompletedOnly = false;

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  @override
  initState() {
    // at the beginning, all users are shown
    _foundUsers = _allToDo;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allToDo;
    } 
    else {
      results = _allToDo
          .where((item) =>
              item["todo"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    if (_showCompletedOnly) {
      results = results.where((item) => item["isDone"] == true).toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }

  Future<String?> _displayDialog(BuildContext context) async {
  TextEditingController textFieldController = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add new ToDo'),
        content: TextField(
          controller: textFieldController,
          decoration: const InputDecoration(hintText: ""),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('ADD'),
            onPressed: () { Navigator.of(context).pop(textFieldController.text); },
          ),
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () { Navigator.of(context).pop(); },
          )
        ],
      );
    }
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s ToDo List'),
        actions: [
          IconButton(
            icon: Icon(
              _showCompletedOnly ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _showCompletedOnly = !_showCompletedOnly;
                _runFilter('');
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox( height: 20 ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox( height: 20 ),
            Expanded(
              child: _foundUsers.isNotEmpty
                ? ListView.builder(
                    itemCount: _foundUsers.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(_foundUsers[index]["id"]),
                      color: Colors.blue,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Text(
                          _foundUsers[index]["id"].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24
                            ),
                        ),
                        title: Text(
                          _foundUsers[index]['todo'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            decoration: _foundUsers[index]['isDone']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _foundUsers[index]["isDone"],
                              onChanged: (bool? value) {
                                setState(() {
                                  int idToUpdate = _foundUsers[index]["id"];
                                  _allToDo.firstWhere((item) => item["id"] == idToUpdate)["isDone"] = value!;
                                  _runFilter(''); // Refresh the list
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  int idToDelete = _foundUsers[index]["id"];
                                  _allToDo.removeWhere((item) => item["id"] == idToDelete);
                                  _runFilter(''); // Refresh the list
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Text(
                  '할 일이 없어요',
                  style: TextStyle(
                    color: Color.fromARGB(255, 168, 168, 168),
                    fontSize: 24),
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // 1. Display dialog for the user to input new todo item
          String? newTodo = await _displayDialog(context);

          // 2. Add the new todo to the list if it's not null or empty
          if (newTodo != null && newTodo.trim().isNotEmpty) {
            setState(() {
              _allToDo.add({
                "id": _allToDo.length + 1,
                "todo": newTodo,
                "isDone": false,
              });
              _runFilter(''); // Refresh the list
            });
          }
        },
      ),
    );
  }
}
