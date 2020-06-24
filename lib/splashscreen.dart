import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:mybookshelf/loginscreen.dart';
import 'package:mybookshelf/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:toast/toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      title: 'Material App',
      home: Scaffold(
          body: Container(
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/splash.jpg'),
                        fit: BoxFit.cover))),
            Container(height: 300, child: ProgressIndicator())
          ],
        ),
      )),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            controller.stop();
            loadpref(this.context);

            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));*/
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
         
        child: CircularProgressIndicator(
        value: animation.value,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
      ),
    ));
  }
  void loadpref(BuildContext ctx) async {
    print('Inside loadpref()');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email') ?? '');
    String password = (prefs.getString('password') ?? '');
    print("Splash:Preference " + email + "/" + password);
    if (email.length > 5) {
      //login with email and password
      loginUser(email, password, ctx);
    } else {
      loginUser("unregistered","123456789",ctx);
    }
  }

  void loginUser(String email, String password, BuildContext ctx) {
   
    http.post("https://www.asaboleh.com/mybookshelf/php/login_user.php", body: {
      "email": email,
      "password": password,
    })
        //.timeout(const Duration(seconds: 4))
        .then((res) {
      print(res.body);
      var string = res.body;
      List userdata = string.split(",");
      if (userdata[0] == "success") {
        User _user = new User(
            name: userdata[1],
            email: email,
            password: password,
            phone: userdata[3],
            //credit: userdata[4],
            //datereg: userdata[5],
            quantity: userdata[4]);
   
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: _user,
                    )));
      } else {
        Toast.show("Fail to login with stored credential. Login as unregistered account.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        loginUser("unregistered@mybookshelf.com","123456789",ctx);
       }
    }).catchError((err) {
      print(err);
   
    });
  }


}

