import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pce/models/speakers/speakers_model.dart';
import 'package:pce/screens/speakers/speakers_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../network/api_provider.dart';
import '../../utils/singleton.dart';

class SpeakersScreen extends StatefulWidget {
  const SpeakersScreen({Key? key}) : super(key: key);

  @override
  _SpeakersScreenState createState() => _SpeakersScreenState();
}

class _SpeakersScreenState extends State<SpeakersScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SpeakersModel responce = SpeakersModel();
  String filter = '';
   final TextEditingController name = TextEditingController();
  bool flag = false;
  String sponsorImgUrl= '';

  @override
  void initState() {
    _getNotificationData();
    fetchData();
    super.initState();
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
      bloc: BlocProvider.of<SpeakersBloc>(context),
      listener: (context, state) {
        if (state is SpeakersError) {
          _showError(state.error);
        }
      },
      builder: (context, state) {
        if (state is SpeakersLoaded) {
          responce = state.response;
          // var responce = state.response.data;
          return buildSignInScreen1();
        }
        return AppSingleton.instance.buildCenterSizedProgressBar();
      },
    );
  }

  Widget buildSignInScreen1() {
    return Container(
      color: AppSingleton.instance.getBackgroundColor(),
      child: Column(
        children: [
          AppSingleton.instance.buildToolbar(
            context,
            'Speakers',
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
          if (responce.data!.length > 0) ...[
            Expanded(
              child: ListView.builder(
                  itemCount: responce.data!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(
                              context, Constants.ROUTE_OTHER_USER,
                              arguments: responce.data![index]);
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: AppSingleton.instance.getSecondaryColor(),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Image.network(
                                  responce.data![index].headshot!,
                                  width: 50,
                                  height: 80,
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
                                title: Text("${responce.data![index].firstName!} ${responce.data![index].lastName!}"),
                                subtitle: Text('${responce.data![index].jobTitle!}\n${responce.data![index].company!}'),
                                isThreeLine: true,
                                dense: true,
                              ),
                              /* Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Megaproject Zone | Day 1',
                                      style:
                                          TextStyle(fontWeight: FontWeight.w600),
                                    ))),
                            SizedBox(
                              height: 10,
                            )*/
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ]else ...[
            Text("No Speakers Available")
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
                        'Speakers Filter',
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
                        scaffoldKey.currentState!.closeEndDrawer(); //<-- SEE HERE
                        /* if(validate()){
                          if(filter == ''){
                            _showSuccessMessage("Please Select Sorting Value");
                          } else {
                            fetchDataFilter();
                            scaffoldKey.currentState!.closeEndDrawer(); //<-- SEE HERE

                          }}*/
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

  bool validate() {
    if (name.text.isEmpty) {
      _showError('Please enter Name');
      return false;
    } else {
      return true;
    }
  }


  fetchDataFilter() async {
    String? eid = await ApiProvider.instance.getUserEventId();
    Map<String, String> body = {
      Constants.PARAM_EVENT_ID: eid ?? '',
      "name":name.text.trim(),
      "sort_by": filter == "" ? "" : filter == "0" ? "Name" : "Company"
    };
    BlocProvider.of<SpeakersBloc>(context).add(SpeakersEvent(body: body));
  }


  fetchData() async{
    String? eventId = await ApiProvider.instance.getUserEventId();
    Map<String, String> body = {
      Constants.PARAM_EVENT_ID: eventId ?? '',
    };
    BlocProvider.of<SpeakersBloc>(context).add(SpeakersEvent(body: body));
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
  void _getNotificationData() async {
    String? sponsorImg = await ApiProvider.instance.getSponserLink();
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      flag = flagName ?? false;
      sponsorImgUrl= sponsorImg ?? "";
    });
  }
}
