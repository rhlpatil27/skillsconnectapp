import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pce/network/api_provider.dart';
import 'package:pce/screens/agenda/agenda_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:pce/utils/hex_color.dart';

import '../../models/agenda/agenda_response.dart';
import '../../models/agenda/filter/get_all_days.dart' as AllDays;
import '../../models/agenda/filter/get_all_zones.dart' as AllZones;
import '../../utils/singleton.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String dayTitle = '';
  String selectedDay = '';
  String selectedZone = '';
  List<Data> agendaData = [];
  List<AllDays.Data>? filterData = [];
  List<AllZones.Data>? filterDataZones = [];
  bool flag = false;
  String sponsorImgUrl= '';

  @override
  void initState() {
    super.initState();
    _getNotificationData();
    fetchData('', '');
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
      bloc: BlocProvider.of<AgendaBloc>(context),
      listener: (context, state) {
        if (state is AgendaError) {
          _showError(state.error);
        }
      },
      builder: (context, state) {
        if (state is AgendaLoaded) {
          agendaData = state.response.data!;
          return Container(
            color: AppSingleton.instance.getBackgroundColor(),
            child: Column(
              children: [
                AppSingleton.instance.buildToolbar(
                  context,
                  'Agenda',
                  GestureDetector(
                    onTap: () {
                      scaffoldKey.currentState!.openEndDrawer();
                      fetchFilterDays();
                    },
                    child: Icon(
                      Icons.filter_alt_rounded,
                      size: 33,
                      color: Colors.black,
                    ),
                  ),
                    flag
                ),
                Flexible(
                  child: agendaData.length != 0 ? ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: agendaData.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int dataIndex) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  removeDuplicateDays(
                                      agendaData[dataIndex]
                                              .dayName
                                              ?.toUpperCase() ??
                                          '',
                                      agendaData[dataIndex]
                                              .date
                                              ?.toUpperCase() ??
                                          ''),
                                  // '${agendaData?[dataIndex].dayName?.toUpperCase()} - ${agendaData?[dataIndex].date?.toUpperCase()}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20, top: 10),
                                child: Chip(
                                  backgroundColor: Colors.black,
                                  label: Text(
                                    '${agendaData[dataIndex].zoneName ?? ''}  ${agendaData[dataIndex].abbreviation ?? ''}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                // add this
                                shrinkWrap: true,
                                itemCount:
                                    agendaData[dataIndex].sessions?.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder:
                                    (BuildContext context, int sessionsIndex) {
                                  return Column(
                                    children: [
                                      agendaData[dataIndex]
                                                  .sessions![sessionsIndex]
                                                  .isBreak ==
                                              "0"
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, top: 10, right: 20),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: AppSingleton
                                                          .instance
                                                          .getCardEdgeColor(),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          getEventTime(
                                                              agendaData[dataIndex]
                                                                      .sessions![
                                                                          sessionsIndex]
                                                                      .toTime ??
                                                                  '',
                                                              agendaData[dataIndex]
                                                                      .sessions![
                                                                          sessionsIndex]
                                                                      .fromTime ??
                                                                  ''),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: AppSingleton
                                                                  .instance
                                                                  .getCardEdgeColor(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10),
                                                          child: Text(
                                                              agendaData[dataIndex]
                                                                      .sessions![
                                                                          sessionsIndex]
                                                                      .topic ??
                                                                  '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: 1.5,
                                                      ),
                                                      Flexible(
                                                        child: ListView.builder(
                                                          physics:
                                                              ClampingScrollPhysics(),
                                                          // add this
                                                          shrinkWrap: true,
                                                          itemCount: agendaData[
                                                                  dataIndex]
                                                              .sessions![
                                                                  sessionsIndex]
                                                              .speakers!
                                                              .length,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemBuilder: (BuildContext
                                                                  context,
                                                              int speakersIndex) {
                                                            return ListTile(
                                                              leading: SizedBox(
                                                                width: 50,
                                                                height: 50,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: agendaData[dataIndex]
                                                                          .sessions![
                                                                              sessionsIndex]
                                                                          .speakers?[
                                                                              speakersIndex]
                                                                          .headshot ??
                                                                      '',
                                                                  progressIndicatorBuilder: (context,
                                                                          url,
                                                                          downloadProgress) =>
                                                                      CircularProgressIndicator(
                                                                    value: downloadProgress
                                                                        .progress,
                                                                    color: Colors
                                                                            .grey[
                                                                        100],
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Icon(Icons
                                                                          .rectangle_outlined),
                                                                ),
                                                                // child: Image.network(
                                                                //   agendaData[dataIndex].sessions![sessionsIndex].speakers?[speakersIndex].headshot ?? '',
                                                                // ),
                                                              ),
                                                              title: Text(agendaData[dataIndex]
                                                                      .sessions![
                                                                          sessionsIndex]
                                                                      .speakers![
                                                                          speakersIndex]
                                                                      .name ??
                                                                  ''),
                                                              subtitle: Text(
                                                                  '${agendaData[dataIndex].sessions![sessionsIndex].speakers![speakersIndex].jobTitle ?? ''}\n${agendaData[dataIndex].sessions![sessionsIndex].speakers![speakersIndex].company ?? ''}'),
                                                              isThreeLine: true,
                                                              dense: true,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              height: 0,
                                            ),
                                      agendaData[dataIndex]
                                                  .sessions?[sessionsIndex]
                                                  .isBreak ==
                                              "1"
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, top: 10, right: 20),
                                              child: Card(
                                                color: AppSingleton.instance
                                                    .getCardEdgeColor(),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: AppSingleton
                                                          .instance
                                                          .getCardEdgeColor(),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: ListTile(
                                                  title: Text(
                                                      getEventTime(
                                                          agendaData[dataIndex]
                                                                  .sessions![
                                                                      sessionsIndex]
                                                                  .toTime ??
                                                              '',
                                                          agendaData[dataIndex]
                                                                  .sessions![
                                                                      sessionsIndex]
                                                                  .fromTime ??
                                                              ''),
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  subtitle: Text(
                                                    '${agendaData[dataIndex].sessions![sessionsIndex].topic ?? ''}',
                                                    style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              height: 0,
                                            ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }) : Center(child: const Text('No results found')),
                ),
                AppSingleton.instance.bottomBar(context,sponsorImgUrl)
              ],
            ),
          );
        }
        if (state is AgendaLoading) {
          return AppSingleton.instance.buildCenterSizedProgressBar();
        }
        return Container(
          color: AppSingleton.instance.getBackgroundColor(),
          child: Column(
            children: [
              AppSingleton.instance.buildToolbar(
                context,
                'Agenda',
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState!.openEndDrawer();
                    fetchFilterDays();
                  },
                  child: Icon(
                    Icons.filter_alt_rounded,
                    size: 33,
                    color: Colors.black,
                  ),
                ),
                  flag
              ),
              Flexible(
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: agendaData.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int dataIndex) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                removeDuplicateDays(
                                    agendaData[dataIndex]
                                            .dayName
                                            ?.toUpperCase() ??
                                        '',
                                    agendaData[dataIndex].date?.toUpperCase() ??
                                        ''),
                                // '${agendaData?[dataIndex].dayName?.toUpperCase()} - ${agendaData?[dataIndex].date?.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, top: 10),
                              child: Chip(
                                backgroundColor: Colors.black,
                                label: Text(
                                  '${agendaData[dataIndex].zoneName ?? ''}  ${agendaData[dataIndex].abbreviation ?? ''}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              // add this
                              shrinkWrap: true,
                              itemCount: agendaData[dataIndex].sessions?.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder:
                                  (BuildContext context, int sessionsIndex) {
                                return Column(
                                  children: [
                                    agendaData[dataIndex]
                                                .sessions![sessionsIndex]
                                                .isBreak ==
                                            "0"
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, top: 10, right: 20),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: AppSingleton.instance
                                                        .getCardEdgeColor(),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        getEventTime(
                                                            agendaData[dataIndex]
                                                                    .sessions![
                                                                        sessionsIndex]
                                                                    .toTime ??
                                                                '',
                                                            agendaData[dataIndex]
                                                                    .sessions![
                                                                        sessionsIndex]
                                                                    .fromTime ??
                                                                ''),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: AppSingleton
                                                                .instance
                                                                .getCardEdgeColor(),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Text(
                                                            agendaData[dataIndex]
                                                                    .sessions![
                                                                        sessionsIndex]
                                                                    .topic ??
                                                                '',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 1.5,
                                                    ),
                                                    Flexible(
                                                      child: ListView.builder(
                                                        physics:
                                                            ClampingScrollPhysics(),
                                                        // add this
                                                        shrinkWrap: true,
                                                        itemCount: agendaData[
                                                                dataIndex]
                                                            .sessions![
                                                                sessionsIndex]
                                                            .speakers!
                                                            .length,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemBuilder: (BuildContext
                                                                context,
                                                            int speakersIndex) {
                                                          return ListTile(
                                                            leading: SizedBox(
                                                              width: 50,
                                                              height: 50,
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: agendaData[dataIndex]
                                                                        .sessions![
                                                                            sessionsIndex]
                                                                        .speakers?[
                                                                            speakersIndex]
                                                                        .headshot ??
                                                                    '',
                                                                progressIndicatorBuilder:
                                                                    (context,
                                                                            url,
                                                                            downloadProgress) =>
                                                                        CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress,
                                                                  color: Colors
                                                                          .grey[
                                                                      100],
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .rectangle_outlined),
                                                              ),
                                                              // child: Image.network(
                                                              //   agendaData[dataIndex].sessions![sessionsIndex].speakers?[speakersIndex].headshot ?? '',
                                                              // ),
                                                            ),
                                                            title: Text(agendaData[
                                                                        dataIndex]
                                                                    .sessions![
                                                                        sessionsIndex]
                                                                    .speakers![
                                                                        speakersIndex]
                                                                    .name ??
                                                                ''),
                                                            subtitle: Text(
                                                                '${agendaData[dataIndex].sessions![sessionsIndex].speakers![speakersIndex].jobTitle ?? ''} \n ${agendaData[dataIndex].sessions![sessionsIndex].speakers![speakersIndex].company ?? ''}'),
                                                            isThreeLine: true,
                                                            dense: true,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    agendaData[dataIndex]
                                                .sessions?[sessionsIndex]
                                                .isBreak ==
                                            "1"
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, top: 10, right: 20),
                                            child: Card(
                                              color: AppSingleton.instance
                                                  .getCardEdgeColor(),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: AppSingleton.instance
                                                        .getCardEdgeColor(),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                    getEventTime(
                                                        agendaData[dataIndex]
                                                                .sessions![
                                                                    sessionsIndex]
                                                                .toTime ??
                                                            '',
                                                        agendaData[dataIndex]
                                                                .sessions![
                                                                    sessionsIndex]
                                                                .fromTime ??
                                                            ''),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                subtitle: Text(
                                                  '${agendaData[dataIndex].sessions![sessionsIndex].topic ?? ''}',
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              AppSingleton.instance.bottomBar(context,sponsorImgUrl)
            ],
          ),
        );
      },
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

  String getTimeFromDate(String dateString) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);

    return getTime(tempDate);
  }

  String getTime(DateTime date) {
    return DateFormat.jm().format(date).toString();
  }

  String getEventTime(String fromDate, String toDate) {
    return '${getTimeFromDate(toDate)} - ${getTimeFromDate(fromDate)}';
  }

  String removeDuplicateDays(
    String day,
    String date,
  ) {
    // dayTitle = day;
    // if(day.contains(dayTitle)) {
    //   return '---------------';
    // }
    return '$day - $date';
  }

  fetchData(String? dayId, String? zoneName) async {
    if (agendaData != null) {
      String? eid = await ApiProvider.instance.getUserEventId();
      Map<String, String> body = {
        Constants.PARAM_EVENT_ID: eid ?? '',
        Constants.PARAM_DAY_ID: dayId ?? '',
        Constants.PARAM_ZONE_NAME: zoneName ?? '',
      };
      BlocProvider.of<AgendaBloc>(context).add(AgendaEvent(body: body));
    }
  }

  fetchFilterDays() async {
    if (filterData != null) {
      String? eid = await ApiProvider.instance.getUserEventId();
      Map<String, String> body = {
        Constants.PARAM_EVENT_ID: eid ?? '',
      };
      BlocProvider.of<AgendaBloc>(context).add(FetchDaysEvent(body: body));
    }
  }

  fetchFilterZones() async {
    if (filterData != null) {
      String? eid = await ApiProvider.instance.getUserEventId();
      Map<String, String> body = {
        Constants.PARAM_EVENT_ID: eid ?? '',
      };
      BlocProvider.of<AgendaBloc>(context).add(FetchZonesEvent(body: body));
    }
  }

  Widget buildNavBar(BuildContext context) {
    return Drawer(
      backgroundColor: AppSingleton.instance.getPrimaryColor(),
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Agenda Filter',
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
                  const Text(
                    'Select Days :',
                    style: TextStyle(color: Colors.white),
                  ),
                  BlocConsumer<AgendaBloc, AgendaState>(
                    listener: (context, state) {
                      // TODO: implement listener
                      if (state is AllDaysFetchError) {
                        _showError(state.error);
                      }
                    },
                    builder: (context, state) {
                      if (state is AllDaysFetched) {
                        filterData = state.response.data;
                        debugPrint('filterData::: $filterData');
                        fetchFilterZones();
                        return buildUIDays();
                      }
                      if (state is AllDaysFetchError) {
                        return Container(child: Text(state.error));
                      }
                      if (state is AllDaysLoading) {
                        return SizedBox(
                          height: 12,
                          width: 12,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                            HexColor('#ffffff'),
                          )),
                        );
                      }
                      return filterData != null ? buildUIDays() : Container();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Zones :',
                    style: TextStyle(color: Colors.white),
                  ),
                  BlocConsumer<AgendaBloc, AgendaState>(
                    listener: (context, state) {
                      // TODO: implement listener
                      if (state is AllDaysFetchError) {
                        _showError(state.error);
                      }
                    },
                    builder: (context, state) {
                      if (state is AllZonesFetched) {
                        filterDataZones = state.response.data;
                        debugPrint('filterDataZones::: $filterDataZones');
                        return buildUIZones();
                      }
                      if (state is AllZonesFetchError) {
                        return Container(child: Text(state.error));
                      }
                      if (state is AllZonesLoading) {
                        return SizedBox(
                          height: 12,
                          width: 12,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                            HexColor('#ffffff'),
                          )),
                        );
                      }
                      return filterDataZones != null
                          ? buildUIZones()
                          : Container();
                    },
                  ),
                ],
              ),
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
                    applyFliter();
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
      ),
    );
  }

  Widget buildUIDays() {
    return Flexible(
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: filterData!.length,
        itemBuilder: (context, index) {
          return RadioListTile<String>(
              activeColor: Colors.white,
              contentPadding: EdgeInsets.all(0.0),
              title: Transform.translate(
                offset: Offset(-15, 0),
                child: Text(
                  filterData![index].dayName ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              value: filterData![index].id ?? '',
              groupValue: selectedDay,
              onChanged: (value) {
                setState(() {
                  selectedDay = value.toString();
                });
                debugPrint('selected value ::$selectedDay');
              });
        },
      ),
    );
    ;
  }

  Widget buildUIZones() {
    return Flexible(
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: filterDataZones!.length,
        itemBuilder: (context, index) {
          return RadioListTile<String>(
              activeColor: Colors.white,
              contentPadding: EdgeInsets.all(0.0),
              title: Transform.translate(
                offset: Offset(-15, 0),
                child: Text(
                  filterDataZones![index].zoneName ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              value: filterDataZones![index].zoneName ?? '',
              groupValue: selectedZone,
              onChanged: (value) {
                setState(() {
                  selectedZone = value.toString();
                });
                debugPrint('selected value ::$selectedZone');
              });
        },
      ),
    );
  }

  void applyFliter() {
    scaffoldKey.currentState!.closeEndDrawer(); //<-- SEE HERE
    // if(selectedDay.isEmpty){
    //   _showError("Choose filter");
    // }else{
    fetchData(selectedDay, selectedZone);
    // }
  }

  void _getNotificationData() async {
    String? sponsorImg = await ApiProvider.instance.getSponserLink();
    bool? flagName = await ApiProvider.instance.getShowBadge();
    setState(() {
      sponsorImgUrl= sponsorImg ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/No_image_3x4_50_trans_borderless.svg/120px-No_image_3x4_50_trans_borderless.svg.png";
      flag = flagName ?? false;
    });
  }
}
