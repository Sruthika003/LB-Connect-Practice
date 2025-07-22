// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path/path.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lb_connect_sample_project/network/api_client.dart';
// import 'package:lb_connect_sample_project/network/api_services.dart';
// import 'package:lb_connect_sample_project/utils/alert_utils.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lb_connect_sample_project/model/appDatabase.dart';
import 'package:lb_connect_sample_project/model/personal_details.dart';
import 'package:lb_connect_sample_project/utils/alert_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path; // for basename
import 'firebase_messaging_service.dart';
import 'network/api_client.dart';
//import 'network/api_services.dart';

late final AppDatabase appDatabase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessagingService().init();
  appDatabase = await $FloorAppDatabase
      .databaseBuilder("app_database.db")
      .build();
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BasicInfo());
  }
}

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  FilePickerResult? _filePickerResult;
  File? _image;
  File? _selectedFile;
  String? _fileName;

  // File? _copiedImage;
  File? _copiedImage; // declare in your state
  Future<List<PersonalDetails>>? _futureData;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final List<TextEditingController> _otpController = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodeController = List.generate(
    6,
    (_) => FocusNode(),
  );
  bool _showOtpField = false;

  void nextStep() {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      edgeAlertDialog(context, "Please enter all the required fields.");
      return;
    }

    if (!_emailController.text.trim().contains('@') ||
        !_emailController.text.trim().contains('.')) {
      edgeAlertDialog(context, "Please enter a valid email address.");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Center(
                  child: Text(
                    "Personal Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: "First Name",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "First name",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]'),
                          ), // only letters
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: "Middle Name",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _middleNameController,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Middle name",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]'),
                          ), // only letters
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: "Last Name",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Last name",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]'),
                          ), // only letters
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: "Email Address",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Email address",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ), // Removes all default borders
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 9, bottom: 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     // Align to right
              //     children: [
              //       ElevatedButton(
              //         onPressed: () {
              //           verifyOTP();
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.blueGrey,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(5),
              //           ),
              //         ),
              //         child: Text(
              //           "Verify",
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // _showOtpField?
              // Padding(padding: const EdgeInsets.only(top:10, bottom: 5),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text("Please enter the OTP sent to ${_emailController.text.trim()}",style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),),
              //     SizedBox(height:10),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: List.generate(6, (index){
              //         return Container(
              //           width: 40,
              //           margin: EdgeInsets.symmetric(horizontal: 5),
              //           child: TextField(
              //             controller: _otpController[index],
              //             focusNode: _otpFocusNodeController[index],
              //               keyboardType: TextInputType.number,
              //                textAlign: TextAlign.center,
              //             maxLength: 1,
              //         onChanged: (value)
              //         {
              //           if(value.isNotEmpty){
              //         if (index < 5) {
              //         FocusScope.of(context).requestFocus(_otpFocusNodeController[index + 1]);
              //         } else {
              //         _otpFocusNodeController[index].unfocus();
              //         }
              //         } else if (value.isEmpty && index > 0) {
              //         FocusScope.of(context).requestFocus(_otpFocusNodeController[index - 1]);
              //         }
              //         },
              //         decoration: InputDecoration(
              //         counterText: '',
              //         enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Colors.grey),
              //         ),
              //         focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Colors.black),
              //         ),
              //         ),
              //         ),);
              //       }
              //       )
              //     ),
              //     SizedBox(height: 10,),
              //     ElevatedButton(onPressed: () {
              //       String otp = _otpController.map((controller) => controller.text).join();
              //     print("Entered OTP: $otp");
              //     },
              //       child: Text("Go", style: TextStyle(color: Colors.white),),
              //       style: ElevatedButton.styleFrom(
              //         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //         backgroundColor: Colors.blueGrey,
              //       ),)
              //   ],
              // ),) : SizedBox(),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20, bottom: 5),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         flex: 1,
              //         child: ElevatedButton(
              //           onPressed: () {},
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.white,
              //             padding: const EdgeInsets.symmetric(
              //               vertical: 5,
              //               horizontal: 2,
              //             ),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(5),
              //               side: BorderSide(color: Colors.black),
              //             ),
              //           ),
              //           child: Text(
              //             "Back to Login",
              //             style: TextStyle(color: Colors.black, fontSize: 14),
              //           ),
              //         ),
              //       ),
              //       Expanded(flex: 1, child: SizedBox(width: 10)),
              //       Expanded(
              //         flex: 1,
              //         child: ElevatedButton(
              //           onPressed: () {
              //             nextStep();
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.blueGrey,
              //             padding: const EdgeInsets.symmetric(
              //               vertical: 5,
              //               horizontal: 6,
              //             ),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(5),
              //             ),
              //           ),
              //
              //           child: Text(
              //             "Next Step",
              //             style: TextStyle(color: Colors.white, fontSize: 14),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: "Country",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(right: 0),
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCountry,
                            isExpanded: true,
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                'Select Country',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedCountry = value!;
                              });
                            },
                            items: countryList
                                .map(
                                  (String? country) => DropdownMenuItem<String>(
                                    value: country,
                                    child: Text(country ?? ''),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: "District",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _districtController,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "District",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z]'),
                          ), // only letters
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: "Pincode",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _pincodeController,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Pincode",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: "Profile image",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _copiedImage != null
                          ? GestureDetector(
                              onTap: () => showImageInDialog(context),
                              child: Image.file(_copiedImage!, height: 200),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 12, top: 10),
                              child: Text("No image selected"),
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: ElevatedButton(
                  onPressed: () => _showBottomShow(context),
                  child: Text("Pick Image"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: RichText(
                        text: TextSpan(
                          text: "Upload file",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _fileName != null
                          ? GestureDetector(
                              onTap: () => openPdfViewer(),
                              child: Text("$_fileName"),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 10, left: 12),
                              child: Text("No file selected"),
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: ElevatedButton(
                  onPressed: () => pickDocument(),
                  child: Text("Upload file"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () async {
                        insertPersonalDetails();
                      },
                      child: Text("Add data"),
                    ),
                    SizedBox(width: 70),
                    ElevatedButton(
                      onPressed: () async {
                        getPersonalData();
                        setState(() {
                          _futureData = appDatabase.personalDetailsDao
                              .fetchDataFromPersonalDetails();
                        });
                      },
                      child: Text("Get details"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9, bottom: 5),
                child: Row(
                  children: [
                    SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () async {
                        updatePersonalDetails();
                      },
                      child: Text("Update"),
                    ),
                    SizedBox(width: 95),
                    ElevatedButton(
                      onPressed: () async {
                        deleteuser();
                      },
                      child: Text("Delete"),
                    ),
                  ],
                ),
              ),
              if (_futureData != null)
                FutureBuilder<List<PersonalDetails>>(
                  future: _futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      final list = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final person = list[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  "Id: ${person.id}\n"
                                  "First Name: ${person.firstName}\n"
                                  "Middle Name: ${person.middleName}\n"
                                  "Last Name: ${person.lastName}\n"
                                  "Email Address: ${person.emailAddress}",
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Text("No data found");
                    }
                  },
                ),

              // or Text("Click 'Get details' to fetch data")
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
  }

  @override
  void initState() {
    super.initState();
    //fetchCountries();
  }

  // verifyOTP() async{
  //   if(await checkInternetConnection()){
  //     showLoadingDialog(context, message: "Loading Please wait...");
  //
  //     Map<String, dynamic> requestData = {
  //       "first_name": _firstNameController.text.trim(),
  //       "middle_name": _middleNameController.text.trim(),
  //       "last_name": _lastNameController.text.trim(),
  //       "email": _emailController.text.trim()
  //     };
  //  print(requestData.toString());
  //     ApiService apiService = ApiService(ApiClient.getDio());
  //     final response = await apiService.signUp(requestData);
  //     print(response.response_code);
  //
  //     if(response.response_code == "200") {
  //       hideLoadingDialog(context);
  //       edgeAlertDialog(context, response.message);
  //       setState(() {
  //         _showOtpField = true; // show OTP input now
  //       });
  //     } else {
  //       hideLoadingDialog(context);
  //       edgeAlertDialog(context, response.message);
  //     }
  //
  //   }else{
  //     edgeAlertDialog(context, "Please check the internet connection.");
  //   }
  // }

  List<String?> countryList = [];
  String? _selectedCountry;
  bool isLoading = true;

  // void fetchCountries() async {
  //   try {
  //     ApiService apiService = ApiService(ApiClient.getDio());
  //     final response = await apiService.getCountry();
  //     countryList = response.countryEntity!
  //         .data!
  //         .map((country) => country!.countryName).toList();
  //     setState(() {
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> pickDocument() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedImage == null) return; // User canceled

    final pickedImageFile = File(pickedImage.path);
    final fileName = path.basename(pickedImage.path);

    // Ensure the original file is not empty before copying
    if (await pickedImageFile.exists() && await pickedImageFile.length() > 0) {
      final appDir = await getApplicationCacheDirectory();
      final newPath = path.join(appDir.path, fileName);

      final copiedFile = await pickedImageFile.copy(newPath);

      setState(() {
        _copiedImage = File(pickedImage.path);
      });
    }

    // final pickedFile = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf']
    // );
    //
    // if (pickedFile != null && pickedFile.files.single.path != null) {
    //   if (!mounted) return; // Avoid setState after dispose
    //   setState(() {
    //     _selectedFile = File(pickedFile.files.single.path!);
    //     _fileName = pickedFile.files.single.name;
    //     _filePickerResult = pickedFile;
    //   });
    // }
  }

  // Future<void> copiedImage() async{
  //    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
  //    if(pickedImage == null) return;
  //      final  pickedImagePath = File(pickedImage.path);
  //      final fileName = path.basename(pickedImage.path);
  //
  //      final appDir = await getApplicationCacheDirectory();
  //       final newPath = '${appDir.path}/$fileName';
  //        final copyFilePath = await File(pickedImagePath.path).copy(newPath);
  //
  //        setState(() {
  //          _copiedImage = copyFilePath;
  //        });
  //
  //        print("$pickedImagePath");
  //        print("$copyFilePath");
  // }

  Future<void> pickImage(ImageSource source) async {
    print(source);
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void openPdfViewer() {
    if (_selectedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewer(pdfPath: _selectedFile!.path),
        ),
      );
    }
  }

  void showImageInDialog(BuildContext context) {
    if (_image == null) return; // Prevent crash if image not picked

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Image",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.file(_image!),
                    SizedBox(height: 10),
                    // TextButton(
                    //   onPressed: () => Navigator.pop(context),
                    //   child: Text("Close"),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomShow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.grey,
          padding: const EdgeInsets.all(15),
          child: Wrap(
            children: [
              ListTile(
                title: Text("Camera", style: TextStyle(color: Colors.black)),
                leading: Icon(Icons.camera_alt_outlined, color: Colors.black),
                onTap: () => pickImage(ImageSource.camera),
              ),
              ListTile(
                title: Text("Gallery", style: TextStyle(color: Colors.black)),
                leading: Icon(Icons.image, color: Colors.black),
                onTap: () => pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  void insertPersonalDetails() async {
    final firstName = _firstNameController.text.trim();
    final middleName = _middleNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final emailAddress = _emailController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || emailAddress.isEmpty) {
      edgeAlertDialog(context, "Please enter all the required fields.");
      return;
    }

    if (!_emailController.text.trim().contains('@') ||
        !_emailController.text.trim().contains('.')) {
      edgeAlertDialog(context, "Please enter a valid email address.");
      return;
    }

    final personal = PersonalDetails(
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      emailAddress: emailAddress,
    );
    await appDatabase.personalDetailsDao.insertPersonalDetails(personal);

    edgeAlertDialog(context, "data saved successfully");
  }

  Future<void> getPersonalData() async {
    final personalList = await appDatabase.personalDetailsDao
        .fetchDataFromPersonalDetails();
    for (var personal in personalList) {
      print(
        "firstName: ${personal.firstName}, middleName: ${personal.middleName}, lastName: ${personal.lastName}, emailAddress: ${personal.emailAddress}",
      );
    }
  }

  void updatePersonalDetails() async {
    await appDatabase.personalDetailsDao.updateDataUsedById(
      3,
      "updated firstname",
      "updated middleName",
      "updated lastName",
      "updated emailAddress",
    );
  }

  void deleteuser() async {
    await appDatabase.personalDetailsDao.deletePersonById(4);
  }
}

class PdfViewer extends StatelessWidget {
  final String pdfPath;

  const PdfViewer({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Show Document",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        backgroundColor: Colors.grey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SfPdfViewer.file(File(pdfPath)),
    );
  }
}
