import 'package:civideoconnectapp/src/pages/home_patient/patient_feedback_submitted.dart';
import 'package:file_picker/file_picker.dart';
import 'package:civideoconnectapp/src/pages/home_patient/slider_widget.dart';
import 'package:civideoconnectapp/src/pages/home_patient/syles.dart';
import 'package:civideoconnectapp/utils/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PatientFeedback extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PatientFeedback> {
  final Color _backgroundColor = Color(0xFFf0f0f0);
  double _value1 = 0;
  bool canContact = false;
  String valueString;
  String _filePath;
  String fileName;
  @override
  void initState() {
    super.initState();
  }

  TextStyle get bodyTextStyle => TextStyle(
        color: Color(0xFF083e64),
        fontSize: 13,
        fontFamily: 'OpenSans',
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      //appBar: _buildAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 30, bottom: 50),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Container(
                            height: 140,
                            width: double.infinity,
                            child: Image.asset(
                              "assets/images/PatientFeedback.jpg",
                              fit: BoxFit.fill,
                            )),
                        Container(
                          padding: const EdgeInsets.all(15.0),
                          height: 140,
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15.0),
                                color: Colors.white,
                                child: Text(
                                  "Feedback",
                                  style: bodyTextStyle.copyWith(fontSize: 20),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        //color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "We are grateful to you for giving us the opportunity to serve you. To help us in our Endeavour to serve you better we sincerely request you to kindly give us your opinion and suggestions on Online consultation. We appreciate your feedback and assure you of our best services always.",
                              style: bodyTextStyle,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        )),
                  ),
                  showFeedbackRating(
                      "PLEASE RATE YOUR EXPERIENCE WITH THE CONSULTANT/DOCTOR."
                          .toUpperCase(),
                      5.0,
                      "1-Strongly Disagree 2-Disagree 3-OK 4-Agree 5-Strongly Agree"),
                  showFeedbackRating(
                      "The waiting time to see the doctor".toUpperCase(),
                      5.0,
                      "1 (> 60 Minutes) 2 (45-60 Minutes) 3 (30-45 Minutes) 4 (15-30 Minutes) 5 (< 15 Minutes)"),
                  showFeedbackRating(
                      "WOULD YOU CONSIDER US FOR FUTURE MEDICAL NEEDS?",
                      5.0,
                      "1-Strongly Disagree 2-Disagree 3-OK 4-Agree 5-Strongly Agree"
                          .toUpperCase()),
                  showFeedbackOption(
                      "How did you come to know about our service?"
                          .toUpperCase(),
                      {
                        "1": "Friend/ Relative",
                        "2": "WhatsApp",
                        "3": "Facebook/ Twitter/ Website",
                        "4": "SMS",
                        "5": "Other"
                      },
                      "5"),
                  showFeedbackAttachment("Attachment".toUpperCase()),
                  showFeedbackText("COMMENTS/SUGGESTIONS".toUpperCase()),
                  Container(
                    color: Colors.white,
                    child: CheckboxListTile(
                      secondary: const Icon(Icons.call),
                      title: const Text(
                        'I am ok with authorised representative from Hospital contacting me for further feedback.',
                      ),
                      //subtitle: Text('Ringing after 12 hours'),
                      value: canContact,
                      onChanged: (bool value) {
                        setState(() {
                          canContact = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            //padding: const EdgeInsets.only(bottom: 18.0),
            //width: 300,
            child: Container(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonTheme(
                    //minWidth: 250,
                    //height: 40,
                    child: FlatButton(
                      //Enable the button if we have enough points. Can do this by assigning a onPressed listener, or not.
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PatientFeedbackSubmitted(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      color: Colors.orangeAccent,
                      disabledColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Submit",
                              style: Styles.text(16, Colors.white, true)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showFeedbackRating(String question, defaultRating, String helpText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.toUpperCase(),
                style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip,
              ),
              SizedBox(height: 10),
              SliderWidget(
                min: 0,
                max: 5,
                defaultValue: defaultRating,
                divisions: 5,
                fullWidth: true,
                onChanged: (value) {
                  setState(() {
                    _value1 = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Text(
                "$helpText",
                style: bodyTextStyle,
                overflow: TextOverflow.clip,
              ),
            ],
          )),
    );
  }

  Widget showFeedbackText(String question) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.toUpperCase(),
                style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip,
              ),
              SizedBox(height: 10),
              new TextField(
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  hintText: '',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 4,
              ),
              SizedBox(height: 10),
            ],
          )),
    );
  }

  Widget showFeedbackOption(String question, options, String defaultSelection) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.toUpperCase(),
                style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip,
              ),
              SizedBox(height: 10),
              CupertinoRadioChoice(
                  selectedColor: Colors.orange,
                  notSelectedColor: Colors.grey[300],
                  choices: options,
                  onChange: (selectedGender) {
                    setState(() {
                      valueString = selectedGender;
                    });
                  },
                  initialKeyValue: defaultSelection),
              SizedBox(height: 10),
            ],
          )),
    );
  }

  Widget showFeedbackAttachment(String question) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.toUpperCase(),
                style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip,
              ),
              SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300],
                      width: 1, //                   <--- border width here
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              "${fileName == null ? "Select file" : fileName}")),
                      Container(
                          //padding: const EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.grey[300],
                          child: RawMaterialButton(
                            onPressed: () => {openFileExplorer()},
                            child: Text("...",
                                style: bodyTextStyle.copyWith(fontSize: 25)),
                          )),
                    ],
                  )),
              SizedBox(height: 10),
            ],
          )),
    );
  }

  void openFileExplorer() async {
    try {
      _filePath = null;
      _filePath = await FilePicker.getFilePath(
          type: FileType.custom, allowedExtensions: ['pdf']);
      if (_filePath != null) {
        setState(() {
          fileName = _filePath.split('/').last;
        });
      }
    } catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  Widget _buildAppBar() {
    Color appBarIconsColor = Color(0xFF212121);
    return AppBar(
      //leading: Icon(Icons.home, color: appBarIconsColor),
      actions: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.only(right: 18.0),
        //   child: Icon(Icons.more_horiz, color: appBarIconsColor, size: 28),
        // )
      ],
      brightness: Brightness.light,
      backgroundColor: _backgroundColor,
      elevation: 0,
      title: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text('DashBoard'.toUpperCase(),
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
