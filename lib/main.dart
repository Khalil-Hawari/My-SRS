import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';

// final Telephony telephony = Telephony.instance;

// backgroundMessageHandler(SmsMessage message) async {
//   //Handle background message
//   log('$message.address'); //+977981******67, sender nubmer
//   log('$message.body'); //sms text
//   log('$message.date');
// }

// Future<List<SmsMessage>> messages = telephony.getInboxSms(
//     columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
//     filter: SmsFilter.where(SmsColumn.ADDRESS)
//         .equals("1234567890")
//         .and(SmsColumn.BODY)
//         .like("starwars"),
//     sortOrder: [
//       OrderBy(SmsColumn.ADDRESS, sort: Sort.ASC),
//       OrderBy(SmsColumn.BODY)
//     ]);

void main() {
  runApp(const MyApp());
}

class MyAppState extends ChangeNotifier {
  // String _message = "";
  var telephony = Telephony.instance;
  static List<SmsMessage> messageList = [];

  List<SmsMessage>? get messages => UnmodifiableListView(messageList);

  static onBackgroundMessageInState(SmsMessage message) async {
    debugPrint("RELAY onBackgroundMessageInState called");
    messageList.add(message);
    debugPrint('OnBack: ' + messageList.length.toString());
    // debugPrint(message.body ?? "Error reading message body.");
  }

  onMessage(SmsMessage message) async {
    debugPrint('OnMessage RELAY Called');
    messageList.add(message);
    debugPrint("onMessage: " + messageList.length.toString());
    notifyListeners();
    // setState(() {
    //   _message = message.body ?? "Error reading message body.";
    // });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    final bool? result = await telephony.requestSmsPermissions;

    if (result != null && result) {
      debugPrint('INIT PLATFORM STATE');
      telephony.listenIncomingSms(
          onNewMessage: onMessage,
          onBackgroundMessage: onBackgroundMessageInState);
    }

    // if (!mounted) return;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'SMS Relay',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.deepPurple,
          ),
          home: const MyHomePage(title: 'SMS Relay'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sms = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.initPlatformState();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // debugPrint(context.);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SMSStream(),
        ],
      )),
    );
  }
}

class SMSStream extends StatelessWidget {
  const SMSStream({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var messages = appState.messages;
    debugPrint("listvew: " + messages!.length.toString());
    return Expanded(
      child: ListView(children: [
        for (var msg in messages!)
          MsgCard(message: msg.body!, sender: msg.address!),
      ]
          // const <MsgCard>[
          //   MsgCard(sender: 'Mr. 1'),
          //   MsgCard(sender: 'Mr. 2'),
          //   MsgCard(sender: 'Ms. 3'),
          //   MsgCard(sender: 'Mrs. 4'),
          //   MsgCard(sender: 'Mr. 1'),
          //   MsgCard(sender: 'Mr. 2'),
          //   MsgCard(sender: 'Ms. 3'),
          //   MsgCard(sender: 'Mrs. 4'),
          //   MsgCard(sender: 'Mr. 1'),
          //   MsgCard(sender: 'Mr. 2'),
          //   MsgCard(sender: 'Ms. 3'),
          //   MsgCard(sender: 'Mrs. 4'),
          //   MsgCard(sender: 'Mr. 1'),
          //   MsgCard(sender: 'Mr. 2'),
          //   MsgCard(sender: 'Ms. 3'),
          //   MsgCard(sender: 'Mrs. 4'),
          //   MsgCard(sender: 'Mr. 1'),
          //   MsgCard(sender: 'Mr. 2'),
          //   MsgCard(sender: 'Ms. 3'),
          //   MsgCard(sender: 'Mrs. 4'),
          //   MsgCard(sender: 'Mr. 1'),
          //   MsgCard(sender: 'Mr. 2'),
          //   MsgCard(sender: 'Ms. 3'),
          //   MsgCard(sender: 'Mrs. 4'),
          //   MsgCard(sender: 'Mr. 1'),
          //   MsgCard(sender: 'Mr. 2'),
          //   MsgCard(sender: 'Ms. 3'),
          //   MsgCard(sender: 'Mrs. 4'),
          // ],
          ),
    );
  }
}

class MsgCard extends StatelessWidget {
  const MsgCard({super.key, required this.sender, required this.message});
  final String sender;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.message),
              title: Text('$message'),
              subtitle: Text('from: $sender'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
