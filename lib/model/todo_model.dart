class TodoModel {
  String tId;
  String tList;
  String tDatetimeMod;

  TodoModel({this.tId, this.tList, this.tDatetimeMod});

  TodoModel.fromJson(Map<String, dynamic> json) {
    tId = json['t_id'];
    tList = json['t_list'];
    tDatetimeMod = json['t_datetime_mod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['t_id'] = this.tId;
    data['t_list'] = this.tList;
    data['t_datetime_mod'] = this.tDatetimeMod;
    return data;
  }
}
