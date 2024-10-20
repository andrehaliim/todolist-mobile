import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/TestNotification.dart';
import 'package:todolist/components/Config.dart';
import 'package:todolist/components/Dialog.dart';
import 'package:todolist/components/Loading.dart';
import 'package:todolist/models/TodoListModel.dart';
import 'package:todolist/models/UserModel.dart';
import 'package:todolist/proxys/LoginProxy.dart';
import 'package:todolist/proxys/TodoListProxy.dart';
import 'package:todolist/views/LoginView.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  late Future<List<TodoListModel>> _todoListFuture;
  late Future<UserModel> _userFuture;
  final List<TextEditingController> titleController = [];
  final List<TextEditingController> textController = [];
  late Future<List<dynamic>> _combinedFuture;

  @override
  void initState() {
    super.initState();
    _todoListFuture = getTodoList(context);
    _userFuture = getUserInfo(context);
    _combinedFuture = Future.wait([_todoListFuture, _userFuture]); // Only runs once
  }


  @override
  void dispose() {
    for (var controller in titleController) {
      controller.dispose();
    }
    for (var controller in textController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Config config = Provider.of<Config>(context);
    double defaultWidth = MediaQuery.of(context).size.width;
    double defaultHeight = MediaQuery.of(context).size.height;
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(onPressed: () async{
          addTodoDialog(context, defaultWidth, defaultHeight);
        }, icon: const Icon(Icons.add, size: 30,)),
        actions: [
          IconButton(onPressed: () async {
            /*TestNotification.showSimpleNotification(
                title: 'simple notification',
                body: 'body notification',
                payload: 'payload notification');*/

            await TestNotification.showScheduledNotification(
              title: "Test",
              body: "This is a scheduled notification",
              payload: "payload data",
              scheduledDateTime: DateTime.now().add(Duration(seconds: 10)), // Schedule 10 seconds from now
            );
          }, icon: const Icon(Icons.notifications, size: 25,)),
          IconButton(onPressed: () async{
            bool confirm = await showConfirmationDialog(context, 'Are you sure want to logout?');
            if(confirm){
              bool logoutAccount = await logout(context);
              if(logoutAccount){
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('uname');
                await prefs.remove('pw');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                );
              }
            }
          }, icon: const Icon(Icons.logout, size: 25))
        ],
      ),
      backgroundColor: config.white,
      body: FutureBuilder(
          future: _combinedFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                width: defaultWidth,
                height: defaultHeight / 1.45,
                child: const Center(
                  child: LoadingView(),
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                width: defaultWidth,
                height: defaultHeight / 1.45,
                child: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else {
              List<TodoListModel> listTodo = snapshot.data![0] as List<TodoListModel>;
              UserModel user = snapshot.data![1] as UserModel;
                for (var _ in listTodo) {
                  titleController.add(TextEditingController());
                  textController.add(TextEditingController());
                }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text("Welcome ${user.name},", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              const Text("here's your todo list", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)
                            ],
                          ),
                          const Spacer(),
                          IconButton(onPressed: () async{
                            setState(() {
                              _todoListFuture = getTodoList(context);
                              _userFuture = getUserInfo(context);
                              _combinedFuture = Future.wait([_todoListFuture, _userFuture]); // Only runs once
                            });
                          }, icon: const Icon(Icons.refresh, size: 25)),
                        ],
                      )),
                  SizedBox(
                    width: defaultWidth,
                    height: defaultHeight/1.26,
                    child: ListView.builder(
                        itemCount: listTodo.length,
                        itemBuilder: (BuildContext context, int index) {
                          TodoListModel data = listTodo[index];
                          return Container(
                            margin: const EdgeInsets.fromLTRB(8, 4, 4, 8),
                            padding: const EdgeInsets.all(8),
                            width: defaultWidth,
                            decoration: BoxDecoration(
                              border: Border.all(color: config.black, width: 1.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                          ),),
                                        width: defaultWidth/1.20,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: defaultWidth/1.65,
                                              child: Text(data.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                            ),
                                            Spacer(),
                                            Icon(Icons.access_time, size: 15,),
                                            SizedBox(width: 2,),// Your chosen icon
                                            Text(
                                              formattedTime,
                                              style: TextStyle(fontSize: 14), // Customize text style as needed
                                            )
                                          ],
                                        )),
                                    Container(
                                        width: defaultWidth/1.20,
                                        height: 2 * 14 * 1.5,
                                        child: Text(data.text,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 14, height: 1.5),))
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  height: defaultHeight/11.5,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        child: const Icon(Icons.edit, size: 20, color: Colors.black,),
                                        onTap: () async{
                                            await editTodoDialog(context, defaultWidth, defaultHeight, data);
                                        },
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        child: const Icon(Icons.delete, size: 20, color: Colors.red,),
                                        onTap: () async{
                                          bool delete = await showConfirmationDialog(context, 'Delete this todo?');
                                          if(delete){
                                            bool success = await deleteTodoList(context, data.id);
                                            if(success)
                                              {
                                                setState(() {
                                                  _todoListFuture = getTodoList(context);
                                                  _userFuture = getUserInfo(context);
                                                  _combinedFuture = Future.wait([_todoListFuture, _userFuture]);
                                                });
                                              }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                ],
              );
            }
        }
      ),
    );
  }
  addTodoDialog(BuildContext context, double width, double height) async {
    TextEditingController titleController = TextEditingController(text: '');
    TextEditingController textController = TextEditingController(text: '');

    return showDialog(
      context: context,
      builder: (context) => SizedBox(
        width: width,
        height: height,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Set border radius
          ),
          child: Container(
            width: width,
            height: height/2.5,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Create new Todo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                    const Spacer(),
                    Container(
                      child: GestureDetector(
                        child: const Icon(Icons.cancel_outlined, size: 30, color: Colors.black,),
                        onTap: () async{
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                TextField(
                  maxLines: 1,
                  maxLength: 30,
                  controller: titleController,
                  style: const TextStyle(fontSize: 14), // Styling
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Title',
                      border: OutlineInputBorder()
                  ),
                  buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) {
                    return null; // Hide the counter
                  },
                  onSubmitted: (text) {
                    print("Submitted: $text");
                  },
                ),
                const SizedBox(height: 10,),
                TextField(
                  maxLines: 2,
                  maxLength: 50,
                  controller: textController,
                  style: const TextStyle(fontSize: 14), // Styling
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Text',
                      border: OutlineInputBorder()
                  ),
                  onSubmitted: (text) {
                    print("Submitted: $text");
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: width,
                  height: height / 15,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFF000000)),
                      shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                    ),
                    onPressed: () async {
                      bool create = await createTodoList(context, titleController.text, textController.text);
                      if(create){
                        Navigator.of(context).pop();
                        setState(() {
                          _todoListFuture = getTodoList(context);
                          _userFuture = getUserInfo(context);
                          _combinedFuture = Future.wait([_todoListFuture, _userFuture]);
                        });
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  editTodoDialog(BuildContext context, double width, double height, TodoListModel data) async {
    TextEditingController titleController = TextEditingController(text: data.title);
    TextEditingController textController = TextEditingController(text: data.text);

    return showDialog(
      context: context,
      builder: (context) => SizedBox(
        width: width,
        height: height,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Set border radius
          ),
          child: Container(
            width: width,
            height: height/2.5,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Edit Todo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                    const Spacer(),
                    Container(
                      child: GestureDetector(
                        child: const Icon(Icons.cancel_outlined, size: 30, color: Colors.black,),
                        onTap: () async{
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                TextField(
                  maxLines: 1,
                  maxLength: 30,
                  controller: titleController,
                  style: const TextStyle(fontSize: 14), // Styling
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Title',
                      border: OutlineInputBorder()
                  ),
                  buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) {
                    return null; // Hide the counter
                  },
                  onSubmitted: (text) {
                    print("Submitted: $text");
                  },
                ),
                const SizedBox(height: 10,),
                TextField(
                  maxLines: 2,
                  maxLength: 50,
                  controller: textController,
                  style: const TextStyle(fontSize: 14), // Styling
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Text',
                      border: OutlineInputBorder()
                  ),
                  onSubmitted: (text) {
                    print("Submitted: $text");
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: width,
                  height: height / 15,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFF000000)),
                      shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                    ),
                    onPressed: () async {
                      bool create = await updateTodoList(context, titleController.text, textController.text, data.id);
                      if(create){
                        Navigator.of(context).pop();
                        setState(() {
                          _todoListFuture = getTodoList(context);
                          _userFuture = getUserInfo(context);
                          _combinedFuture = Future.wait([_todoListFuture, _userFuture]);
                        });
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
