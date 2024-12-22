import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_yt/models/category_model.dart';
import 'package:equatable/equatable.dart';

part 'to_do_category_bloc_event.dart';
part 'to_do_category_bloc_state.dart';

class ToDoCategoryBloc
    extends Bloc<ToDoCategoryBlocEvent, ToDoCategoryBlocState> {
  ToDoCategoryBloc() : super(ToDoCategoryBlocInitialState()) {
    on<GetToDoCategoryList>((event, emit)  {
      // try {
        emit(ToDoCategoryBlocLoadingState());
        final modelData = addData();
        emit(ToDoCategoryBlocLoadedState(toDoCategoryModel: modelData));
        if (modelData == null) {
          emit(ToDoCategoryBlocErrorState(
              errorMessage: 'No Data Added at initial state'));
        }
      // } on Error {
      //   debugPrint("Error Occured $ErrorDescription");
      // }
    });
  }

  addData() {
    List<ToDoCategoryModel> toDoCategoryModel = [];
    for (var category = 1; category < 21; category++) {
      var data = ToDoCategoryModel(
          id: category,
          created_at: DateTime.now(),
          deleted_at: DateTime.now(),
          title: 'Category $category',
          items: []);

      toDoCategoryModel.insert(category-1, data);
    }
    return toDoCategoryModel;
  }
}
