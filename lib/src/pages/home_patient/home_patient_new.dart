import 'package:civideoconnectapp/src/pages/AppointmentDetails.dart';
import 'package:civideoconnectapp/src/pages/aboutUs.dart';
import 'package:civideoconnectapp/src/pages/home_patient/patient_feeback.dart';
import 'package:civideoconnectapp/startscreen.dart';
import 'package:civideoconnectapp/utils/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'syles.dart';
import 'package:civideoconnectapp/globals.dart' as globals;
import 'package:civideoconnectapp/firebase/auth/phone_auth/authservice.dart';

Color myTitleColor;

final List<String> imgList = [
  'https://cdn.docprime.com/media/hospital/images/bhaktivedanta-hospital.jpg',
  'https://images.jdmagicbox.com/comp/thane/37/022p5552637/catalogue/bhakti-vedanta-hospital-and-research-institute-mira-road-thane-pathology-labs-wc90p.jpg?clr=#660000',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR2LjCQPoSMLYVPv8SZYMdySLLnpkPYeEIa2A&usqp=CAU'
      'https://www.bhaktivedantahospital.com/media/1220/bhaktivedanta-clinic.jpg',
  'https://images.pexels.com/photos/4386513/pexels-photo-4386513.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        /* padding: EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 20.0),
                         child: Text(
                          'No. ${imgList.indexOf(item) + 1} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ), 
                        ), */
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class HomePagePatientNew extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePagePatientNew> {
  var isLoading = false;
  int _current = 0;
  Stream<QuerySnapshot> appointments;
  final ScrollController _scrollController = ScrollController();
  final Color _backgroundColor = Color(0xFFf0f0f0);

  @override
  void initState() {
    super.initState();

    DatabaseMethods()
        .getPatientAppointmentsNext(globals.personCode)
        .then((val) {
      setState(() {
        appointments = val;
      });
    });
  }

  TextStyle get bodyTextStyle => TextStyle(
        color: Color(0xFF083e64),
        fontSize: 13,
        fontFamily: 'OpenSans',
      );

  @override
  Widget build(BuildContext context) {
    myTitleColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: double.infinity,
                //height: 40,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              "Hello ${globals.personName}",
                              style: bodyTextStyle.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            AuthService().signOut();

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => StartScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text("Logout",
                              style: bodyTextStyle.copyWith(
                                  fontSize: 15, color: Colors.black)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                color: Colors.white,
                child: CarouselSlider(
                  items: imageSliders,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      // height: MediaQuery.of(context).size.height-230,

                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.map((url) {
                    int index = imgList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Next Appointment",
                        style: bodyTextStyle.copyWith(fontSize: 15)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 100,
                      color: Colors.white,
                      child: StreamBuilder(
                          stream: appointments,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? snapshot.data.documents.length == 0
                                    ? Container(
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "You don't have any appointments!"),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        controller: _scrollController,
                                        physics: BouncingScrollPhysics(),
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AppointmentScreen(
                                                    appointmentNumber: snapshot
                                                            .data
                                                            .documents[index]
                                                            .data[
                                                        "appointmentNumber"],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 100,
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  Container(
                                                      child: _buildTopContent(
                                                          snapshot.data
                                                                  .documents[
                                                              index])),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                : Container(
                                    width: double.infinity,
                                    child: Text("Loading data..."),
                                  );
                          }),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Lab Test",
                        style: bodyTextStyle.copyWith(fontSize: 15)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      //height: 100,
                      color: Colors.white,
                      child: RichText(
                          text: TextSpan(
                        text: 'Use offer code',
                        style: bodyTextStyle.copyWith(
                            fontSize: 15.0, color: Colors.lightBlue),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' OFFER10',
                            style: bodyTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.red),
                          ),
                          TextSpan(
                            text:
                                ' to get 10% off on your lab order.\n\nOffer for limited time!!!',
                            style: bodyTextStyle.copyWith(
                                fontSize: 15.0, color: Colors.lightBlue),
                          )
                        ],
                      )),
                      // Column(
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Text("Use offer code "),
                      //         Text("OFFER10 ",
                      //             style: TextStyle(color: Colors.red)),
                      //         Text("to get 10% off"),
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         Text("on your lab order."),
                      //       ],
                      //     ),
                      //     SizedBox(height: 10),
                      //     Row(
                      //       children: [Text("Offer for limited time!!!")],
                      //     )
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Feeback",
                        style: bodyTextStyle.copyWith(fontSize: 15)),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                            //height: 140,
                            width: double.infinity,
                            child: Image.asset(
                                "assets/images/PatientFeedback.jpg",
                                fit: BoxFit.fill)),
                        Container(
                          padding: const EdgeInsets.all(15.0),
                          //height: 140,
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "How was your last appointment experience?",
                                style: bodyTextStyle.copyWith(
                                    fontSize: 15, color: Colors.black),
                                overflow: TextOverflow.clip,
                              ),
                              SizedBox(height: 10),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  color: Colors.white,
                                  child: RawMaterialButton(
                                    onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PatientFeedback(),
                                        ),
                                      )
                                    },
                                    child: Text("Submit your feedback",
                                        style: bodyTextStyle),
                                    //   shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(25.0),
                                    //       side: BorderSide(color: Colors.orangeAccent)),
                                    //   elevation: 2.0,
                                    //   fillColor: Colors.orangeAccent,
                                    //   padding: const EdgeInsets.all(15.0),
                                    // )
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTopContent(DocumentSnapshot appt) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[100]),
                  height: 80,
                  width: 80,
                  child: globals.getProfilePic("DOCTOR")),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Text(
                    appt.data["doctorName"].toUpperCase(),
                    style: bodyTextStyle.copyWith(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  appt.data["departmentName"].toUpperCase(),
                  style: bodyTextStyle.copyWith(fontSize: 10),
                ),
                Row(
                  children: [
                    Text(
                        DateFormat('EEE, MMM d yyyy')
                            .format(appt.data["apptDate"].toDate())
                            .toUpperCase(),
                        style: bodyTextStyle.copyWith(fontSize: 10)),
                    SizedBox(width: 10),
                    Text(
                        DateFormat.jm()
                            .format(appt.data["doctorSlotFromTime"].toDate())
                            .toUpperCase(),
                        style: bodyTextStyle.copyWith(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildAppBar() {
    Color appBarIconsColor = Color(0xFF212121);
    return AppBar(
      //leading: Icon(Icons.home, color: appBarIconsColor),
      actions: <Widget>[
        new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUs()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child:
                  Icon(Icons.info_rounded, color: appBarIconsColor, size: 28),
            )),
      ],
      brightness: Brightness.light,
      backgroundColor: _backgroundColor,
      elevation: 0,
      title: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text('Home'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              letterSpacing: 0.5,
              color: appBarIconsColor,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
