import 'package:flutter/material.dart';
import 'package:blink_list/todo_item.dart';
import 'package:blink_list/model/todo.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todosList = ToDo.todoList();
  final _todoController = TextEditingController();
  final _categoryController = TextEditingController();
  List<ToDo> _foundToDo = [];
  bool isDarkMode = false;
  Color lightModeColor = Colors.deepPurple[50]!;
  Color darkModeColor = Colors.grey[900]!;
  String _selectedCategory = 'All';
  List<String> categories = ['All'];

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: isDarkMode ? darkModeColor : lightModeColor,
          elevation: 0,
        ),
      ),
      home: Scaffold(
        backgroundColor: isDarkMode ? darkModeColor : lightModeColor,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Icon(
                    Icons.menu_rounded,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    size: 30,
                  ),
                  SizedBox(width: screenWidth * 0.2),
                  Center(
                    child: Text(
                      'Time-flow',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                        child: Icon(
                          Icons.nights_stay_rounded,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openColorPicker(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                        child: Icon(
                          Icons.color_lens_rounded,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _addCategory(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                        child: Icon(
                          Icons.add,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  searchBox(),
                  categoryFilter(),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50, bottom: 20,),
                          child: Text(
                            "$_selectedCategory ToDos",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        for (ToDo todo in _foundToDo.reversed)
                          ToDoItem(
                            todo: todo,
                            onToDoChanged: _handleToDoChange,
                            onDeleteItem: _deleteToDoItem,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                        left: 20,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _todoController,
                        style: TextStyle(
                          color: isDarkMode ? Colors.black : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add a new todo item',
                          hintStyle: TextStyle(
                            color: isDarkMode ? Colors.grey : Colors.black54,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                    ),
                    child: ElevatedButton(
                      child: Text('+', style: TextStyle(fontSize: 40,),),
                      onPressed: () {
                        _addToDoItem(_todoController.text, _selectedCategory);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: Size(60, 60),
                        elevation: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo, String category) {
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
        category: category,
      ));
    });
    _todoController.clear();
    _categoryController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList.where((item) =>
          item.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
    ),
    child
        : TextField(
      onChanged: (value) => _runFilter(value),
      style: TextStyle(
        color: isDarkMode ? Colors.black : Colors.black87,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black87,
          size: 18,
        ),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 25,
          minWidth: 25,
        ),
        border: InputBorder.none,
        hintText: "Search",
        hintStyle: TextStyle(color: Colors.grey),
      ),
    ),
    );
  }

  Widget categoryFilter() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: categories.map((category) {
            return _buildCategoryChip(category);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return ChoiceChip(
      label: Text(category),
      selected: _selectedCategory == category,
      onSelected: (bool selected) {
        setState(() {
          _selectedCategory = selected ? category : 'All';
          _filterByCategory();
        });
      },
    );
  }

  void _filterByCategory() {
    List<ToDo> results = [];
    if (_selectedCategory == 'All') {
      results = todosList;
    } else {
      results = todosList.where((item) => item.category == _selectedCategory).toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  void _openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme Colors'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Light Mode Color'),
                ColorPicker(
                  pickerColor: lightModeColor,
                  onColorChanged: (color) {
                    setState(() {
                      lightModeColor = color;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('Dark Mode Color'),
                ColorPicker(
                  pickerColor: darkModeColor,
                  onColorChanged: (color) {
                    setState(() {
                      darkModeColor = color;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Done'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addCategory(BuildContext context) {
    final _newCategoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _newCategoryController,
                  decoration: InputDecoration(
                    hintText: 'Category Name',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  categories.add(_newCategoryController.text);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
