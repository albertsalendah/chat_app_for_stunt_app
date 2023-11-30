// ignore_for_file: non_constant_identifier_names

class Contact {
  String? contact_id;
  String? nama;
  String? noHp;
  String? email;
  String? fcm_token;
  String? foto;

  Contact({
    this.contact_id,
    this.nama,
    this.noHp,
    this.email,
    this.fcm_token,
    this.foto,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    contact_id = json['contact_id'];
    nama = json['nama'];
    noHp = json['noHp'];
    email = json['email'];
    fcm_token = json['fcm_token'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact_id'] = contact_id;
    data['nama'] = nama;
    data['noHp'] = noHp;
    data['email'] = email;
    data['fcm_token'] = fcm_token;
    data['foto'] = foto;
    return data;
  }
}
