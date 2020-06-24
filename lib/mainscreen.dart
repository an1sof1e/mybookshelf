import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybookshelf/adminproduct.dart';
import 'package:mybookshelf/paymenthistoryscreen.dart';
import 'package:mybookshelf/profilescreen.dart';
import 'package:mybookshelf/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cartscreen.dart';
import 'profilescreen.dart';


class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen ({Key key, this.user}) : super(key: key);
  
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  bool _isadmin = false;
  String titlecenter = "Loading books . . .";

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartQuantity();
     if (widget.user.email == "admin@mybookshelf.com") {
      _isadmin = true;
     }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();
    
 return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.purple[300],
          drawer: mainDrawer(context),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[300],
          title: Text('Books List',
          style: TextStyle(
              color: Colors.white,),
          ),
          actions: <Widget>[
            IconButton(
              icon: _visible
                  ? new Icon(Icons.expand_more)
                  : new Icon(Icons.expand_less),
              onPressed: () {
                setState(() {
                  if (_visible) {
                    _visible = false;
                  } else {
                    _visible = true;
                  }
                });
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: _visible,
                child: Card(
                    elevation: 10,
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Recent"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.update,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Recent",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Romance"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.beer,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Romance",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Drama"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.foodVariant,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Drama",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Religion"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.foodApple,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Religion",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Poetry"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.fish,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Poetry",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              /*Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Bread"),
                                      color: Colors.blue[500],
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.breadSlice,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Bread",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                               SizedBox(
                                width: 3,
                              ),*/
                              Column(
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () => _sortItem("Others"),
                                      color: Color.fromRGBO(101, 255, 218, 50),
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.ornament,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "Others",
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ))),
              ),
              
              Visibility(
                  visible: _visible,
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: screenHeight / 12.5,
                      margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                              child: Container(
                            height: 30,
                            child: TextField(
                              style: TextStyle(
                                    color: Colors.black,),
                                autofocus: false,
                                controller: _prdController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.search),
                                    border: OutlineInputBorder())),
                          )),
                         Flexible(
                              child: MaterialButton(
                                  color: Colors.blue[500],
                                  onPressed: () =>
                                      {_sortItembyName(_prdController.text)},   
                                  elevation: 5,
                                  child: Text(
                                    "Search Product",
                                    style: TextStyle(color: Colors.white),
                                  )))
                        ],
                      ),
                    ),
                  )),
              Text(curtype,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
                    productdata == null
                    ? Flexible(
                        child: Container(
                            child: Center(
                                child: Text(
                        titlecenter,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ))))
              : Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (screenWidth / screenHeight) / 0.80,
                      children: List.generate(
                        productdata.length, (index) {
                        return Card(
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => _onImageDisplay(index),
                                    child: Container(
                                        height: screenWidth / 3.5,
                                        width: screenWidth / 3.5,
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                          fit: BoxFit.scaleDown,
                                        imageUrl:
                                         "https://www.asaboleh.com/mybookshelf/productimage/${productdata[index]['id']}.jpg",
                                         placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                        )),
                                    ),
                                  ),
                                
                                  Text(productdata[index]['name'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  Text(
                                    "RM " + productdata[index]['price'],
                                    style:
                                        TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                  ),
                                  Text("Quantity available: " +
                                      productdata[index]['quantity'],
                                      style: TextStyle(color: Colors.black),),
                                  Text("Weight: " +
                                      productdata[index]['weight'] +
                                      " gram",
                                      style: TextStyle(color: Colors.black),),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    minWidth: 100,
                                    height: 30,
                                    child: Text(
                                      'Add to Cart'),
                                    color: Colors.blue[500],
                                    textColor: Colors.white,
                                    elevation: 10,
                                    onPressed: () => _addtoCartdialog(index),
                                  ),
                                ],
                              ),
                            ));
                      })))
                      
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
              if (widget.user.email == "unregistered") {
                Toast.show("Please register to use this function", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.email == "admin@mybookshelf.com") {
                Toast.show("Admin mode!!!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.quantity == "0") {
                Toast.show("Cart empty", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else {
                await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CartScreen(
                          user: widget.user,
                        )));
                        _loadData();
                        _loadCartQuantity();
              }
          },
          icon: Icon(Icons.add_shopping_cart),
          label: Text(cartquantity),
        ),
     ));
    }
  

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
          height: screenHeight / 2.2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: screenWidth / 1.5,
                  width: screenWidth / 1.5,
                  decoration: BoxDecoration(
                      //border: Border.all(color: Colors.black),
                      image: DecorationImage(
                          fit: BoxFit.scaleDown,
                          image: NetworkImage(
                              "https://www.asaboleh.com/mybookshelf/productimage/${productdata[index]['id']}.jpg")))),
            ],
          ),
        ));
      },
    );
  }

  void _loadData() {
    String urlLoadJobs = "https://www.asaboleh.com/mybookshelf/php/load_products.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        print(res.body);
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
        cartquantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = "https://www.asaboleh.com/mybookshelf/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            /*otherAccountsPictures: <Widget>[
              Text(widget.user.name,
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ],*/
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
              /*backgroundImage: NetworkImage(
                  "https://www.asaboleh.com/profileimages/${widget.user.email}.jpg?"),*/
            ),
            onDetailsPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileScreen(
                            user: widget.user,
                          )))
            },
          ),
         ListTile(
            title: Text("Book List",
            style: TextStyle(
                  color: Colors.black,
                ),
              ),
              trailing: Icon(Icons.arrow_forward), 
              onTap: () => {
                    Navigator.pop(context),
                    _loadData(),
                  }),
          ListTile(
              title: Text("Shopping Cart",
              style: TextStyle(
                  color: Colors.black,
                  ),
                  ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    gotoCart(),
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => CartScreen(
                                  user: widget.user,
                                )))*/
                  }),
          ListTile(
            title: Text("Payment History",
            style: TextStyle(
                  color: Colors.black,
                  ),
                  ),
            trailing: Icon(Icons.arrow_forward),
             onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PaymentHistoryScreen(
                                  user: widget.user,
                                ))),
                  }),
          ListTile(
            title: Text("User Profile",
            style: TextStyle(
                  color: Colors.black,
                  ),
                  ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => {
              Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ProfileScreen(
                    user: widget.user,
                  )))
            }),
             Visibility(
            visible: _isadmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 2,
                  color: Colors.black,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(color: Colors.black,
                    ),
                  ),
                ),
                ListTile(
                    title: Text(
                      "My Products",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                    AdminProduct(
                                        user: widget.user,
                                      )))
                        }),
                ListTile(
                  title: Text(
                    "Customer Orders",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
                ListTile(
                  title: Text(
                    "Report",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  _addtoCartdialog(int index) {
    if (widget.user.email == "unregistered@mybookshelf.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@mybookshelf.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    quantity = 1;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: 
        (context, newSetState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          "Add " + productdata[index]['name'] + " to Cart?",
          style: TextStyle(
                  color: Colors.black,
                ),),
          content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select quantity of product",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.blue[500],
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(productdata[index]['quantity']) -
                                        10)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.blue[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),       

        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _addtoCart(index);
              },
              child: Text(
                "Yes",
              style: TextStyle(
                        color: Colors.blue[500],
                        ),
                        )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
              style: TextStyle(
                        color: Colors.blue[500],
          ),
          )),
        ],
      );
        });
        });
  }

  void _addtoCart(int index) {
    if (widget.user.email == "unregistered@mybookshelf.com") {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@mybookshelf.com") {
      Toast.show("Admin mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    try {
      int cquantity = int.parse(productdata[index]["quantity"]);
      print(cquantity);
      print(productdata[index]["id"]);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        String urlLoadJobs =
            "https://www.asaboleh.com/mybookshelf/php/insert_cart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "proid": productdata[index]["id"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                pr.hide();
                return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pr.hide();
        }).catchError((err) {
          print(err);
          pr.hide();
        });
        pr.hide();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://www.asaboleh.com/mybookshelf/php/load_products.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        setState(() {
          curtype = type;
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          FocusScope.of(context).requestFocus(new FocusNode());
          pr.hide();
        });
      }).catchError((err) {
        print(err);
        pr.hide();
      });
      pr.hide();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() async {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@mybookshelf.com") {
      Toast.show("Admin mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.quantity == "0") {
      Toast.show("Cart empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
      _loadData();
      _loadCartQuantity();
    }
  }

  void _sortItembyName(String prname) {
    try {
      print(prname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching . . .");
      pr.show();
      String urlLoadJobs =
          "https://www.asaboleh.com/mybookshelf/php/load_products.php";
      http.post(urlLoadJobs, body: {
            "name": prname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Product not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.hide();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              productdata = extractdata["products"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curtype = prname;
              pr.hide();
            });
          })
          .catchError((err) {
            pr.hide();
          });
      pr.hide();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Colors.blue[500],
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue[500],
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }
}



    