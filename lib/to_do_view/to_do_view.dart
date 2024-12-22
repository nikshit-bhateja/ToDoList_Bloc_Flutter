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
            onPressed: _toggleAnimation,
            icon: Icon(
              Icons.edit,
              color: AppColors.textColor,
              size: 20,
            ))
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
            ),
          );
        }
      }, child: BlocBuilder<ToDoCategoryBloc, ToDoCategoryBlocState>(
        builder: (context, state) {
          if (state is ToDoCategoryBlocInitialState) {
            return _buildLoading();
          } else if (state is ToDoCategoryBlocLoadingState) {
            return _buildLoading();
          }else if(state is ToDoCategoryBlocLoadedState){
            return CategoryList(state.toDoCategoryModel);
          }else {
            return SizedBox();
          }
        },
      )),
    );
    // );
  }

  Widget CategoryList(List<ToDoCategoryModel> categories) {
    return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, categoryIndex) {
          return categoryItemCell(categories, categoryIndex);
        });
  }

  Widget categoryItemCell(List<ToDoCategoryModel> categories, int categoryIndex) {
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
                  print('Next and Close Button Tapped');
                },
                child: CustomPaint(
                  size: const Size(50, 50),
                  painter: ChevronToCrossPainter(_animation.value),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator(color: AppColors.textColor,semanticsLabel: 'Loading...',));

// methods
  void _toggleAnimation() {
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }
}
