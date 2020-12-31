import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LocalAuthentication localAuthentication = LocalAuthentication();
  List<BiometricType> availableBiometrics;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
  }

  void _getAvailableBiometrics() async {
    List<BiometricType> _availableBiometrics =
        await localAuthentication.getAvailableBiometrics();
    print(_availableBiometrics);
    setState(() {
      availableBiometrics = _availableBiometrics;
    });
  }

  void _authenticate() async {
    try {
      List<BiometricType> _availableBiometrics =
          await localAuthentication.getAvailableBiometrics();
      if (_availableBiometrics.length > 0 && await _isBiometricAvailable()) {
        bool _isAuthenticated =
            await localAuthentication.authenticateWithBiometrics(
          localizedReason: "인증",
          androidAuthStrings: AndroidAuthMessages(
            fingerprintRequiredTitle: "requiredTitle",
            signInTitle: "title",
            fingerprintHint: "hint",
            goToSettingsDescription: "Description",
            cancelButton: "취소",
            fingerprintNotRecognized: "asdas",
            fingerprintSuccess: "asdas",
            goToSettingsButton: "asdas",
          ),
          useErrorDialogs: true,
          stickyAuth: true,
        );
        setState(() {
          isAuthenticated = _isAuthenticated;
        });
      } else {
        print("Not Available");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> _isBiometricAvailable() async {
    try {
      bool isAvailable = await localAuthentication.canCheckBiometrics;
      return isAvailable;
    } catch (e) {
      print(e);
    }
  }

  void _resetAuthentication() {
    setState(() {
      isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'isAuthenticated $isAuthenticated',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _getAvailableBiometrics,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _authenticate,
            tooltip: 'Increment',
            child: Icon(Icons.animation),
          ),
          FloatingActionButton(
            onPressed: _resetAuthentication,
            tooltip: 'Increment',
            child: Icon(Icons.refresh),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
