import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPage extends StatelessWidget {
  late String userName;
  late String userAge;
  late String userGender;

  UserPage(this.userName, this.userAge, this.userGender);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Name: ',
          style: GoogleFonts.poppins(
            fontSize: 20
          ),),
            Text(userName,
              style: GoogleFonts.poppins(
                  fontSize: 20
              ),),
          ],),
          SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Age: ',
          style: GoogleFonts.poppins(
              fontSize: 20
          ),),
          Text(userAge,
            style: GoogleFonts.poppins(
            fontSize: 20
        ),),],),
          SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.center,children:
          [Text('Gender: ',
            style: GoogleFonts.poppins(
                fontSize: 20
            ),),
            Text(userGender,
              style: GoogleFonts.poppins(
                  fontSize: 20
              ),
          ),],),
          SizedBox(height: 20,),
          ElevatedButton(
              child: Text('Exit'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD1D1)),
              onPressed: () {Navigator.pop(context);}),
        ],),),
    );
  }
}


