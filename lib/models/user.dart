// ignore_for_file: non_constant_identifier_names

/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/

class User {
  String? userID;
  String? nama;
  String? nohp;
  String? email;
  String? password;
  String? fcm_token;
  String? foto;
  String? keterangan;
  int? health_worker;

  User(
      {this.userID,
      this.nama,
      this.nohp,
      this.email,
      this.password,
      this.fcm_token,
      this.foto,
      this.keterangan,
      this.health_worker});

  User.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    nama = json['nama'];
    nohp = json['no_hp'];
    email = json['email'];
    password = json['password'];
    fcm_token = json['fcm_token'];
    foto = json['foto'];
    keterangan = json['keterangan'];
    health_worker = json['health_worker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['nama'] = nama;
    data['no_hp'] = nohp;
    data['email'] = email;
    data['password'] = password;
    data['fcm_token'] = fcm_token;
    data['foto'] = foto;
    data['keterangan'] = keterangan;
    data['health_worker'] = health_worker;
    return data;
  }
}
