part of 'to_do_category_bloc.dart';

abstract class ToDoCategoryBlocEvent extends Equatable{
  const ToDoCategoryBlocEvent();

  @override
  List<Object> get props => [];
}

class GetToDoCategoryList extends ToDoCategoryBlocEvent {}