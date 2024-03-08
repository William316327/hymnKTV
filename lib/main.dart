import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(

      apiKey: "AIzaSyBQdcQ3SgavmR_QvnMix3WsXfsEGOSO3kw",
      authDomain: "hymnktv.firebaseapp.com",
      databaseURL: "https://hymnktv-default-rtdb.firebaseio.com",
      projectId: "hymnktv",
      storageBucket: "hymnktv.appspot.com",
      messagingSenderId: "865940334513",
      appId: "1:865940334513:web:f6850991370e97b42c3f90",
     
    ),
  );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HymnKTV',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String youtubeUrl = '';

  @override
  void initState() {
    super.initState();
    getLatestHymn();
  }

  void getLatestHymn() async {
    // 取得 Firestore 資料庫的參考
    final db = fb.firestore();

    // 取得 hymnlist 集合的參考
    final hymnlistRef = db.collection('hymnktv').doc('hymnlist');

    // 取得編號最大的歌曲資料
    final snapshot = await hymnlistRef.orderBy('編號', 'desc').limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      final latestHymn = snapshot.docs.first.data();
      final originalLink = latestHymn['原唱鏈結'];

      setState(() {
        youtubeUrl = originalLink;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HymnKTV'),
      ),
      body: Center(
        child: youtubeUrl.isNotEmpty
            ? SizedBox(
                width: 400,
                height: 300,
                child: WebView(
                  initialUrl: youtubeUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
