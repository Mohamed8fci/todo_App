import 'dart:core';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class home extends StatelessWidget {


    var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..create_database(),
      child: BlocConsumer<AppCubit,AppStates>(
           listener: (BuildContext context,AppStates states){
             if(states is AppInsertIntoDataBaseState){
               Navigator.pop(context);
             }
           },
            builder: (BuildContext context,AppStates states)
            {
              AppCubit cubit = AppCubit.get(context);

             return Scaffold(
             key: scaffoldKey,

             appBar: AppBar(title: Text(
                 cubit.titles[cubit.current_index]),),

             body: ConditionalBuilder(
             condition: states is! AppGetDataBaseloadingState,
             builder: (context) => cubit.screens[cubit.current_index],
             fallback: (context) => Center(child: CircularProgressIndicator()),
             ),

             floatingActionButton: FloatingActionButton(
             onPressed: () async
             {
             if (cubit.isbottomsheetshown) {
             if (formKey.currentState!.validate()) {

              cubit.insertintodatabase(title: titlecontroller.text, time: timecontroller.text, date: datecontroller.text);
               /*insertintodatabase(
             title: titlecontroller.text,
             time: timecontroller.text,
             date: datecontroller.text,
             ).then((value) {
             getDataFromDatabase(database).then((value) {
             Navigator.pop(context);
             //     setState(() {
             //     isbottomsheetshown = false;
             //    fabicon = Icons.edit;
             //     tasks = value;
             //   });
             });
             });   */
             }
             } else {
             scaffoldKey.currentState?.showBottomSheet((context) =>
             Container(
             color: Colors.white,
             padding: EdgeInsets.all(16.0),
             child: Form(
             key: formKey,
             child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
             TextFormField(
             controller: titlecontroller,
             validator: (value) {
             if (value!.isEmpty) {
             return 'value must be not empty';
             }
             return null;
             },

             decoration: InputDecoration(labelText: "task title",
             prefix: Icon(Icons.title)
             ),
             keyboardType: TextInputType.text,
             ),
             SizedBox(
             height: 16.0,
             ),
             TextFormField(
             controller: timecontroller,
             validator: (value) {
             if (value!.isEmpty) {
             return 'time must be not empty';
             }
             return null;
             },
             onTap: () {
             showTimePicker(
             context: context, initialTime: TimeOfDay.now(),
             ).then((value) {
             timecontroller.text =
             value!.format(context).toString();
             });
             },
             decoration: InputDecoration(labelText: "task time",
             prefix: Icon(Icons.watch_later_outlined)
             ),
             keyboardType: TextInputType.datetime,
             ),
             SizedBox(
             height: 16.0,
             ),
             TextFormField(
             controller: datecontroller,
             validator: (value) {
             if (value!.isEmpty) {
             return 'date must be not empty';
             }
             return null;
             },
             onTap: () {
             showDatePicker
             (context: context,
             initialDate: DateTime.now(),
             firstDate: DateTime.now()
             ,
             lastDate: DateTime.parse('2023-06-18'),
             ).then((value) {
             print(DateFormat.yMMMd().format(value!));
             datecontroller.text =
             DateFormat.yMMMd().format(value);
             });
             },
             decoration: InputDecoration(labelText: "task date",
             prefix: Icon(Icons.calendar_today)
             ),
             keyboardType: TextInputType.datetime,
             ),
             ],
             ),
             ),
             ),
             elevation: 16.0,
             ).closed.then((value) {
               cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);

             });
             cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
             }
             },

             child: Icon(cubit.fabicon),
             ),

      bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: AppCubit.get(context).current_index,
      onTap: (index) {
      AppCubit.get(context).changeIndex(index);
      },
      items: [
      BottomNavigationBarItem(icon: Icon(Icons.menu)
      , label: 'Tasks'),
      BottomNavigationBarItem(icon: Icon(Icons.check_circle)
      , label: 'Done'),
      BottomNavigationBarItem(icon: Icon(Icons.archive_outlined)
      , label: 'Archived'),
      ],
      ),

      );
        },
      ),
    );
  }
 // Future <String> getname() async {
  //  return "mohamed elkordy";
 // }
}