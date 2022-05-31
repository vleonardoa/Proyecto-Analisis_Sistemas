class Nota {
  final int? id;
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final DateTime? createdTime;

  Nota(this.id, this.isImportant, this.number, this.title, this.description,
      this.createdTime);
  factory Nota.fromMap(Map<String, dynamic> json) {
    return Nota(json['id'], json['isImportant'], json['number'], json['title'],
        json['destription'], json['createdTime']);
  }
  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(json['id'], json['isImportant'], json['number'], json['title'],
        json['description'], DateTime.parse(json['createdTime']));
  }
}
