class MemberModel {
  String uId;
  String uFname;
  String uLname;
  String uAddress;
  String uUrlpictrue;
  String uEmail;
  String uPhone;
  String uDatetimeMod;

  MemberModel(
      {this.uId,
        this.uFname,
        this.uLname,
        this.uAddress,
        this.uUrlpictrue,
        this.uEmail,
        this.uPhone,
        this.uDatetimeMod});

  MemberModel.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
    uFname = json['u_fname'];
    uLname = json['u_lname'];
    uAddress = json['u_address'];
    uUrlpictrue = json['u_urlpictrue'];
    uEmail = json['u_email'];
    uPhone = json['u_phone'];
    uDatetimeMod = json['u_datetime_mod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['u_id'] = this.uId;
    data['u_fname'] = this.uFname;
    data['u_lname'] = this.uLname;
    data['u_address'] = this.uAddress;
    data['u_urlpictrue'] = this.uUrlpictrue;
    data['u_email'] = this.uEmail;
    data['u_phone'] = this.uPhone;
    data['u_datetime_mod'] = this.uDatetimeMod;
    return data;
  }
}
