// 최상위 응답 구조
class PatientImagingResponse {
  final bool success;
  final String patientMrn;
  final List<ImagingStudy> imagingStudies;
  final int totalStudies;
  final String? message;

  PatientImagingResponse({
    required this.success,
    required this.patientMrn,
    required this.imagingStudies,
    required this.totalStudies,
    this.message,
  });

  factory PatientImagingResponse.fromJson(Map<String, dynamic> json) {
    // imaging_studies 리스트를 ImagingStudy 객체 리스트로 변환
    var studiesList = json['imaging_studies'] as List;
    List<ImagingStudy> imagingStudiesList = studiesList.map((i) => ImagingStudy.fromJson(i)).toList();

    return PatientImagingResponse(
      success: json['success'],
      patientMrn: json['patient_mrn'],
      imagingStudies: imagingStudiesList,
      totalStudies: json['total_studies'],
      message: json['message'],
    );
  }
}

// 영상 촬영 연구 정보
class ImagingStudy {
  final int subjectId;
  final String subjectName;
  final String patientMrn;
  final String modality;
  final String bodyPart;
  final String? studyDate;
  final String studyDescription;
  final DateTime createdAt;
  final List<Series> series;

  ImagingStudy({
    required this.subjectId,
    required this.subjectName,
    required this.patientMrn,
    required this.modality,
    required this.bodyPart,
    this.studyDate,
    required this.studyDescription,
    required this.createdAt,
    required this.series,
  });

  factory ImagingStudy.fromJson(Map<String, dynamic> json) {
    var seriesList = json['series'] as List;
    List<Series> seriesObjectList = seriesList.map((i) => Series.fromJson(i)).toList();

    return ImagingStudy(
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      patientMrn: json['patient_mrn'],
      modality: json['modality'],
      bodyPart: json['body_part'],
      studyDate: json['study_date'],
      studyDescription: json['study_description'],
      createdAt: DateTime.parse(json['created_at']),
      series: seriesObjectList,
    );
  }
}

// 시리즈 정보
class Series {
  final int seriesId;
  final String sequenceType;
  final String fileUri;
  final String slicesDir;
  final int sliceIdx;
  final String imageResolution;
  final String? seriesDescription;
  final String? acquisitionTime;
  final DateTime createdAt;
  final List<Disease> diseases;

  Series({
    required this.seriesId,
    required this.sequenceType,
    required this.fileUri,
    required this.slicesDir,
    required this.sliceIdx,
    required this.imageResolution,
    this.seriesDescription,
    this.acquisitionTime,
    required this.createdAt,
    required this.diseases,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    var diseasesList = json['diseases'] as List;
    List<Disease> diseasesObjectList = diseasesList.map((i) => Disease.fromJson(i)).toList();

    return Series(
      seriesId: json['series_id'],
      sequenceType: json['sequence_type'],
      fileUri: json['file_uri'],
      slicesDir: json['slices_dir'],
      sliceIdx: json['slice_idx'],
      imageResolution: json['image_resolution'],
      seriesDescription: json['series_description'],
      acquisitionTime: json['acquisition_time'],
      createdAt: DateTime.parse(json['created_at']),
      diseases: diseasesObjectList,
    );
  }
}

// 질병 정보
class Disease {
  final int diseaseId;
  final BoundingBox boundingBox;
  final String? disease;
  final double confidenceScore;
  final String className;
  final DateTime createdAt;

  Disease({
    required this.diseaseId,
    required this.boundingBox,
    this.disease,
    required this.confidenceScore,
    required this.className,
    required this.createdAt,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      diseaseId: json['disease_id'],
      boundingBox: BoundingBox.fromJson(json['bounding_box']),
      disease: json['disease'],
      confidenceScore: json['confidence_score'],
      className: json['class_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// Bounding Box 좌표
class BoundingBox {
  final int x1;
  final int y1;
  final int x2;
  final int y2;
  final int? z1;
  final int? z2;

  BoundingBox({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    this.z1,
    this.z2,
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      x1: json['x1'],
      y1: json['y1'],
      x2: json['x2'],
      y2: json['y2'],
      z1: json['z1'],
      z2: json['z2'],
    );
  }
}
