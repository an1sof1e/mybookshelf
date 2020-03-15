import 'package:flutter/material.dart';
import 'package:mybookshelf/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:email_validator/email_validator.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool emailcheck = false;
  bool validateMobile = false;
  String phoneErrorMessage;

  double screenHeight;
  bool _isChecked = false;
  GlobalKey<FormState> _key = new GlobalKey();
  String urlRegister = "https://www.asaboleh.com/mybookshelf/php/register_user.php";
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  //bool _validate = false;
  String name, email, password, phone;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
   
   return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      title: 'Material App',
      home: Scaffold(
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
      height: 800,
      margin: EdgeInsets.only(top: screenHeight / 2.7),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            key: _key,
            shape: ContinuousRectangleBorder(
              side: BorderSide(color: Colors.black, width : 3.0),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 3, 20, 7),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Register Here!",
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
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Name',
                        hintText: 'Aminah Saad',
                        icon: Icon(Icons.person,
                        color: Colors.blue[800]),
                        //validator: validateName,
                        /*onSaved: (String val){
                        name = val;
                        },*/
                      ),),
                  ),
                  Padding( 
                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                        hintText: 'abcdef95@example.com',
                     
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
                      hintText: 'Must be more than 8 alphanumeric',
                      icon: Icon(Icons.lock,
                      color: Colors.blue[800]),
                    ),
                    obscureText: true,
                  ),
                  ),
                  Padding( 
                   padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Phone',
                        hintText: '01xxxxxxxx',
                        icon: Icon(Icons.phone,
                        color: Colors.blue[800]),
                      )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Checkbox(
                        checkColor: Colors.black,
                        activeColor: Colors.blue[800],
                        value: _isChecked,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      GestureDetector(
                        onTap: _showEULA,
                        child: Text('I Agree to Terms',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 115,
                        height: 50,
                        child: Text('Register'),
                        color: Colors.blue[800],
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: _onRegister
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
              Text("Already register? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _loginScreen,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
      //color: Color.fromRGBO(255, 200, 200, 200),
      margin: EdgeInsets.only(top: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  /*void _confirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirmation"),
          content: new Container(
            height: 20,
            child: Column(
              children: <Widget>[
                Text("Continue registration?"),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: _onRegister
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/

  void _onRegister() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Confirm?"),
          content: new Text("Do you want to register using this email?\n\nEmail can only registered once!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
          onPressed: () {
            Navigator.push(context,
          MaterialPageRoute(
            builder: (BuildContext context) => 
            LoginScreen()));
          }),

           new FlatButton(
                  child: new Text("No, I wish to double check"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });

    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String phone = _phoneController.text;

    emailcheck = EmailValidator.validate(email);
    validateMobile(String phone) {
      String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp regExp = new RegExp(pattern);
      if (phone.length == 0) {
        phoneErrorMessage = 'Please enter mobile number';
        return false;
      } else if (!regExp.hasMatch(phone)) {
        phoneErrorMessage = 'Please enter valid mobile number';
        return false;
      }
      return true;
    }

    if (name.length == 0) {
      Toast.show("Please Enter Your Name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (email.length == 0) {
      Toast.show("Please Enter Your Email", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (emailcheck == false) {
      Toast.show("Invalid Email Format", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (password.length == 0) {
      Toast.show("Please Enter Your Password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (validateMobile(phone) == false) {
      Toast.show(phoneErrorMessage, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    return;

    } else if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Registration Successful", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  } 
  

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("End-User License Agreement"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and ASABOLEH This EULA agreement governs your acquisition and use of our MY BOOK SHELF software (Software) directly from ASABOLEH or indirectly through a ASABOLEH authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the MY BOOK SHELF software. It provides a license to use the MY BOOK SHELF software and contains warranty information and liability disclaimers. If you register for a free trial of the MY BOOK SHELF software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the MY BOOK SHELF software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement. This EULA agreement shall apply only to the Software supplied by ASABOLEH here with regardless of whether other software is referred to or described herein. The terms also apply to any ASABOLEH updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for MY BOOK SHELF. ASABOLEH shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of ASABOLEH. ASABOLEH reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)),
              child: new Text("Close"),
               color: Colors.blue[800],
               textColor: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

/*String validateName(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Name is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return null;
}

String validateMobile(String value) {
  String patttern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Mobile is Required";
  } else if (value.length < 10) {
    return "Mobile number must be at least 10 digits";
  } else if (!regExp.hasMatch(value)) {
    return "Mobile Number must be digits";
  }
  return null;
}

String validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Email is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Invalid Email";
  } else {
    return null;
  }
}

String validatePass(String value) {
  String patttern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Password is Required";
  } else if (value.length < 6) {
    return "Password must be at least 8 alphanumerics";
  } else if (!regExp.hasMatch(value)) {
    return "Password must contain at least an alphabet and a digit";
  }
  return null;*/


  
