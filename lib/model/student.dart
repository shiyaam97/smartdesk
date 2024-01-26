class Student {
  int? id;
  String name;
  String className;

  Student({this.id, required this.name, required this.className});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'class': className,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      className: map['class'],
    );
  }
}
