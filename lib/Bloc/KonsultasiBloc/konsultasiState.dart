import 'package:chat_app_for_stunt_app/models/contact_model.dart';
import 'package:equatable/equatable.dart';

import '../../models/message_model.dart';
import '../../models/user.dart';

abstract class KonsultasiState extends Equatable {
  const KonsultasiState();

  @override
  List<Object> get props => [];
}

class DataInitialState extends KonsultasiState {}

class HealthWorkerLoaded extends KonsultasiState {
  final List<User> healthWorker;

  const HealthWorkerLoaded(this.healthWorker);

  @override
  List<Object> get props => [healthWorker];
}

class ListLatestMesasage extends KonsultasiState {
  final List<MessageModel> listLatestMessage;
  final List<MessageModel> listAllUnread;

  const ListLatestMesasage(this.listLatestMessage, this.listAllUnread);

  @override
  List<Object> get props => [listLatestMessage, listAllUnread];
}

class ListIndividualMesasage extends KonsultasiState {
  final List<MessageModel> listIndividualMessage;

  const ListIndividualMesasage(this.listIndividualMessage);

  @override
  List<Object> get props => [listIndividualMessage];
}

class DaftarKontakLoaded extends KonsultasiState {
  final List<Contact> daftarkontak;

  const DaftarKontakLoaded(this.daftarkontak);

  @override
  List<Object> get props => [daftarkontak];
}

class KontakLoaded extends KonsultasiState {
  final Contact kontak;

  const KontakLoaded(this.kontak);

  @override
  List<Object> get props => [kontak];
}

class DataErrorState extends KonsultasiState {
  final String errorMessage;

  const DataErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
