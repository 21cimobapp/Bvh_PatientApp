import 'dart:convert';
//import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:civideoconnectapp/data_models/Appointmentsavedetails.dart';
//import 'package:civideoconnectapp/data_models/Doctors.dart';
import 'package:civideoconnectapp/data_models/PatientAppointmentdetails.dart';
import 'package:civideoconnectapp/src/pages/appointment/RazorPay/FailedPage.dart';
import 'package:civideoconnectapp/src/pages/appointment/RazorPay/FailedApptBookPage.dart';

import 'package:civideoconnectapp/src/pages/appointment/RazorPay/Razorpay.dart';
import 'package:civideoconnectapp/src/pages/appointment/RazorPay/SuccessPage.dart';
import 'package:civideoconnectapp/utils/Database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter_local_notifications/src/platform_specifics/android/message.dart';
import 'package:intl/intl.dart';
import 'package:civideoconnectapp/globals.dart' as globals;

//import 'package:mailer/src/entities/message.dart'as Message;

class CheckRazor extends StatefulWidget {
  final PatientAppointmentdetails appDetail;
  final DoctorData doctorDet;
  const CheckRazor({Key key, this.appDetail, this.doctorDet}) : super(key: key);
  @override
  _CheckRazorState createState() => _CheckRazorState();
}

// Future<void> main() async {
//   String username = 'anjalihali9@gmail.com'; //Your Email;
//   String password = '98347068'; //Your Email's password;

//   final smtpServer = gmail(username, password);
//   // Creating the Gmail server

//   // Create our email message.
//   final message = Message()
//     ..from = Address('anjalihali9@gmail.com')
//     ..recipients.add('anjalihali9@gmail.com') //recipent email
//     //..ccRecipients.addAll(['anjalihali9@gmail.com', 'anjalihali9@gmail.com']) //cc Recipents emails
//     //..bccRecipients.add(Address('anjalihali9@gmail.com')) //bcc Recipents emails
//     ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'//subject of the email
//     ..text = 'This is the plain text.\nThis is line 2 of the text part.'; //body of the email

//   try {
//     final sendReport = await send(message, smtpServer);
//     print('Message sent: ' + sendReport.toString()); //print if the email is sent
//   } on MailerException catch (e) {
//     print('Message not sent. \n'+ e.toString()); //print if the email is not sent
//     e.toString();// will show why the email is not sending
//   }
// }

class _CheckRazorState extends State<CheckRazor> {
  // List<String> attachments = [];
  // bool isHTML = false;
//for mail
  // final _recipientController = TextEditingController(
  //   text: 'ambpab96@gmail.com',
  // );

  // final _subjectController = TextEditingController(text: 'Appointment Details');

  // final _bodyController = TextEditingController(
  //   text: 'appointment booked.',
  // );

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Future<void> send() async {
  //   final Email email = Email(
  //     body: _bodyController.text,
  //     subject: _subjectController.text,
  //     recipients: [_recipientController.text],
  //     attachmentPaths: attachments,
  //     isHTML: isHTML,
  //   );

  //   String platformResponse;

  //   try {
  //     await FlutterEmailSender.send(email);
  //     platformResponse = 'success';
  //   } catch (error) {
  //     platformResponse = error.toString();
  //   }

  //   if (!mounted) return;

  //   _scaffoldKey.currentState.showSnackBar(SnackBar(
  //     content: Text(platformResponse),
  //   ));
  // }

// for notification

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future onSelectNotification(String payload) {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    //FlutterRingtonePlayer.stop();
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
      'channelId',
      'channelName',
      'channelDescription',
    );
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Appointment Booked',
      ' With ${widget.appDetail.DoctorName} ',
      platform,
      payload: ' ',
    );
  }

//Future<Appointmentsavedetails> saveappdetail;

  String _serviceUrl = '${globals.apiHostingURL}/Patient/SaveAppointment';
  static final _headers = {'Content-Type': 'application/json'};

  Razorpay _razorpay = Razorpay();
  var options;
  Future payData() async {
    try {
      _razorpay.open(options);
    } catch (e) {
      print("errror occured here is ......................./:$e");
    }

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("payment has succedded");

    Appointmentsavedetails apptSaveDet = new Appointmentsavedetails(
        widget.appDetail.PatientCode,
        widget.appDetail.PatientCode,
        widget.appDetail.DoctorCode,
        DateFormat('yyyy-MM-dd').format(widget.appDetail.ApptDate),
        widget.appDetail.SlotName,
        widget.appDetail.SlotNumber,
        widget.appDetail.DoctorSlotFromTime,
        widget.appDetail.DoctorSlotToTime,
        "HCALLPAYONLINE",
        'H01',
        widget.appDetail.AppointmentType,
        widget.appDetail.SlotTimeLabel,
        widget.appDetail.PatientName,
        widget.appDetail.DoctorName,
        widget.doctorDet.doctorPhoto,
        widget.doctorDet.designation,
        widget.doctorDet.qualification,
        _getUserData("Age"),
        _getUserData("Gender"),
        widget.appDetail.SlotDuration,
        response.paymentId,
        widget.appDetail.ConsultationFee,
        response.signature);

    createContact(response, apptSaveDet);

    // send();

    //   createContact(apptSaveDet).then((value) => {

    //   });

    //  notificationaftersec();
    //  _showNotificationsAfterSec();
    _razorpay.clear();
    // Do something when payment succeeds
  }

  String _getUserData(type) {
    if (globals.user != null) {
      return globals.user[0][type];
    } else
      return '';
  }

  createContact(PaymentSuccessResponse paymentResponse,
      Appointmentsavedetails savedetail) async {
    try {
      String toJson(Appointmentsavedetails savedetail) {
        var mapData = new Map();
        mapData["Token"] = savedetail.Token;
        mapData["PatientCode"] = savedetail.PatientCode;
        mapData["DoctorCode"] = savedetail.DoctorCode;
        mapData["ApptDate"] = savedetail.ApptDate;
        mapData["SlotName"] = savedetail.SlotName;
        mapData["SlotNumber"] = savedetail.SlotNumber;
        mapData["DoctorSlotFromTime"] = savedetail.DoctorSlotFromTime;
        mapData["DoctorSlotToTime"] = DateFormat('yyyy-MM-dd hh:mm a').format(
            DateFormat('yyyy-MM-dd hh:mm a')
                .parse(savedetail.DoctorSlotToTime)
                .add(Duration(minutes: savedetail.SlotDuration)));
        mapData["OrganizationCode"] = savedetail.OrganizationCode;
        mapData["PaymentModeCode"] = savedetail.PaymentModeCode;
        mapData["AppointmentType"] = savedetail.AppointmentType;

        String json = jsonEncode(mapData); //JSON.encode(mapData);
        return json;
      }

      String json = toJson(savedetail);
      final response =
          await http.post(_serviceUrl, headers: _headers, body: json);
      var extractdata = jsonDecode(response.body)['msg'];
      print(extractdata);
      String appointmentNumber = jsonDecode(response.body)['AppointmentNumber'];

      Map<String, dynamic> appDetail = {
        "appointmentNumber": appointmentNumber,
        "patientCode": savedetail.PatientCode,
        "doctorCode": savedetail.DoctorCode,
        "apptDate": DateTime.parse(savedetail.ApptDate),
        "slotName": savedetail.SlotName,
        "slotNumber": savedetail.SlotNumber,
        "doctorSlotFromTime": DateFormat('yyyy-MM-dd hh:mm a')
            .parse(savedetail.DoctorSlotFromTime),
        "doctorSlotToTime": DateFormat('yyyy-MM-dd hh:mm a')
            .parse(savedetail.DoctorSlotToTime)
            .add(Duration(minutes: savedetail.SlotDuration)),
        "organizationCode": savedetail.OrganizationCode,
        "paymentModeCode": savedetail.PaymentModeCode,
        "appointmentType": savedetail.AppointmentType,
        "patientName": savedetail.PatientName,
        "doctorName": savedetail.DoctorName,
        "departmentName": savedetail.DepartmentName,
        "doctorQualification": savedetail.DoctorQualification,
        "patientAge": savedetail.PatientAge,
        "patientGender": savedetail.PatientGender,
        "slotDuration": savedetail.SlotDuration,
        "paymentId": savedetail.paymentID,
        "paymentAmount": savedetail.paymentAmount,
        "signature": savedetail.signature,
      };
      DatabaseMethods().addAppointment(appDetail, appointmentNumber);

      showNotification();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => SuccessPage(
              response: paymentResponse, appDetail: widget.appDetail),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Server Exception!!!');
      print(e);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              FailedApptBookPage(response: paymentResponse),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("payment has error");
    // Do something when payment fails
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => FailedPage(response: response),
      ),
      (Route<dynamic> route) => false,
    );
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("payment has externalWallet33333333333333333333333333");

    _razorpay.clear();
    // Do something when an external wallet is selected
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    var SelectNotification;
    // flutterLocalNotificationsPlugin.initialize(initSettings,SelectNotification: onSelectNotification);

    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android, ios),
        onSelectNotification: onSelectNotification);

    //appDetail = saveappdetail();
    options = {
      'key':
          "rzp_test_tf9U7AbQx8EyjV", // Enter the Key ID generated from the Dashboard

      'amount': widget.appDetail.ConsultationFee == null
          ? 0
          : widget.appDetail.ConsultationFee *
              100, //in the smallest currency sub-unit.
      //'amount': 100,
      'name': 'Bhaktivedanta Hospital',

      'currency': "INR",
      'theme.color': "#F37254",
      'buttontext': "Pay with Razorpay",
      'description': 'Online Payment',
      'prefill': {
        'contact': globals.user[0]['MobileNumber'] ?? '',
        'email': globals.user[0]["EmailID"] ?? "",
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    // print("razor runtime --------: ${_razorpay.runtimeType}");
    return Scaffold(
      body: FutureBuilder(
          future: payData(),
          builder: (context, snapshot) {
            return Container(
              child: Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
