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

  const ListLatestMesasage(this.listLatestMessage);

  @override
  List<Object> get props => [listLatestMessage];
}

class ListIndividualMesasage extends KonsultasiState {
  final List<MessageModel> listIndividualMessage;

  const ListIndividualMesasage(this.listIndividualMessage);

  @override
  List<Object> get props => [listIndividualMessage];
}

class DataErrorState extends KonsultasiState {
  final String errorMessage;

  const DataErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
