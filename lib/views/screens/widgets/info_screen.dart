import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/controller/auth_controller.dart';
import 'package:learnmate/provider/user_provider.dart';

class InfoScreen extends ConsumerWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    TextEditingController stateController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController hobbyController = TextEditingController();
    final AuthController authController = AuthController();
    String? _selectedBoard;
    String? _selectedClass;
    List<String> boards = [
      'CBSE',
      'MP Board',
      'ICSE',
      'OTHER'
    ];
    List<String> classes = [
      'Class 10th',
      'Class 11th',
      'Class 12th'
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Info Screen",style: GoogleFonts.montserrat(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1.7,
        ),),
        SizedBox(height: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Your Board",style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.7,
            ),),
            CustomDropdown<String>(
              onChanged: (value){
                _selectedBoard = value!;
              },
              hintText: 'Select Board',
              items: boards,
              decoration: CustomDropdownDecoration(
                closedFillColor: Colors.grey.shade300,
                expandedFillColor: Colors.grey.shade300,
                hintStyle: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.7,
                )
              ),
            ),
            Text("Select Your Class",style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.7,
            ),),
            CustomDropdown<String>(
              onChanged: (value){
                _selectedClass = value!;
              },
              hintText: 'Select Class',
              items: classes,
              decoration: CustomDropdownDecoration(
                  closedFillColor: Colors.grey.shade300,
                  expandedFillColor: Colors.grey.shade300,
                  hintStyle: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.7,
                  )
              ),
            ),
            SizedBox(height: 10,),
            Text("Please Enter Your State",style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.7,
            ),),
            TextField(
              controller: stateController,
              decoration: InputDecoration(
                hintText: "Enter Your State",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              )
            ),
            Text("Please Enter Your City",style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.7,
            ),),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                hintText: "Enter Your City",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              )
            ),
            Text("Please Enter Any Hobby You Have",style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.7,
            ),),
            TextField(
              controller: hobbyController,
              decoration: InputDecoration(
                hintText: "Enter Your Hobby",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              )
            ),
            SizedBox(height: 20,),
            Center(
              child: TextButton(
                  onPressed: (){
                    authController.updateStudentDetail(
                        userId: ref.read(userProvider)!.id,
                        board: _selectedBoard!,
                        studentClass: _selectedClass!,
                        state: stateController.text,
                        city: cityController.text,
                        interest: hobbyController.text,
                        context: context,
                      ref: ref
                    );
                  },
                  style:  TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    backgroundColor: Colors.blueAccent
                  ),
                  child: Text("Submit",style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.7,
              ),)),
            )
          ],
        ),

      ],
    );
  }
}
