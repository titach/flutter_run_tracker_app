class Run {
  String? id;
  String? runWhere;
  String? runPerson;
  int? runDistance;
  String? runImageUrl;

  Run({
    this.id,
    this.runWhere,
    this.runPerson,
    this.runDistance,
    this.runImageUrl,
  });

  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      id: json['id'] as String?,
      runWhere: json['runWhere'] as String?,
      runPerson: json['runPerson'] as String?,
      runDistance: json['runDistance'] as int?,
      runImageUrl: json['runImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'runWhere': runWhere,
      'runPerson': runPerson,
      'runDistance': runDistance,
      'runImageUrl': runImageUrl,
    };
  }
}
