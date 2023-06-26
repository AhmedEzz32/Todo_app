
import 'package:project1/modules/shop_app/login/shop_login_screen.dart';
import 'package:project1/shared/components/components.dart';
import 'package:project1/shared/network/local/cashe_helper.dart';

void signOut(context)
{
  CasheHelper.removeData(key: 'token',).then((value) {
    if(value)
    {
      navigateAndFinish(context,ShopLoginScreen());
    }
  });
}

//method dy bt print full text bdl ma y2t3o
  void printFullText(String? text)
  {
    if (text != null) {
      final pattern = RegExp('.{1,800}');
      pattern.allMatches(text).forEach((match) => print(match.group(0)));
    }
  }
  String ?token = '';

String ? uId = '';

