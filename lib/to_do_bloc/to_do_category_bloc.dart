import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_yt/models/category_model.dart';
import 'package:equatable/equatable.dart';

part 'to_do_category_bloc_event.dart';
part 'to_do_category_bloc_state.dart';

class ToDoCategoryBloc
    extends Bloc<ToDoCategoryBlocEvent, ToDoCategoryBlocState> {
  List<ToDoCategoryModel> toDoCategoryModel = [];

  ToDoCategoryBloc() : super(ToDoCategoryBlocInitialState()) {
    on<GetToDoCategoryList>((event, emit) {
      // try {
      emit(ToDoCategoryBlocLoadingState());
      final modelData = toDoCategoryModel;
      emit(ToDoCategoryBlocLoadedState(toDoCategoryModel: modelData));
      if (modelData.isEmpty) {
        print('ToDoCategoryBlocErrorState emitted');
        emit(ToDoCategoryBlocErrorState(errorMessage: 'No Data Found'));
      }
    });
  }

  addData(String title) {
    // for (var category = 1; category < 21; category++) {
    var data = ToDoCategoryModel(
        id: toDoCategoryModel.length + 1,
        created_at: DateTime.now(),
        deleted_at: DateTime.now(),
        title: title,
        items: []);
    if (toDoCategoryModel.length == 0) {
      toDoCategoryModel.insert(0, data);
    } else {
      toDoCategoryModel.insert(toDoCategoryModel.length, data);
    }
    return toDoCategoryModel;
  }

  deleteCategory(int categoryIndex) {
    if (toDoCategoryModel.isNotEmpty) {
      toDoCategoryModel.removeAt(categoryIndex);
    }
  }

  updateCategoryName(int categoryIndex, String updatedValue) {
    toDoCategoryModel[categoryIndex].title = updatedValue;
  }
}
