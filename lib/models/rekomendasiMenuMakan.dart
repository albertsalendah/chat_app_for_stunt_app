/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class RekomendasiMenuMakan {
  String? idmenu;
  String? userid;
  int? menumakan;
  String? tanggal;
  String? jammakan;
  String? makananpokok;
  int? jumlahmk;
  String? satuanmk;
  String? sayur;
  int? jumlahsayur;
  String? satuansayur;
  String? laukhewani;
  int? jumlahlaukhewani;
  String? satuanlaukhewani;
  String? lauknabati;
  int? jumlahlauknabati;
  String? satuanlauknabati;
  String? buah;
  int? jumlahbuah;
  String? satuanbuah;
  String? minuman;
  int? jumlahminuman;
  String? satuanminuman;

  RekomendasiMenuMakan(
      {this.idmenu,
      this.userid,
      this.menumakan,
      this.tanggal,
      this.jammakan,
      this.makananpokok,
      this.jumlahmk,
      this.satuanmk,
      this.sayur,
      this.jumlahsayur,
      this.satuansayur,
      this.laukhewani,
      this.jumlahlaukhewani,
      this.satuanlaukhewani,
      this.lauknabati,
      this.jumlahlauknabati,
      this.satuanlauknabati,
      this.buah,
      this.jumlahbuah,
      this.satuanbuah,
      this.minuman,
      this.jumlahminuman,
      this.satuanminuman});

  RekomendasiMenuMakan.fromJson(Map<String, dynamic> json) {
    idmenu = json['id_menu'];
    userid = json['user_id'];
    menumakan = json['menu_makan'];
    tanggal = json['tanggal'];
    jammakan = json['jam_makan'];
    makananpokok = json['makanan_pokok'];
    jumlahmk = json['jumlah_mk'];
    satuanmk = json['satuan_mk'];
    sayur = json['sayur'];
    jumlahsayur = json['jumlah_sayur'];
    satuansayur = json['satuan_sayur'];
    laukhewani = json['lauk_hewani'];
    jumlahlaukhewani = json['jumlah_lauk_hewani'];
    satuanlaukhewani = json['satuan_lauk_hewani'];
    lauknabati = json['lauk_nabati'];
    jumlahlauknabati = json['jumlah_lauk_nabati'];
    satuanlauknabati = json['satuan_lauk_nabati'];
    buah = json['buah'];
    jumlahbuah = json['jumlah_buah'];
    satuanbuah = json['satuan_buah'];
    minuman = json['minuman'];
    jumlahminuman = json['jumlah_minuman'];
    satuanminuman = json['satuan_minuman'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_menu'] = idmenu;
    data['user_id'] = userid;
    data['menu_makan'] = menumakan;
    data['tanggal'] = tanggal;
    data['jam_makan'] = jammakan;
    data['makanan_pokok'] = makananpokok;
    data['jumlah_mk'] = jumlahmk;
    data['satuan_mk'] = satuanmk;
    data['sayur'] = sayur;
    data['jumlah_sayur'] = jumlahsayur;
    data['satuan_sayur'] = satuansayur;
    data['lauk_hewani'] = laukhewani;
    data['jumlah_lauk_hewani'] = jumlahlaukhewani;
    data['satuan_lauk_hewani'] = satuanlaukhewani;
    data['lauk_nabati'] = lauknabati;
    data['jumlah_lauk_nabati'] = jumlahlauknabati;
    data['satuan_lauk_nabati'] = satuanlauknabati;
    data['buah'] = buah;
    data['jumlah_buah'] = jumlahbuah;
    data['satuan_buah'] = satuanbuah;
    data['minuman'] = minuman;
    data['jumlah_minuman'] = jumlahminuman;
    data['satuan_minuman'] = satuanminuman;
    return data;
  }
}
