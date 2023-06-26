import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/modules/todo_app/archive_tasks/archive_tasks_Screen.dart';
import 'package:project1/modules/todo_app/done_tasks/done_tasks_Screen.dart';
import 'package:project1/modules/todo_app/new_tasks/new_tasks_Screen.dart';
import 'package:project1/shared/cubit/states.dart';
import 'package:project1/shared/network/local/cashe_helper.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarStates());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase() {
    openDatabase(
      'Todo.db',
      version: 1,
      onCreate: (database, version)
      {
        print('database created');
        database
            .execute(
                'CREATE TABLE TASKS (id INTEGER NOT NULL PRIMARY KEY, title TEXT,date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when Creating table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('dataBase opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

   insertToDatabase({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async
  {
    await database.transaction((txn) async {
      await txn.rawInsert(
              'INSERT INTO TASKS (title,date,time,status) VALUES("$title","$date","$time","new")'
      ).then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when Creating new Record ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element)
      {
        if(element['status'] == 'new') {
          newTasks.add(element);
        } else if(element['status'] == 'done') {
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updataData({
    required String status,
    required int id,
})async
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
})async
  {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?', [id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomsheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  })
  {
    isBottomsheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetStates());
  }

  bool isDark =false;
  void changeAppMode({bool ? fromShared})
  {
    if(fromShared != null){
      isDark = fromShared;
      emit(AppChangeModeStates());
    }else{
      isDark = !isDark;
      CasheHelper.putBoolean(key: 'isDark', value: isDark).then((value)
      {
        emit(AppChangeModeStates());
      });
    }
}
}
