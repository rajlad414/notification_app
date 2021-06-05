import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_performance_channel",
    "high_important_notification",
    "This channel is used for sending important notification",
    groupId: "com.example.notification_app",
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
List<Messages> messages = [];
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  var initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("Message retrived");
    List<String> people = [];
    String names="";
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    print("Messages lenght: ${messages.length}");
    messages.add(new Messages(notification!.title!, notification.body!));

    print("Messages lenght: ${messages.length}");

    for (int i = 0; i < messages.length; i++) {
      people.add(messages[i].getTitle());
    }

    if (notification != null && android != null && messages.length - 1 == 0) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  groupKey: "com.example.notification_app",
                  color: Colors.blue,
                  playSound: true,
                  setAsGroupSummary: true,
                  icon: '@mipmap/ic_launcher')));
    }
    else {
      print("Peoples: ${people.length}");

      if(people.length==2){
        names+=people[0]+" and "+people[1]+" messaged you.";
      }
      else{
        names+=people[0]+", "+people[1]+" and ${people.length-2} other messaged you.";

      }
      InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
          people,
          contentTitle: '${people.length} messages',
          summaryText: '');
      AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          channel.id, channel.name, channel.description,
          styleInformation: inboxStyleInformation,
          setAsGroupSummary: true,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher');
      NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, 'Attention', names, platformChannelSpecifics);
    }
  });
  await Firebase.initializeApp();
  //
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("token: $token");
  }

  int _counter = 0;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Messages> messages = [];

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Message retrived");
      List<String> people = [];
      String names="";
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print("Messages lenght: ${messages.length}");
      messages.add(new Messages(notification!.title!, notification.body!));

      print("Messages lenght: ${messages.length}");

      for (int i = 0; i < messages.length; i++) {
        people.add(messages[i].getTitle());
      }

      if (notification != null && android != null && messages.length - 1 == 0) {
        flutterLocalNotificationsPlugin.show(
           notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    groupKey: "com.example.notification_app",
                    color: Colors.blue,
                    playSound: true,
                    setAsGroupSummary: true,
                    icon: '@mipmap/ic_launcher')));
      }
      else {
        print("Peoples: ${people.length}");

        if(people.length==2){
          names+=people[0]+" and "+people[1]+" messaged you.";
        }
        else{
          names+=people[0]+", "+people[1]+" and ${people.length-2} other messaged you.";

        }
        InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
            people,
            contentTitle: '${people.length} messages',
            summaryText: '');
        AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                styleInformation: inboxStyleInformation,
                setAsGroupSummary: true,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher');
        NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0, 'Attention', names, platformChannelSpecifics);
      }
    });
    getToken();
    //
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Raj",
        "Hello!! Let Hang out",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                groupKey: "com.example.notification_app",
                color: Colors.blue,
                playSound: true,
                setAsGroupSummary: true,
                importance: Importance.max,
                priority: Priority.high,
                icon: "@mipmap/ic_launcher")));
    flutterLocalNotificationsPlugin.show(
        1,
        "king",
        "Ya Lets Hang Out",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                groupKey: "com.example.notification_app",
                color: Colors.blue,
                playSound: true,
                setAsGroupSummary: true,
                importance: Importance.max,
                priority: Priority.high,
                icon: "@mipmap/ic_launcher")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Messages {
  String title = "", body = "";
  Messages(String title, String body) {
    this.title = title;
    this.body = body;
  }
  String getTitle() {
    return this.title;
  }

  String getBody() {
    return this.body;
  }
}
