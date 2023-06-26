import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/modules/news_app/webview/webview_Screen.dart';
import 'package:project1/shared/cubit/cubit.dart';
import 'package:project1/shared/styles/icon_broken.dart';

import '../../layout/shop_app/cubit/cubit.dart';
import '../../models/shop_app/home_model.dart';
import '../styles/colors.dart';

class DefaultButton extends StatelessWidget
{
  DefaultButton({
    super.key,
    this.width = double.infinity,
    required this.function,
    required this.text,
    this.background = Colors.blue,
    this.radius = 5,
  });

  double width;
  double? radius;
  Color background;
  VoidCallback function;
  String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius!,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text!.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class DefaultFormField extends StatelessWidget {
  DefaultFormField({
    Key? key,
    this.onSubmit,
    this.isClickable = true,
    required this.controller,
    required this.type,
    required this.validate,
    required this.label,
    this.onChange,
    required this.prefix,
    this.isPassword = false,
    this.suffix,
    this.suffixPressed,
    this.onTap,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType type;
  final dynamic onSubmit;
  final Function(String?)? onChange;
  final dynamic onTap;
  final dynamic validate;
  final String label;
  final IconData prefix;
  final bool isPassword;
  final IconData? suffix;
  final Function()? suffixPressed;
  final bool isClickable;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validate,
      onTap: onTap,
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
      ),
    );
  }
}

class BuildTaskItem extends StatelessWidget {
  final Map<dynamic, dynamic>? model;

  const BuildTaskItem({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //3mlt widget dy 3shan a3rf a3ml delete
    return Dismissible(
      // key dy e7na kda kda msh hn3ml beha 7aga bs dy (unique id ly widget)
      key: ValueKey(model!['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model!['time']}'),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ('${model!['title']}'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ('${model!['date']}'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updataData(
                  status: 'done',
                  id: model!['id'],
                );
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updataData(
                  status: 'archive',
                  id: model!['id'],
                );
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      //da bydeny direction aly hwa 3ml dismiss feh y3ny (ymen aw shmal) fa msh far2a m3aya 3shan 3awz a3ml delete asln
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model!['id']);
      },
    );
  }
}

class TasksBuilder extends StatelessWidget {
  List<Map> tasks;

  TasksBuilder({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (BuildContext context) => ListView.separated(
        itemBuilder: (context, index) => BuildTaskItem(model: tasks[index]),
        separatorBuilder: (context, index) => const MyDivider(),
        itemCount: tasks.length,
      ),
      fallback: (BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
        end: 10,
      ),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
    );
  }
}

class BuildArticleItem extends StatelessWidget {
  BuildArticleItem({super.key, this.article});

  dynamic article;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(context, WebViewScreen(url: article['url']));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage('${article['urlToImage']}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text('${article['title']}',
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis // fy tkmla llklam,
                          ),
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleBuilder extends StatelessWidget {
  ArticleBuilder({Key? key, required this.list, this.isSearch = false})
      : super(key: key);
  final dynamic list;
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: list.isNotEmpty,
      builder: (context) => ListView.separated(
        physics:
            const BouncingScrollPhysics(), //bykhleh ynot m3ak wnta btscroll
        itemBuilder: (context, index) => BuildArticleItem(article: list[index]),
        separatorBuilder: (context, index) => const MyDivider(),
        itemCount: 10,
      ),
      fallback: (context) => isSearch
          ? Container()
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

Widget defaultTextButton({
  required VoidCallback function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: Colors.black),
      ),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ); //dy btkhleny aro7 llsaf7a altanya mn 8eer ma a2fl aly fato

Widget defaultAppBar({
  required BuildContext context,
  String? title,
   List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          IconBroken.Arrow___Left,
        ),
      ),
      title:  Text(
        title??'',
      ),
      actions: actions,
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
      //route aly fatet 3awzha tfdl mwgoda(true) wla 3awz tl8eha (false),
    );

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      //tool msg 3aml azay(llandroid)
      gravity: ToastGravity.BOTTOM,
      //htzhar feen fy elshasha
      timeInSecForIosWeb: 5,
      //da ly ios
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

//enum da lma ykon 3ndy kaza ekhtyar mn 7aga
enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
  }
  return color;
}

Widget buildListProduct(
  model,
  context, {
  bool isOldPrice = true,
}) =>
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image.network(
                  model.image!,
                  width: 120,
                  height: 120,
                ),
                if (model.discount != 0 && isOldPrice)
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                          fontSize: 8.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price!.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (model.discount != 0 && isOldPrice)
                        Text(
                          model.oldPrice!.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavourite(model.id!);
                        },
                        icon: CircleAvatar(
                          radius: 15,
                          backgroundColor:
                              ShopCubit.get(context).favourite[model.id]!
                                  ? defaultColor
                                  : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
