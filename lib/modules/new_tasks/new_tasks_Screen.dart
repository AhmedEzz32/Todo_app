import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/shared/components/components.dart';
import 'package:project1/shared/cubit/cubit.dart';
import 'package:project1/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,state) {},
      builder: (context,state)
      {
        var tasks = AppCubit.get(context).newTasks;

        return TasksBuilder(tasks: tasks);
      },
    );
  }
}