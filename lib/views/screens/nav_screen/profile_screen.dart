import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnmate/controller/auth_controller.dart';
import 'package:learnmate/provider/user_provider.dart';
import 'package:learnmate/views/screens/widgets/edit_profile_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  final AuthController authController = AuthController();

  File? _selectedImage;

  Future<void> _pickImageFromGallery()async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)
                ),
                gradient: LinearGradient(
                    colors: [
                      Colors.lightBlueAccent.shade100,
                      Colors.blue.shade700
                    ]
                )
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                          radius: 100,
                          child: _selectedImage !=null ? ClipRRect(borderRadius: BorderRadius.circular(50),child: Image.file(_selectedImage!,fit: BoxFit.fill,)) : Text(
                            user!.fullname[0],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.grandHotel(
                                fontWeight: FontWeight.bold,
                                fontSize: 80,
                                color: Theme.of(context).colorScheme.onSurface
                            ),
                          )
                      ),
                      // Positioned(
                      //   bottom:5,
                      //     right:25,
                      //     child: InkWell(
                      //       onTap: (){
                      //         _pickImageFromGallery();
                      //       },
                      //       child: CircleAvatar(
                      //         radius: 20,
                      //         backgroundColor: Colors.grey.shade900,
                      //         child: Icon(
                      //           Icons.edit,
                      //           size:20 ,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     )
                      // )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text(
                    user!.fullname,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface
                    ),
                  ),
                  Text(
                    user.email,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface
                    ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                      onPressed: ()async{
                        return showDialog(
                            useRootNavigator: true,
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                content: EditProfileWidget(),
                              );
                            }
                        );
                      },
                      child: Text(
                          "Edit Profile",
                        style: GoogleFonts.cedarvilleCursive(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 2.5
                        ),
                      )
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(user.studentClass.isEmpty? "Board : ---" : "Board : ${user.board}",
                        style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 2.5
                      ),),
                      trailing: Icon(
                        Icons.developer_board,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    ListTile(
                      title: Text(user.studentClass.isEmpty? "Class : ---" : "Class : ${user.studentClass}",
                        style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 2.5
                      ),),
                      trailing: Icon(
                        Icons.school,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    ListTile(
                      title: Text(user.interest.isEmpty? "Hobby : ---" : "Hobby : ${user.interest}",
                        style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 2.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        Icons.local_activity_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),ListTile(
                      title: Text(user.city.isEmpty? "City : ---" : "City : ${user.city}",
                        style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 2.5
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        Icons.location_city,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    ListTile(
                      title: Text(user.city.isEmpty? "State : ---" : "State : ${user.state}",style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 2.5
                      ),),
                      trailing: Icon(
                        Icons.location_on_rounded,
                        size: 30,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        await authController.signOut(context: context, ref: ref);
                      },
                      child: ListTile(
                        title: Text("Logout",style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 2.5
                        ),),
                        trailing: Icon(
                          Icons.logout,
                          size: 30,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
}
