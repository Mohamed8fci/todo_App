import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';
import '../../modules/archievedtask.dart';
import '../../modules/donetask.dart';
import '../../modules/newtasks.dart';

class AppCubit extends Cubit<AppStates>{
   AppCubit() : super(appInitialStates());

   static AppCubit get(context) => BlocProvider.of(context);

   List<Map> newTasks= [];
   List<Map> doneTasks= [];
   List<Map> archivedTasks= [];
   int current_index = 0;

   List<Widget> screens = [
      newtasks(),
      donetasks(),
      archivedtasks(),
   ];

   List<String> titles = [
      'new Tasks',
      'done Tasks',
      'archived tasks',
   ];
   void changeIndex(int index){
      current_index = index ;
      emit(AppChangeBottomNavBarState());
   }

   late Database database;
   void create_database()  {
       openDatabase(
         'todo.db',
         version: 1,
         onCreate: (database, version) {
            print('created');
            database.execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT ,time TEXT ,status TEXT)'
            ).then((value) {
               print('table_created');
            }).catchError((error) {
               print('Error when created table ${error.toString()}');
            });
         },
         onOpen: (database) {
            getDataFromDatabase(database);

            print("opened database");
         },
      ).then((value) {
         database=value;
         emit(AppCreateDataBaseState());
       });
   }


    insertintodatabase({
      required String title,
      required String time,
      required String date
   }) async {
       await database.transaction((txn) async {
         txn.rawInsert(
             'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
             .then((value) {
            print('$value inserted succsfully');
            emit(AppInsertIntoDataBaseState());
            getDataFromDatabase(database);
         }).catchError((error) {
            print('Error when insert into table ${error.toString()}');
         });
      });
   }


   void getDataFromDatabase(database)  {
     newTasks=[];
     doneTasks=[];
     archivedTasks=[];
     emit(AppGetDataBaseloadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) {

       value.forEach((element) {
         if(element['status']== 'new'){
           newTasks.add(element);
         }else if(element['status']=='done'){
           doneTasks.add(element);
         }else{
           archivedTasks.add(element);
         }

       });
       emit(AppGetFromDataBaseState());
     });
   }

   var isbottomsheetshown = false;
   IconData fabicon = Icons.edit;

   void changeBottomSheetState({required bool isShow ,required IconData icon}){
      isbottomsheetshown = isShow;
      fabicon = icon;

      emit(AppChangeBottomsheetState());
   }

   void updateData({
     required String status,
     required int id,
   })async {
     database.rawUpdate('UPDATE tasks SET status = ? WHERE id=?',
         ['$status', id]).then((value) {
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());
     });
   }

     void deleteData({

       required int id,
     })async {
       database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
         getDataFromDatabase(database);
         emit(AppDeleteDatabaseState());
       });
     }
}

