import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/base_widgets/app_textstyle.dart';
import 'package:pce/models/delegates/delegates_responce_entity.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/delegates/delegates_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../utils/singleton.dart';

class DelegatesScreen extends StatefulWidget {
  const DelegatesScreen({Key? key}) : super(key: key);

  @override
  _DelegatesScreenState createState() => _DelegatesScreenState();
}

class _DelegatesScreenState extends State<DelegatesScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DelegatesResponseEntity responce = DelegatesResponseEntity();
  String dayTitle = '';
  String filter = '';
  String filter2 = '';
  final TextEditingController name = TextEditingController();
  bool flag = false;
  String sponsorImgUrl= '';

  @override
  void initState() {
    super.initState();
    fetchData();
    _getNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawerEdgeDragWidth: 0,
        backgroundColor: AppSingleton.instance.getBackgroundColor(),
        appBar: AppSingleton.instance.buildAppBar(context, badgeFlag: flag),
        endDrawer: buildNavBar(context),
        body: buildSignInScreen(),
      ),
    );
  }

  Widget buildSignInScreen() {
    return BlocConsumer(
      bloc: BlocProvider.of<DelegatesBloc>(context),
      listener: (context, state) {
        if (state is DelegatesError) {
          _showError(state.error);
        }
      },
      builder: (context, state) {
        if (state is DelegatesLoaded) {
          responce = state.response;
          // var responce = state.response.data;
          return buildSignInScreen1(responce);
        }
        return AppSingleton.instance.buildCenterSizedProgressBar();
      },
    );
  }

  Widget buildSignInScreen1(DelegatesResponseEntity responseEntity) {
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: Column(
        children: [
          AppSingleton.instance.buildToolbar(
            context,
            'Delegates',
            GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openEndDrawer();
              },
              child: Icon(
                Icons.filter_alt_rounded,
                size: 33,
                color: Colors.black,
              ),
            ),
              flag
          ),
          if (responseEntity.data!.length > 0) ...[
            Expanded(
              child: ListView.builder(
                  itemCount: responseEntity.data!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: InkWell(
                        onTap: () {
                          // Navigator.pushNamed(
                          //     context, Constants.ROUTE_USER);
                          Navigator.pushNamed(
                              context, Constants.ROUTE_OTHER_USER,
                              arguments: responseEntity.data![index]);
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color:
                                    AppSingleton.instance.getSecondaryColor(),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                height: 50.0,
                                width: 50.0,
                                child: Image.network(
                                  responseEntity.data![index].headshot.toString(),
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                        child: Container(
                                            height: 50.0,
                                            width: 50.0,
                                            color:
                                                Colors.grey.withOpacity(0.5)));
                                  },
                                  errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                    return Container(
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                          child: Text('No Image Available',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            ),
                            // leading: getPhotos(imageUrl: responce.data![index].headshot.toString(),radius: 10,placeHolderImage: Container(height: 50.0,width: 50.0,color: Colors.grey.withOpacity(0.5),)),
                            title: Text(
                                "\n${responseEntity.data![index].firstName} ${responseEntity.data![index].lastName}"),
                            subtitle: Text(
                              "${responseEntity.data![index].company}",
                              maxLines: 3,
                            ),
                            isThreeLine: true,
                            dense: true,
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ] else ...[
            Text("No Delegates Available")
          ],
          AppSingleton.instance.bottomBar(context,sponsorImgUrl)
        ],
      ),
    );
  }

  Widget buildNavBar(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Drawer(
        backgroundColor: AppSingleton.instance.getPrimaryColor(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delegates Filter',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                  GestureDetector(
                    onTap: () {
                      scaffoldKey.currentState!.closeEndDrawer(); //<-- SEE HERE
                    },
                    child: Icon(
                      Icons.close,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  titleTextFieldWidget("Name",name),
                  Row(
                    children: [
                      Text('Sort by ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text('(Ascending):',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                       itemCount: 2,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                            activeColor: Colors.white,
                             contentPadding: EdgeInsets.all(4.0),
                            title: Transform.translate(
                              offset: Offset(-15, 0),
                              child: Text(
                                index == 0 ? "Name" : "Company",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                            value: index.toString(),
                            groupValue: filter,
                            onChanged: (value) {
                              setState(() {
                                filter = value.toString();
                                print("---------------$filter");
                              });
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 4,
                    shadowColor: AppSingleton.instance.getButtonColor(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  onPressed: () async {
                    scaffoldKey.currentState!.closeEndDrawer(); //<-- SEE HERE
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 4,
                    shadowColor: AppSingleton.instance.getButtonColor(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  onPressed: () async {
                    fetchDataFilter();
                    scaffoldKey.currentState!.closeEndDrawer();
                   /* if(validate()){
                      fetchDataFilter();
                      scaffoldKey.currentState!.closeEndDrawer(); //<-- SEE
                      if(filter == ''){
                        scaffoldKey.currentState!.closeEndDrawer();
                        _showError("Please Select Sorting Value");
                      } else {
                        fetchDataFilter();
                        scaffoldKey.currentState!.closeEndDrawer(); //<-- SEE HERE

                      }
                    }*/
                    //makeLogin();
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }

  bool validate() {
    if (name.text.isEmpty) {
      scaffoldKey.currentState!.closeEndDrawer();
      _showError('Please enter Name');
      return false;
    } else {
      return true;
    }
  }

  Widget titleTextFieldWidget(String? title,TextEditingController controller){
    return Container(
      margin: EdgeInsets.only(left: 0.0,right: 0.0),
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                title!,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
              ),
                 border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Type in your text",
                ),
            keyboardType: TextInputType.multiline,
            // minLines: 8,
            //Normal textInputField will be displayed
            // maxLines: 8, // when user presses enter it will adapt to it
          ),
          SizedBox(
            height: 50,
          ),      ],
      ),
    );
  }


  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getSuccessSnackBar(message));
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, Constants.ROUTE_DASHBOARD);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getErrorSnackBar(message));
  }

  fetchData() async {
    String? eid = await ApiProvider.instance.getUserEventId();
    Map<String, String> body = {
      Constants.PARAM_EVENT_ID: eid ?? '',
    };
    BlocProvider.of<DelegatesBloc>(context).add(DelegatesEvent(body: body));
  }

  fetchDataFilter() async {
    String? eid = await ApiProvider.instance.getUserEventId();
    Map<String, String> body = {
      Constants.PARAM_EVENT_ID: eid ?? '',
      "name":name.text.trim(),
      "sort_by": filter == "" ? "" :  filter == "0" ? "Name" : "Company"
    };
    BlocProvider.of<DelegatesBloc>(context).add(DelegatesEvent(body: body));
  }
  void _getNotificationData() async {
    String? sponsorImg = await ApiProvider.instance.getSponserLink();
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      sponsorImgUrl= sponsorImg ?? "";
      flag = flagName ?? false;
    });
  }
}
