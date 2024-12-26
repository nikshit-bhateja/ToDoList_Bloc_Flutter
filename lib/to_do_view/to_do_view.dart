import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_yt/models/category_model.dart';
import 'package:to_do_list_yt/resources/animation_buttons/chevron_to_cross_button.dart';
import 'package:to_do_list_yt/resources/app_colors.dart';
import 'package:to_do_list_yt/resources/common_ui_components.dart';
import 'package:to_do_list_yt/to_do_bloc/to_do_category_bloc.dart';

class ToDoView extends StatefulWidget {
  const ToDoView({super.key});

  @override
  State<ToDoView> createState() => _ToDoViewState();
}

class _ToDoViewState extends State<ToDoView>
    with SingleTickerProviderStateMixin {
  // bloc variables
  final ToDoCategoryBloc toDoCategoryBloc = ToDoCategoryBloc();
  // animation variables
  late AnimationController _animationController;
  late Animation<double> _animation;

  // booleans
  bool isDetailedOrdeleteButtonEnable = true;
  bool isDeleteButtonEnabled = false;

  // Text Fields
  TextEditingController categoryNameController = TextEditingController();

  // custom methods
  deleteCategory(int categoryIndex) {
    toDoCategoryBloc.deleteCategory(categoryIndex);
    toDoCategoryBloc.add(GetToDoCategoryList());
    if (toDoCategoryBloc.toDoCategoryModel.isEmpty) {
      setState(() {
        isDeleteButtonEnabled = false;
      });
    }
  }

  //View Life Cycle
  @override
  void initState() {
    super.initState();
    toDoCategoryBloc.add(GetToDoCategoryList());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // User Interface(UI)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUIComponents.commonAppBar(
          context, 'To Do List', AppColors.primary, AppColors.textColor, [
        IconButton(
            onPressed: () {
              setState(() {
              isDetailedOrdeleteButtonEnable = true;
              isDeleteButtonEnabled = false;  
              categoryNameController.text = '';
              });
              showAddCategoryWithTitle(0);
            },
            icon: Icon(
              Icons.add,
              color: AppColors.textColor,
            )),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: (!isDetailedOrdeleteButtonEnable)
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              shape: BoxShape.circle),
          child: IconButton(
              onPressed: () {
                setState(() {
                  isDeleteButtonEnabled = false;
                  isDetailedOrdeleteButtonEnable =
                      !isDetailedOrdeleteButtonEnable;
                });
              },
              icon: Icon(
                Icons.edit,
                color: AppColors.textColor,
                size: 20,
              )),
        ),
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: (toDoCategoryBloc.toDoCategoryModel.isNotEmpty &&
                      isDeleteButtonEnabled)
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              shape: BoxShape.circle),
          child: IconButton(
              onPressed: _toggleAnimation,
              icon: Icon(
                Icons.delete,
                color: AppColors.textColor,
                size: 20,
              )),
        )
      ]),
      backgroundColor: AppColors.secondary,
      body: categoryListView(),
    );
  }

  // category list view
  Widget categoryListView() {
    return BlocProvider(
      create: (_) => toDoCategoryBloc,
      child: BlocListener<ToDoCategoryBloc, ToDoCategoryBlocState>(
          listener: (context, state) {
        if (state is ToDoCategoryBlocErrorState) {
          errorWidget(state.errorMessage.toString());
        }
      }, child: BlocBuilder<ToDoCategoryBloc, ToDoCategoryBlocState>(
        builder: (context, state) {
          if (state is ToDoCategoryBlocErrorState) {
            return errorWidget(state.errorMessage.toString());
          } else if (state is ToDoCategoryBlocInitialState) {
            return _buildLoading();
          } else if (state is ToDoCategoryBlocLoadingState) {
            return _buildLoading();
          } else if (state is ToDoCategoryBlocLoadedState) {
            return CategoryList(state.toDoCategoryModel);
          } else {
            return SizedBox();
          }
        },
      )),
    );
    // );
  }

  Widget errorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: AppColors.textColor,
          ),
          Text(
            message,
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          Text(
            'tap + button to add category',
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  Widget CategoryList(List<ToDoCategoryModel> categories) {
    return ListView.builder(
        itemCount: categories.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, categoryIndex) {
          return categoryItemCell(categories, categoryIndex);
        });
  }

  Widget categoryItemCell(
      List<ToDoCategoryModel> categories, int categoryIndex) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
          color: AppColors.textColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 3),
                blurRadius: 3)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categories[categoryIndex].title.toString(),
            style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
          // open category Items button
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return InkWell(
                onTap: () {
                  if(!isDetailedOrdeleteButtonEnable){
                    setState(() {
                      categoryNameController.text = toDoCategoryBloc.toDoCategoryModel[categoryIndex].title.toString();  
                    });
                    
                  }
                  isDeleteButtonEnabled
                      ? showDeleteCategory(categoryIndex)
                      : (!isDetailedOrdeleteButtonEnable) ? showAddCategoryWithTitle(categoryIndex) :print('Navigation check occured');
                },
                child: isDetailedOrdeleteButtonEnable
                    ? CustomPaint(
                        size: const Size(50, 50),
                        painter: ChevronToCrossPainter(_animation.value),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.edit,
                          color: AppColors.icon,
                          size: 20,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() => Center(
          child: CircularProgressIndicator(
        color: AppColors.textColor,
        semanticsLabel: 'Loading...',
      ));

// methods
  void _toggleAnimation() {
    if (_animationController.status == AnimationStatus.completed) {
      if (isDetailedOrdeleteButtonEnable == false) {
        _animationController.reset();
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    } else {
      _animationController.forward();
    }
    setState(() {
      isDetailedOrdeleteButtonEnable = true;
      isDeleteButtonEnabled = !isDeleteButtonEnabled;
    });
  }

  void showAddCategoryWithTitle(int categoryIndex) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Enter category name',
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            content: TextFormField(
              controller: categoryNameController,
              keyboardType: TextInputType.name,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (!isDetailedOrdeleteButtonEnable) {
                    toDoCategoryBloc.updateCategoryName(categoryIndex, categoryNameController.text);
                    toDoCategoryBloc.add(GetToDoCategoryList());
                  } else {
                    toDoCategoryBloc.addData(categoryNameController.text);
                    toDoCategoryBloc.add(GetToDoCategoryList());
                    
                  }
                  Navigator.pop(context);
                    setState(() {
                      categoryNameController.text = '';
                    });
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          );
        });
  }

  void showDeleteCategory(int categoryIndex) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Are you surely want to delete \"${toDoCategoryBloc.toDoCategoryModel[categoryIndex].title.toString()}\"',
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () {
                  toDoCategoryBloc.deleteCategory(categoryIndex);
                  toDoCategoryBloc.add(GetToDoCategoryList());
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          );
        });
  }
}
