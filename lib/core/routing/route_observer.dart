//optional for analysis purposes 
/*import 'package:flutter/material.dart';

class MyRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // يتم استدعاؤها عند الانتقال إلى صفحة جديدة
    print('➡️ تم الانتقال إلى: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // يتم استدعاؤها عند الرجوع للخلف (إغلاق الصفحة الحالية)
    print('⬅️ تم الرجوع من: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    // يتم استدعاؤها عند استبدال صفحة بأخرى (مثل pushReplacement)
    print('🔄 تم استبدال ${oldRoute?.settings.name} بـ ${newRoute?.settings.name}');
  }
}
*/
