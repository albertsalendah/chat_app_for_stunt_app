// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../models/rekomendasiMenuMakan.dart';
import '../../models/user.dart';

abstract class AllState extends Equatable {
  const AllState();

  @override
  List<Object> get props => [];
}

class DataInitialState extends AllState {}

class UserDataLoaded extends AllState {
  final User user;

  const UserDataLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class ListRekomendasiMenuLoaded extends AllState {
  final List<RekomendasiMenuMakan> listRekomendasi;

  const ListRekomendasiMenuLoaded(this.listRekomendasi);

  @override
  List<Object> get props => [listRekomendasi];
}

class DataErrorState extends AllState {
  final String errorMessage;

  const DataErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
