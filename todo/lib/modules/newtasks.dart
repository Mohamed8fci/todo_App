import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

import '../shared/component.dart';
class newtasks extends StatelessWidget {
  const newtasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(

      listener: (context , state){},
        builder: (context,state){

      var tasks = AppCubit.get(context).newTasks;
      return ListView.separated(itemBuilder: (context,index)=>buildTaskItem(tasks[index],context),
          separatorBuilder: (context, index) =>Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          )
          , itemCount: tasks.length);

    },

    );
  }
}
