import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_desctop/core/enums.dart';
import 'package:flutter_desctop/main.dart';
import 'package:flutter_desctop/model/network_model/system_data_model.dart';
import 'package:flutter_desctop/model/network_model/user_registration_model.dart';

class SplashProvider extends ChangeNotifier {
  Future<SystemData?> checkSystemData() async {
    SystemData? systemData = await systemApi.getSystem();
    return systemData;
  }

  Future<dynamic> checkUserAuth() async {
    try {
      // final String? uid = localDB.getString("wallet_box_uid");
      // final String? token =
      //     "eyJhbGciOiJIUzUxMiJ9.eyJsb2dpbiI6ImRldmdpcGF0QGdtYWlsLmNvbSIsImlkIjoiNWYxMjEyNjctMGU5YS00YWMxLTg2YjItMDhkMTQ0OTZmNzNiIiwiZXhwIjoxNjk2ODk2MDAwfQ.g3Q28QLxIGlJQh2z5Vb0t9RVpitwEZNSk92JSTLhD58nqVKvzpkU-nu13mzjtaeiB9RATq06u-vvoPwR6dfmbA";
      final String? token = localDB.getString(LocalDBEnum.token.name);

      if (token != null) {
        UserRegister? user = await userApi.getUserMe(token);
        WindowsDeviceInfo info = await DeviceInfoPlugin().windowsInfo;
        await localDB.setString(LocalDBEnum.deviceId.name, info.computerName);
        if (user != null) {
          return user;
        }
      } else {
        WindowsDeviceInfo info = await DeviceInfoPlugin().windowsInfo;
        localDB.setString(LocalDBEnum.deviceId.name, info.computerName);
        return await userApi.postAnonymous(info.computerName);
      }
    } on dynamic catch (_) {
      rethrow;
    }
  }
}
