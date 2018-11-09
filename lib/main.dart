import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onesignal/onesignal.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String _debugLabelString = "";
  String _emailAddress;
  bool _enableConsentButton = false;

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  bool _requireConsent = false;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initOneSignal();
    initUniLinks(context);
  }

  void initOneSignal() {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
          print("OPENED NOTIFICATION");
          print(result.notification.jsonRepresentation().replaceAll("\\n", "\n"));
      this.setState(() {
        _debugLabelString =
        "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
            (OSEmailSubscriptionStateChanges changes) {
          print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
        });

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);


    OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

//  OneSignal.shared.init("your_app_id_here");
    final app_id = "YOUR APP ID HERE";
// You can also pass in iOS settings as a map.
// These settings are only applicable to iOS,
// and will be ignored in Android

    OneSignal.shared.init(
        app_id,
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl : true
        }
    );
  }

  StreamSubscription _sub;

  Future<Null> initUniLinks(BuildContext context) async {
    _sub = getLinksStream().listen((String link) {
      String parse = link.replaceFirst("EXAMPLE://anggach.com/", "");
      print("LINK IS ${link}");
      print("AFTER PARSE IS ${parse}");

      List<String> links = parse.split("/");
      switch (links[0]) {
        case "2":
          _goToPage2(context, links[1]);
          break;
        case "3":
          _goToPage3(context, links[1]);
          break;
        default:
          _goToPage2(context, links[1]);
          break;
      }

    }, onError: (error) {
      print("ERROR ${error.toString()}");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _sub?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

_goToPage2(BuildContext context, String content) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return Page2(content: content,);
      }
    )
  );
}

_goToPage3(BuildContext context, String content) {
  Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) {
            return Page3(content: content,);
          }
      )
  );
}

class Page2 extends StatefulWidget {

  final String content;

  Page2({this.content = "EMPTY"});

  _Page2State createState() => _Page2State();

}

class _Page2State extends State<Page2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Page 2"
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("THIS IS PAGE 2"),
              Text("CONTENT IS ${widget.content}")
            ],
          ),
        ),
      ),
    );
  }

}

class Page3 extends StatefulWidget {

  final String content;

  Page3({this.content = "EMPTY"});

  _Page3State createState() => _Page3State();

}

class _Page3State extends State<Page3> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Page 3"
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("THIS IS PAGE 3"),
              Text("CONTENT IS ${widget.content}")
            ],
          ),
        ),
      ),
    );
  }

}