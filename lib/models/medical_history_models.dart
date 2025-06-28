class MedicationModel {
  final String id;
  final String title;
  final String content;
  final DateTime date;

  MedicationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['medicalhistory_id'],
      title: json['medicalhistory_title'] ?? 'Untitled',
      content: json['medicalhistory_content'] ?? '',
      date: DateTime.parse(json['medicalhistory_date']),
    );
  }
}

class ProcedureModel {
  final String id;
  final String title;
  final String content;
  final DateTime date;

  ProcedureModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  factory ProcedureModel.fromJson(Map<String, dynamic> json) {
    return ProcedureModel(
      id: json['medicalhistory_id'],
      title: json['medicalhistory_title'] ?? 'Untitled',
      content: json['medicalhistory_content'] ?? '',
      date: DateTime.parse(json['medicalhistory_date']),
    );
  }
}
