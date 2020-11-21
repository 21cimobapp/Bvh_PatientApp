class PatientAppointmentdetails {
  String PatientCode;
  String PatientName;
  String DoctorCode;
  String DoctorName;
  String DoctorDesignation;
  DateTime ApptDate;
  String SlotName;
  String SlotNumber;
  String DoctorSlotFromTime;
  String DoctorSlotToTime;
  String SlotTimeLabel;
  String AppointmentType;
  int SlotDuration;
  int ConsultationFee;

  PatientAppointmentdetails(
      this.PatientCode,
      this.PatientName,
      this.DoctorCode,
      this.DoctorName,
      this.DoctorDesignation,
      this.ApptDate,
      this.SlotName,
      this.SlotNumber,
      this.DoctorSlotFromTime,
      this.DoctorSlotToTime,
      this.SlotTimeLabel,
      this.AppointmentType,
      this.SlotDuration,
      this.ConsultationFee);
}

class PatientAppointment {
  String SlotAvailable;
  String DoctorTimingSlotName;
  String DoctorSlotFromTime;
  String DoctorSlotToTime;
  String SlotTimeLabel;
  String AppointmentType;
  int SlotDuration;
  String SlotNumber;
  int SlotNumberID;
  int ConsultationFee;

  PatientAppointment(
      this.SlotAvailable,
      this.DoctorTimingSlotName,
      this.DoctorSlotFromTime,
      this.DoctorSlotToTime,
      this.SlotTimeLabel,
      this.AppointmentType,
      this.SlotDuration,
      this.SlotNumber,
      this.SlotNumberID,
      this.ConsultationFee);

  PatientAppointment.fromJson(Map<String, dynamic> json) {
    SlotAvailable = json["SlotAvailable"];
    DoctorTimingSlotName = json["DoctorTimingSlotName"];
    DoctorSlotFromTime = json["DoctorSlotFromTime"];
    DoctorSlotToTime = json["DoctorSlotToTime"];
    SlotTimeLabel = json["SlotTimeLabel"];
    AppointmentType = json["AppointmentType"];
    SlotDuration = json["SlotDuration"];
    SlotNumber = json["SlotNumber"];
    SlotNumberID = json["SlotNumberID"];
    ConsultationFee = json["ConsultationFee"];
  }
}
