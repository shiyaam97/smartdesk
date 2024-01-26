class CleanTimer{
  int? id;
  String table;
  String period;
  String time;

  CleanTimer({this.id,required this.table,required this.period,required this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'table':table,
      'period': period,
      'time': time,
    };
  }
  factory CleanTimer.fromMap(Map<String, dynamic> map) {
    return CleanTimer(
      id: map['id'],
      table: map['table'],
      period: map['period'],
      time: map['time'],
    );
  }
}