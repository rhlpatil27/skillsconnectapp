import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:pce/models/partners/partners_categories.dart';
import 'package:pce/models/partners/partners_model.dart';
import 'package:pce/screens/partners/partners_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;

import '../../network/api_provider.dart';
import '../../utils/singleton.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({Key? key}) : super(key: key);

  @override
  _PartnersScreenState createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PartnersModel responce = PartnersModel();
  PartnersCategoriesModel responce1 = PartnersCategoriesModel();
  final TextEditingController name = TextEditingController();
  String filter = '';
  String selectedId = '';
  String sponsorImgUrl = '';
  bool flag = false;

  Map<String, List> _elements = {
    'Headline Partner': ['Oracle Construction and Engineering'],
    'Platinum Partner': ['Toyah Downs'],
  };

  @override
  void initState() {
    super.initState();
    _getNotificationData();
   fetchData();
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
      bloc: BlocProvider.of<PartnersBloc>(context),
      listener: (context, state) {
        if (state is PartnersError) {
          _showError(state.error);
        }if (state is PartnersLoaded) {
          responce = state.response;
        } if (state is PartnersCategoryLoaded) {
          responce1 = state.response;
        }
      },
      builder: (context, state) {
        if (responce.data != null) {
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
            'Partners',
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
              child: GroupListView(
                sectionsCount: responce.data!.length,
                countOfItemInSection: (int section) {
                  return responce.data![section].partners!.length;
                },
                itemBuilder: (BuildContext context, IndexPath index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: AppSingleton.instance.getCardEdgeColor(),
                            width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0,right: 0.0),
                                child: Image.network(
                                  responce.data![index.section].partners![index.index].logo!,
                                  width: 150,
                                  height: 100,
                                  errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                    return Text('No Image Available',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: VerticalDivider(
                                thickness: 1.5,
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                responce.data![index.section].partners![index.index].company ?? "",
                                // responce.data![section].partners![index.section][index.index]!,
                                // _elements.values.toList()[index.section][index.index],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                groupHeaderBuilder: (BuildContext context, int section) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Text(
                      responce.data![section].partnerType!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10),
                sectionSeparatorBuilder: (context, section) =>
                    SizedBox(height: 10),
              ),
            )
          ]else ...[
            Text("No Partners Available")
          ],
          AppSingleton.instance.bottomBar(context,sponsorImgUrl ?? "")

         /* Expanded(
            child: GroupListView(
              sectionsCount: _elements.keys.toList().length,
              countOfItemInSection: (int section) {
                return _elements.values.toList()[section].length;
              },
              itemBuilder: (BuildContext context, IndexPath index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: AppSingleton.instance.getCardEdgeColor(),
                          width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: Image.network(
                              'https://mma.prnewswire.com/media/467598/Oracle_Logo.jpg?p=twitter',
                              width: 150,
                              height: 100,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: VerticalDivider(
                              thickness: 1.5,
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              _elements.values.toList()[index.section]
                              [index.index],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              groupHeaderBuilder: (BuildContext context, int section) {
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Text(
                    _elements.keys.toList()[section],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 10),
              sectionSeparatorBuilder: (context, section) =>
                  SizedBox(height: 10),
            ),
          )*/
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
                        'Partners Filter',
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
                          Text("Category:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          // Text('(Ascending):',
                          //     style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: responce1.data!.length,
                          itemBuilder: (context, index) {
                            return RadioListTile<String>(
                                activeColor: Colors.white,
                                contentPadding: EdgeInsets.all(4.0),
                                title: Transform.translate(
                                  offset: Offset(-15, 0),
                                  child: Text(
                                    responce1.data![index].categoryName!,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                                value: index.toString(),
                                groupValue: filter,
                                onChanged: (value) {
                                  setState(() {
                                    filter = value.toString();
                                    selectedId = responce1.data![int.parse(value!)].id!;

                                    print("---------------$selectedId");
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

  fetchDataFilter() async {
    String? eventId = await ApiProvider.instance.getUserEventId();
    Map<String, String> body = {
      Constants.PARAM_EVENT_ID: eventId ?? '',
      "category_id":selectedId,
      "company":name.text.trim()
    };
    Map<String, String> body1 = {
      Constants.PARAM_EVENT_ID: eventId ?? '',
       "company":name.text.trim()
    };

    BlocProvider.of<PartnersBloc>(context).add(PartnersEvent(body: selectedId == "" ? body1 : body));
    BlocProvider.of<PartnersBloc>(context).add(PartnersCategoryEvent(body: body));
  }


  fetchData() async{
    String? eventId = await ApiProvider.instance.getUserEventId();
    Map<String, String> body = {
      Constants.PARAM_EVENT_ID: eventId ?? '',
    };
    BlocProvider.of<PartnersBloc>(context).add(PartnersCategoryEvent(body: body));
    BlocProvider.of<PartnersBloc>(context).add(PartnersEvent(body: body));
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
  void _getNotificationData() async {
    bool? flagName = await ApiProvider.instance.getShowBadge();
    String? sponsorImg = await ApiProvider.instance.getSponserLink();
    setState(() {
      sponsorImgUrl = sponsorImg ?? "";
      flag = flagName ?? false;
    });
  }
}
