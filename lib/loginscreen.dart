import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybookshelf/registerscreen.dart';
import 'package:mybookshelf/mainscreen.dart';
import 'package:http/http.dart' as http;
import 'package:mybookshelf/user.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';


void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  @override
  /*final User user;
  const LoginScreen ({Key key, this.user}) : super(key: key);*/

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String urlLogin = "https://www.asaboleh.com/mybookshelf/php/login_user.php";

  @override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    this.loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.redAccent,
          body: Stack( 
            children: <Widget>[
              topSection(context),
              bottomSection(context),
              pageTitle(),
            ],
          )),
    );
  }

  Widget topSection(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget bottomSection(BuildContext context) {
    return Container(
      height: screenHeight / 1,
      margin: EdgeInsets.only(top: screenHeight / 2.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            shape: ContinuousRectangleBorder(
              side: BorderSide(color: Colors.black, width : 3.0),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 40),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Login Here!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600, 
                      ),
                    ),
                  ),
                 Padding( 
                   padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Email',
                        icon: Icon(Icons.email,
                        color: Colors.blue[800]),
                      )),
                 ),
                 Padding( 
                   padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      labelText: 'Password',
                      icon: Icon(Icons.lock,
                      color: Colors.blue[800]),
                    ),
                    obscureText: true,
                  ),
                 ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Checkbox(
                        checkColor: Colors.black,
                        activeColor: Colors.blue[800],
                        value: rememberMe,
                        onChanged: (bool value) {
                          _onRememberMeChanged(value);
                        },
                      ),
                      Text('Remember Me ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 50,
                        child: Text('Login'),
                        color: Colors.blue[800],
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: this._userLogin,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an account? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _registerUser,
                child: Text(
                  "Create Account",
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Forgot your password? ", style: TextStyle(color: Colors.black, fontSize: 16.0)),
              GestureDetector(
                onTap: _forgotPassword,
                child: Text(
                  "Reset Password",
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        /*children: <Widget>[
          Icon( 
            Icons.shopping_basket,4
        size: 40,
        color: Colors.pinkAccent,),]*/
      ),
    );
  }

  void _userLogin() async {
    try {
      ProgressDialog pr = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login . . .");
      pr.show();
    String email = _emailController.text;
    String password = _passwordController.text;

    http.post(urlLogin, body: {
      "email": email,
      "password": password,
    })
    
    
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
              pr.hide();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                            user: _user,
                          )));
            Toast.show("Login successful", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } else {
              pr.hide();
            Toast.show("Login failed", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          })
          .catchError((err) {
            print(err);
            pr.hide();
          });
    } on Exception  catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }


  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _forgotPassword() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Enter your recovery email",
                ),
                TextField(
                    decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ))
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
              },
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text('Are you sure?',
            style: TextStyle(
                color: Colors.black,
              ),),
            content: new Text('Do you want to exit the App',
            style: TextStyle(
                color: Colors.black,
              ),),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text("Exit",
                   style: TextStyle(
                      color: Colors.blue[500],
                   ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel",
                  style: TextStyle(
                      color: Colors.blue[500],
                  ),
                      )),
            ],
          ),
        ) ??
        false;
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email'))??'';
    String password = (prefs.getString('password'))??'';
    if (email.length > 1) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      setState(() {
        _emailController.text = '';
        _passwordController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}