part of 'to_do_category_bloc.dart';

abstract class ToDoCategoryBlocState extends Equatable {
  const ToDoCategoryBlocState();

  @override
  List<Object?> get props => [];
}

class ToDoCategoryBlocInitialState extends ToDoCategoryBlocState {}

class ToDoCategoryBlocLoadingState extends ToDoCategoryBlocState {}

class ToDoCategoryBlocLoadedState extends ToDoCategoryBlocState {
  final List<ToDoCategoryModel> toDoCategoryModel;
  const ToDoCategoryBlocLoadedState({required this.toDoCategoryModel});
}

class ToDoCategoryBlocErrorState extends ToDoCategoryBlocState {
  final String? errorMessage;
  const ToDoCategoryBlocErrorState({this.errorMessage});
}
