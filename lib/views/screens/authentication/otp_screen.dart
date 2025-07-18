import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnmate/controller/auth_controller.dart';

class OtpScreen extends ConsumerWidget {
  OtpScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication Via OTP"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                enabled: true,
                labelText: "Enter Your Email",
                labelStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                )
              ),
            ),
          ),
          ElevatedButton(
              onPressed: ()async{
                await AuthController().sendOtp(
                    email: emailController.text,
                    context: context,
                    ref: ref
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>
                            Scaffold(
                              appBar: AppBar(
                                leading: IconButton(onPressed:()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new)),
                              ),
                              body: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(
                                    "Enter The OTP That You Received From The Email",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: Colors.black,
                                      letterSpacing: 1.8
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  OtpTextField(
                                    numberOfFields: 6,
                                    borderColor: Color(0xFF512DA8),
                                    //set to true to show as box or false to show as dash
                                    showFieldAsBox: true,
                                    //runs when a code is typed in
                                    onCodeChanged: (String code) {
                                      //handle validation or checks here
                                    },
                                    //runs when every textfield is filled
                                    onSubmit: (String verificationCode)async{
                                      await AuthController().verifyOtp(email: emailController.text, otp: verificationCode, context: context, ref: ref);
                                    },
                                  ),

                                  Text(
                                    "If You Didn't Received The OTP Within 5 Minutes,\nThen Go Back And Again Request For Send OTP",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                      letterSpacing: 1.8
                                    ),
                                    textAlign: TextAlign.center,
                                  )

                                ],
                              ),

                            )
                    )
                );
              },
              child: Text("Send Otp")
          )
        ],
      ),
    );
  }
}
