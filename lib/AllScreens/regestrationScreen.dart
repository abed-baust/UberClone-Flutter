import 'package:bismillah/AllScreens/loginScreen.dart';
import 'package:bismillah/AllScreens/mainscreen.dart';
import 'package:bismillah/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "register";

  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController phonetextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Register as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: nametextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                            fontSize: 14.0, fontFamily: "Brand-Regular"),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                            fontFamily: "Brand-Regular"),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: emailtextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            fontSize: 14.0, fontFamily: "Brand-Regular"),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                            fontFamily: "Brand-Regular"),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: phonetextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                            fontSize: 14.0, fontFamily: "Brand-Regular"),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                            fontFamily: "Brand-Regular"),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: passwordtextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                            fontSize: 14.0, fontFamily: "Brand-Regular"),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontFamily: "Brand-Regular"),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand-Regular"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () {
                        if (nametextEditingController.text.length < 3) {
                          displayToastMessage(
                              "Name must be atleast 3 characters", context);
                        } else if (!emailtextEditingController.text
                            .contains("@")) {
                          displayToastMessage(
                              "Email address is not valid..", context);
                        } else if (phonetextEditingController.text.isEmpty) {
                          displayToastMessage(
                              "Phone Number is mandatory..", context);
                        } else if (passwordtextEditingController.text.length < 6) {
                          displayToastMessage(
                              "Password Must be atleast 6 Characters..",
                              context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text("Already have an Account? Login Here.."),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
   final User? firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailtextEditingController.text,
            password: passwordtextEditingController.text)
        .catchError((errMsg) {
      displayToastMessage(errMsg.toString(), context);
    })).user;

    if (firebaseUser != null) {
      Map userDataMap = {
        "name": nametextEditingController.text.trim(),
        "email": emailtextEditingController.text.trim(),
        "phone": phonetextEditingController.text.trim(),
      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Congratulations..", context);
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    } else {
      displayToastMessage("New User has not been created..", context);
    }
  }

  displayToastMessage(String masg, BuildContext context) {
    Fluttertoast.showToast(msg: masg);
  }
}
