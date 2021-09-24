import 'package:flutter/material.dart';
import 'tts.dart';
class saved extends StatefulWidget {
  const saved({Key ?key}) : super(key: key);

  @override
  _savedState createState() => _savedState();
}

class _savedState extends State<saved> {
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved"),
      ),
      body: Container(
        child: Column(
          children: [
            Text("CAN YOU SPELL THE WORD FOR ME"),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Theme(
                data: ThemeData(
                  primaryColor: Color(0xffFFFFFF),
                  primaryColorDark: Color(0xffFFFFFF),
                ),
                child: TextField(
                    controller: password,
                    cursorColor: Color(0xff90E5BF),
                    decoration: InputDecoration(
                        filled: true,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Password",
                        fillColor: Color(0xffFFFFFF),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ))),
              ),
            ),
            GestureDetector(
              onTap: () {
                print(password);
               if (password.text=="ello")
                 {
                   speak("yipee thats correct");

                 }
               else {
                 speak ("oops try again");
               }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 1.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF0EFFE),
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                            2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text('Sign In',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff4C3C88),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat')),
                      )
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

