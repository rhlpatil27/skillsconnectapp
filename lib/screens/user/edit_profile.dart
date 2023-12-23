import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
 import 'package:pce/models/user_events/update_details_model.dart';
import 'package:pce/screens/user/get_country_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../models/user_events/countries_model.dart';
import '../../network/api_provider.dart';
import '../../utils/singleton.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController jobTitle = TextEditingController();
  final TextEditingController company = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController linkedin = TextEditingController();
  CountriesModel responce = CountriesModel();
  UpdateDetailsModel updateResponce = UpdateDetailsModel();
  String? selectedData = 'Select Country';
  String? selectedDataId = '';
  String? userId = '';
  File? _file;
  bool flag = false;

  @override
  void initState() {
    super.initState();
    getUserId();
    _getNotificationData();
      firstName.text = Constants.responce.data!.firstName ?? '';
      lastName.text = Constants.responce.data!.lastName ?? '';
      jobTitle.text = Constants.responce.data!.jobTitle ?? '';
      company.text = Constants.responce.data!.company ?? '';
      phone.text = Constants.responce.data!.phone ?? '';
      email.text = Constants.responce.data!.email ?? '';
      linkedin.text = Constants.responce.data!.linkedinLink ?? '';
    BlocProvider.of<CountryBloc>(context).add(CountryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppSingleton.instance.getBackgroundColor(),
        appBar: AppSingleton.instance.buildAppBar(context, badgeFlag: flag),
        body: BlocConsumer(
          bloc: BlocProvider.of<CountryBloc>(context),
          listener: (context, state) {
            if (state is CountryError) {
              _showError(state.error);
            }if (state is CountryLoaded) {
              responce = state.response;
              responce.data!.forEach((element) {
                if(element.name == Constants.responce.data!.country!){
                  selectedDataId = element.id;
                  selectedData = element.name;
                  print("================ ${Constants.responce.data!.country!} ========== ${element.name}");
                }
              });
            }if (state is UpdateProfileError) {
              _showError(state.error);
            }if (state is UpdateProfileLoaded) {

              _showSuccessMessage(state.response.msg!);
              if(state.response.status == true){
                Navigator.of(context).pop(true);
              }
            }
            if (state is UpdatePhotoLoaded) {
              _showSuccessMessage(state.response.msg!);
              // Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if(responce.data != null){
              return buildUi();
            }
            // if (state is CountryLoaded) {
            //   print("================ ${Constants.responce.data!.country!}");
            //    // var responce = state.response.data;
            // }
            return AppSingleton.instance.buildCenterSizedProgressBar();
          },
        ),
      ),
    );
  }

  Widget buildUi(){
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          Container(
            color: AppSingleton.instance.getBackgroundColor(),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  AppSingleton.instance.buildToolbar(
                      context,
                      'Edit Profile',
                      Container(
                        height: 0.0,
                        width: 0.0,
                      ),
                      flag
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0,top: 10.0),
                    child: Row(
                      children: [

                        if(_file != null) ...[
                          Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppSingleton.instance.getCardEdgeColor(),
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding:   EdgeInsets.all(2.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.file(_file!,fit: BoxFit.cover,)),
                            ),
                          )
                        ]
                        else ...[
                          CircleAvatar(
                            backgroundColor: AppSingleton.instance.getCardEdgeColor(),
                            radius: 35.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                  Constants.responce.data!.headshot!),
                              radius: 32.0,
                            ),
                          ),
                        ],
                        Row(
                          children: [
                            GestureDetector(
                              onTap:(){
                                getImageFromGallery();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 20.0,right: 20.0),
                                child: Chip(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.all(15),
                                  label: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          /*  GestureDetector(
                              onTap: (){
                                // Navigator.pushNamed(context, Constants.ROUTE_EDIT_PROFILE);
                              },
                              child: Container(
                                child: Chip(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: AppSingleton.instance.getCardEdgeColor(),
                                  padding: EdgeInsets.all(15),
                                  label: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                          color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30,top: 10,right: 30.0),
                    child: Text(
                      "* Profile photo change button: Image size should be 512 x 512 pixels",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  titleTextFieldWidget("First Name",firstName),
                  titleTextFieldWidget("Last Name",lastName),
                  titleTextFieldWidget("Job Title",jobTitle),
                  titleTextFieldWidget("Company",company),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Country",
                        style: TextStyle(color: Colors.black38, fontSize: 17),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30,top: 10.0,bottom: 20.0),
                    child: DropdownSearch<dynamic>(
                      popupProps: PopupProps.menu(
                        fit: FlexFit.loose,
                        showSelectedItems: false,
                      ),
                      items: responce.data!.map((e)=> e.name).toList(), //['Project Controls Expo 2022','Project Controls Expo 2022'],
                      // items: dataForEvents, //['Project Controls Expo 2022','Project Controls Expo 2022'],
                      onChanged: (dynamic? item){
                        /*responce.data!.map((e){
                          setState(() {
                            selectedDataId = e.id;
                            print("selectedDataId $selectedDataId}");
                          });
                        }).toList();*/
                        selectedData = item;

                        responce.data!.forEach((element) {
                          if(element.name == selectedData){
                            selectedDataId = element.id;
                          }
                        });
                         debugPrint('selectedDataId::: $selectedDataId selectedData ${selectedData}');
                      },
                      selectedItem: selectedData,
                    ),
                  ),
                  titleTextFieldWidget("Phone",phone),
                  // titleTextFieldWidget("Email",email),
                  titleTextFieldWidget("Linkedin",linkedin,hintText: "Please enter linkedin url including https://"),
                  Container(
                    margin: EdgeInsets.only(left: 30.0,right: 30.0,bottom: 30.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 20.0),
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.black,width: 1)
                            ),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                               print("UserID ------------------> $userId");
                               if(validate()){
                                 Map<String, String> body = {
                                   "user_id": userId!,
                                   "first_name": firstName.text.trim(),
                                   "last_name": lastName.text.trim(),
                                   "job_title": jobTitle.text.trim(),
                                   "company": company.text.trim(),
                                   "phone": phone.text.trim(),
                                   "country": selectedDataId!,
                                   // "linkedin": "https://pceuat.convstaging.com/api/update_user_details"
                                   "linkedin_link": linkedin.text.trim()
                                 };
                                 if(_file != null){
                                   BlocProvider.of<CountryBloc>(context).add(UpdatePhotoEvent(body: _file!,userId: userId));
                                 }
                                 BlocProvider.of<CountryBloc>(context).add(UpdateProfileEvent(body: body));
                               }
                            },
                            child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.black,width: 1)
                              ),
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<File> getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    return _file!;
  }


  bool validate() {
    if (firstName.text.isEmpty) {
      _showError('Please enter First Name');
      return false;
    } else if (lastName.text.isEmpty) {
      _showError('Please enter Last Name');
      return false;
    } else if (jobTitle.text.isEmpty) {
      _showError('Please enter Job tile');
      return false;
    } else if (company.text.isEmpty) {
      _showError('Please enter Company Name');
      return false;
    } else if (phone.text.isEmpty) {
      _showError('Please enter Phone number');
      return false;
    } else if (email.text.isEmpty) {
      _showError('Please enter email');
      return false;
    } else if (!EmailValidator.validate(email.text)) {
      _showError('Please enter valid email');
      return false;
    }  else {
      return true;
    }
  }

  getUserId() async{
    userId =  await ApiProvider.instance.getUserId();
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getSuccessSnackBar(message));
    /*   Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, Constants.ROUTE_DASHBOARD);
    });*/
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getErrorSnackBar(message));
  }

  Widget titleTextFieldWidget(String? title,TextEditingController controller,{String hintText = "Type in your text"}){
    return Container(
      margin: EdgeInsets.only(left: 20.0,right: 20.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title!,
                style: TextStyle(color: Colors.black38, fontSize: 17),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800],fontSize: 14.0),
                  hintText: hintText,
                  fillColor: Colors.white70),
              keyboardType: controller == phone ? TextInputType.phone : TextInputType.multiline,
              // minLines: 8,
              //Normal textInputField will be displayed
              // maxLines: 8, // when user presses enter it will adapt to it
            ),
          ),
          SizedBox(
            height: 10,
          ),      ],
      ),
    );
  }
  void _getNotificationData() async {
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      flag = flagName ?? false;
    });
  }
}
