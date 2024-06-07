import 'package:flutter/material.dart';
import 'package:blink_list/todo_item.dart';
import 'package:blink_list/model/todo.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:blink_list/calendar_page.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todosList = ToDo.todoList();
  final _todoController = TextEditingController();
  List<ToDo> _foundToDo = [];
  bool isDarkMode = false;
  Color lightModeColor = Colors.deepPurple[50]!;
  Color darkModeColor = Colors.grey[900]!;
  String _selectedCategory = 'All';
  List<String> categories = ['All'];

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    _foundToDo = todosList;
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(ToDo todo) async {
    var scheduledNotificationDateTime = todo.deadline;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      icon: '@mipmap/ic_launcher',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );

    if (scheduledNotificationDateTime != null && scheduledNotificationDateTime.isBefore(DateTime.now())) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'ToDo 마감기한 알람',
        '${todo.todoText}의 마감기한이 지났습니다',
        platformChannelSpecifics,
      );
    }
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
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarPage(
                          todosList: todosList,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                          backgroundColor: isDarkMode ? darkModeColor : lightModeColor,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: isDarkMode ? Colors.white : Colors.black87,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.2),
                  Center(
                    child: Text(
                      '일정 관리',
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
                  GestureDetector(
                    onTap: () => _deleteCategoryDialog(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                        child: Icon(
                          Icons.remove_circle_outline,
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
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _addToDoItem(context);
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.deepPurple,
                ),
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

  void _addToDoItem(BuildContext context) {
    final _newToDoController = TextEditingController();
    DateTime? _selectedDeadline;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('새로운 할 일 추가'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _newToDoController,
                  decoration: InputDecoration(
                    hintText: '할 일 입력',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    _selectedDeadline = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (_selectedDeadline != null) {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        _selectedDeadline = DateTime(
                          _selectedDeadline!.year,
                          _selectedDeadline!.month,
                          _selectedDeadline!.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      }
                    }
                  },
                  child: Text(_selectedDeadline == null
                      ? '마감기한 설정'
                      : 'Selected: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDeadline!)}'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('추가'),
              onPressed: () {
                if (_newToDoController.text.isNotEmpty) {
                  ToDo newToDo = ToDo(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    todoText: _newToDoController.text,
                    category: _selectedCategory,
                    deadline: _selectedDeadline,
                  );
                  setState(() {
                    todosList.add(newToDo);
                  });
                  if (_selectedDeadline != null) {
                    _scheduleNotification(newToDo);
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList.where((item) =>
      item.todoText?.toLowerCase().contains(enteredKeyword.toLowerCase()) ?? false).toList();
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
              child: const Text('완료'),
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
          title: const Text('새로운 카테고리 추가'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _newCategoryController,
                  decoration: InputDecoration(
                    hintText: '카테고리 이름',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('추가'),
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

  void _deleteCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('카테고리 삭제'),
          content: SingleChildScrollView(
            child: Column(
              children: categories.map((category) {
                if (category != 'All') {
                  return ListTile(
                    title: Text(category),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteCategory(category);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              }).toList(),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(String category) {
    setState(() {
      categories.remove(category);
      if (_selectedCategory == category) {
        _selectedCategory = 'All';
        _filterByCategory();
      }
    });
  }
}
