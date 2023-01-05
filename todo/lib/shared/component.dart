import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model,context) =>Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40.0,
  
          child: Text(
  
              "${model['time']}"
  
          ),
  
        ),
  
        SizedBox(
  
          width: 24.0,
  
        ),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
              Text('${model['title']}',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
  
              Text('${model['date']}',style: TextStyle(color: Colors.grey),),
  
            ],
  
          ),
  
        ),
  
        SizedBox(
  
          width: 24.0,
  
        ),
  
        IconButton(
  
          onPressed: (){
  
          AppCubit.get(context).updateData(status: 'done', id: model['id']);
  
          },
  
          icon: Icon(
  
            Icons.check_box,
  
            color: Colors.blue,
  
          ),
  
        ),
  
        IconButton(
  
          onPressed: (){
  
            AppCubit.get(context).updateData(status: 'archived', id: model['id']);

          },
  
          icon: Icon(
  
            Icons.archive,
  
            color: Colors.amber,
  
          ),
  
        ),

      ],
  
    ),
  
  ),
  onDismissed: (direction){
AppCubit.get(context).deleteData(id:model['id'],);
  },
);