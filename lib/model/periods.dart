class Periods {
  int? id;
  String period;
  String tabletype;
  String time;

  Periods({this.id,required this.tabletype, required this.period, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tabletype': tabletype,
      'period': period,
      'time': time,
    };
  }

  factory Periods.fromMap(Map<String, dynamic> map) {
    return Periods(
      id: map['id'],
      tabletype:map['tabletype'],
      period: map['period'],
      time: map['time'],
    );
  }
}
