class MedicalHistoryModel {
  final int id;
  final String title;
  final String content;
  final DateTime date;
  final String tag;

  MedicalHistoryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.tag,
  });

  factory MedicalHistoryModel.fromJson(Map<String, dynamic> json) {
    final id = json['medicalhistory_id'] ?? {};
    final title = json['medicalhistory_title'] ?? {};
    final content = json['medicalhistory_content'] ?? {};
    final date = json['medicalhistory_date'] ?? {};
    final tags = json['tags'] ?? {};

    return MedicalHistoryModel(
      id: id,
      title: title,
      content: content,
      date: date,
      tag: tags,
    );
  }

  static yee() {
    print("yee");
  }
}
