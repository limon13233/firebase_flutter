import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

final FirebaseFirestore fireStore = FirebaseFirestore.instance;
String userAutoId = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

ConfirmationResult? confirmationResult;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class RegPage extends StatefulWidget {
  const RegPage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _phoneCodeController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("🤣❤😍🎶🤦‍♀️🤦‍♀️🙌🙌🙌🙌🙌🙌🙌🙌🙌"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Почта
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            //Почта ссылка

            //Пароль
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            //Телефон
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: 'Телефон',
                border: OutlineInputBorder(),
              ),
            ),
            //Код
            TextFormField(
              controller: _phoneCodeController,
              decoration: const InputDecoration(
                hintText: 'Код',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  signInEmail(_emailController.text, _passwordController.text);
                },
                child: const Text(
                  'Авторизация',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  signInAnon();
                },
                child: const Text(
                  'Авторизация (анонимно)',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  signInPhone(_phoneController.text);
                },
                child: const Text(
                  'Отправить код',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  signInCode(_phoneCodeController.text);
                },
                child: const Text(
                  'Авторизация (код)',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegPageF()));
                },
                child: const Text(
                  'Регистрация',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> signInEmail(String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResultPageF())));
    var acs = ActionCodeSettings(
      url: 'https://www.example.com/finishSignUp?cartId=1234',
      handleCodeInApp: true,
    );
    await FirebaseAuth.instance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
    final user = FirebaseAuth.instance.currentUser;

    final userCurrent = fireStore.collection("user").doc(user!.uid);
    userAutoId = userCurrent.id;
  }

  void signInAnon() {
    FirebaseAuth.instance.signInAnonymously().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => ResultPageF())));
  }

  void signInPhone(String phone) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    confirmationResult = await auth.signInWithPhoneNumber(phone);
  }

  void signInCode(String code) async {
    UserCredential userCredential = await confirmationResult!.confirm(code);
    if (userCredential.user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ResultPageF()));
    }
  }
}

class ResultPageF extends StatelessWidget {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _typeController = TextEditingController();
    TextEditingController _colorController = TextEditingController();

    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text("Получилось 🤣❤😍🎶🤦‍♀️🤦‍♀️🙌🙌🙌🙌🙌🙌🙌🙌🙌"),
              SizedBox(
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserPage()));
                  },
                  child: const Text(
                    'Профиль',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostListPage()));
                  },
                  child: const Text(
                    'Посты',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  title: "oof",
                                )));
                  },
                  child: const Text(
                    'Обратно на логин',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ])));
  }
}

class UserPage extends StatelessWidget {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _oldemailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _oldpasswordController = TextEditingController();
    TextEditingController _nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Смена данных аккаунта"),
            Text('Старый email'),

            TextFormField(
              controller: _oldemailController,
              decoration: const InputDecoration(
                hintText: 'Старый Email',
                border: OutlineInputBorder(),
              ),
            ),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Новый Email',
                border: OutlineInputBorder(),
              ),
            ),
            //Имя

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            //Имя

            //Пароль
            TextFormField(
              controller: _oldpasswordController,
              decoration: const InputDecoration(
                hintText: 'Старый Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  changeProfile(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                          _oldemailController.text,
                          _oldpasswordController.text)
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResultPageF())));
                },
                child: const Text(
                  'Изменить',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  userDelete(
                          _oldemailController.text, _oldpasswordController.text)
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                    title: "ops",
                                  ))));
                },
                child: const Text(
                  'Удалить профиль',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> changeProfile(String email, String password, String name,
      String oldemail, String oldpas) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: oldemail, password: oldpas)
          .then((userCredential) {
        userCredential.user?.updateEmail(email);
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: oldpas)
          .then((userCredential) {
        userCredential.user?.updatePassword(password);
      });
      await userChange(name, email, password);
    } catch (e) {
      print(
        "expect $e",
      );
    }
  }

  Future<void> userChange(String name, String email, String password) async {
    final user = fireStore.collection("user");
    if (name != "")
      return user
          .doc(userAutoId)
          .set({'email': email, 'name': name, 'password': password})
          .then((value) => print("User updated"))
          .catchError((error) => print(error.toString()));
  }

  Future<void> userDelete(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      userCredential.user?.delete();
    });
    final user = fireStore.collection("user");

    return user
        .doc(userAutoId)
        .delete()
        .then((value) => print("User updated"))
        .catchError((error) => print(error.toString()));
  }
}

class RegPageF extends StatelessWidget {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _key = GlobalKey();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _ageController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.

          ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Почта
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            //Имя

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            //Имя

            //Пароль
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  signUpEmail(_emailController.text, _passwordController.text,
                      _nameController.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: "oof",
                              )));
                },
                child: const Text(
                  'Регистрация (почта)',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: "oof",
                              )));
                },
                child: const Text(
                  'Обратно на логин',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUpEmail(String email, String password, String name) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await userAdd(name, email);
  }

  Future<void> userAdd(String name, String email) {
    final user = fireStore.collection("user");
    return user
        .add({'name': name, 'email': email})
        .then((value) => print("User added"))
        .catchError((error) => print(error.toString()))
        .whenComplete(() => userAutoId = user.id);
  }
}

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post List'),
      ),
      body: Column(
        children: [
          _buildAddPostForm(),
          Expanded(child: _buildPostList()),
        ],
      ),
    );
  }

  Widget _buildAddPostForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add Post',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'id',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Text',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _addPost();
            },
            child: const Text('Add'),
          ),
          ElevatedButton(
            onPressed: () {
              _editPost(new Post(
                  id: _idController.text,
                  title: _titleController.text,
                  text: _textController.text));
            },
            child: const Text('edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    return StreamBuilder<List<Post>>(
      stream: _getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.id + " " + post.title),
                subtitle: Text(post.text),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    print(post.id);
                    _deletePost(post.id);
                  },
                ),
                onTap: () {
                  _idController.text = post.id;
                  _textController.text = post.text;
                  _titleController.text = post.title;
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> _addPost() async {
    final post = Post(
      id: _idController.text,
      title: _titleController.text,
      text: _textController.text,
    );
    await addPost(post);
    _idController.clear();
    _titleController.clear();
    _textController.clear();
    setState(() {});
  }

  Stream<List<Post>> _getPosts() {
    return getPosts();
  }

  Future<void> _editPost(Post post) async {
    updatePost(post.id, post);
    setState(() {});
  }

  Future<void> _deletePost(String postId) async {
    await deletePost(postId);
    setState(() {});
  }
}

Future<void> deletePost(String postId) async {
  final postsCollection = FirebaseFirestore.instance.collection('posts');
  await postsCollection.doc(postId).delete();
}

Future<void> updatePost(String postId, Post post) async {
  final postsCollection = FirebaseFirestore.instance.collection('posts');
  await postsCollection.doc(postId).update({
    'id': post.id,
    'title': post.title,
    'text': post.text,
  });
}

Stream<List<Post>> getPosts() {
  final postsCollection = FirebaseFirestore.instance.collection('posts');
  return postsCollection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Post(
        id: doc.id,
        title: data['title'],
        text: data['text'],
      );
    }).toList();
  });
}

Future<void> addPost(Post post) async {
  final postsCollection = FirebaseFirestore.instance.collection('posts');
  await postsCollection.add({
    'id': post.id,
    'title': post.title,
    'text': post.text,
  });
}

class Post {
  String id;
  String title;
  String text;

  Post({required this.id, required this.title, required this.text});
}
