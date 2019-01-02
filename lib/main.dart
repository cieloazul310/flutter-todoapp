import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Todo {
  final String title;
  final DateTime registaredTime;
  bool isDone = false;

  void toggleDone() {
    isDone = !isDone;
  }

  Todo({@required this.title, @required this.registaredTime});
}

class TodoViewer extends StatelessWidget {
  final Todo todo;
  TodoViewer({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${todo.title}')),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            width: 200.0,
            child: Text('${todo.title}'),
          ),
        ));
  }
}

typedef void OnSubmitTodo(String text);

class FormScreen extends StatelessWidget {
  FormScreen({Key key, @required this.onSubmitTodo})
   : super(key: key);
  final OnSubmitTodo onSubmitTodo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Write a Todo'),
        ),
        body: Center(
            child: Container(
          padding: const EdgeInsets.all(24.0),
          child: TextField(
            onSubmitted: (text) {
              onSubmitTodo(text);
              Navigator.pop(context);
            },
          ),
          )
        ));
  }
}

class TodoTile extends StatelessWidget {
  TodoTile({Key key, @required this.todo, this.onDelete, this.onToggle});
  final Todo todo;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${todo.title}'),
      subtitle: Text('${todo.registaredTime.toLocal()}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoViewer(todo: todo,)
          )
        );
      },
      onLongPress: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text('Cupertino'),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: todo.isDone ? Text('Yet') : Text('Done'),
                  onPressed: () {
                    onToggle();
                    Navigator.pop(context);
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text('Delete'),
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
          }
        );
      },
      leading: Icon(
        todo.isDone ? Icons.done : Icons.remove,
        color: todo.isDone ? Colors.lightGreen : Colors.grey,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          onDelete();
        },
      ),
    );
  }
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Todo> _todos = [];

  void _addTodo(String text) {
    final todo = Todo(
            title: text, 
            registaredTime: new DateTime.now()
          );
    setState(() {
          _todos.add(todo);
        });
  }

  void toggleDone(int index) {
    setState(() {
      _todos[index].toggleDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final Todo todo = _todos[index];

          return TodoTile(
            todo: todo, 
            onToggle: () {
              toggleDone(index);
            },
            onDelete: () {
              setState(() {
                _todos.remove(todo);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FormScreen(onSubmitTodo: _addTodo),
                )
              );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
            title: Text('Profile'),
            icon: Icon(Icons.person)
          )
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: TodoApp(),
      theme: ThemeData()
    );
  }
}

void main() {
  runApp(MyApp());
}
