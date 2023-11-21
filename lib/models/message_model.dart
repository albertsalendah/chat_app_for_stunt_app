/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class MessageModel {
  String? idmessage;
  String? idsender;
  String? idreceiver;
  String? tanggalkirim;
  String? jamkirim;
  String? message;
  String? image;
  int? messageRead;
  String? namaReceiver;
  String? ketReceiver;
  String? fcm_token;
  String? fotoReceiver;

  MessageModel({
    this.idmessage,
    this.idsender,
    this.idreceiver,
    this.tanggalkirim,
    this.jamkirim,
    this.message,
    this.image,
    this.messageRead,
    this.namaReceiver,
    this.ketReceiver,
    this.fcm_token,
    this.fotoReceiver,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    idmessage = json['id_message'];
    idsender = json['id_sender'];
    idreceiver = json['id_receiver'];
    tanggalkirim = json['tanggal_kirim'];
    jamkirim = json['jam_kirim'];
    message = json['message'];
    image = json['image'];
    messageRead = json['messageRead'];
    namaReceiver = json['namaReceiver'];
    ketReceiver = json['ketReceiver'];
    fcm_token = json['fcm_token'];
    fotoReceiver = json['fotoReceiver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_message'] = idmessage;
    data['id_sender'] = idsender;
    data['id_receiver'] = idreceiver;
    data['tanggal_kirim'] = tanggalkirim;
    data['jam_kirim'] = jamkirim;
    data['message'] = message;
    data['image'] = image;
    data['messageRead'] = messageRead;
    data['namaReceiver'] = namaReceiver;
    data['ketReceiver'] = ketReceiver;
    data['fcm_token'] = fcm_token;
    data['fotoReceiver'] = fotoReceiver;
    return data;
  }
}
