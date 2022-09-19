
import 'package:logger/logger.dart';

import '../../main.dart';
import '../../model/network_model/server_list_model.dart';

class ServerApiRepository {
  Future<List<ServerItem>?> getServerList() async {
    try {
      String t = "/api/v1/server/";
      var response = await sessionApi.generalRequestGet(
        url: t,
        queryParameters: {},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return serverListFromJson(response.body);
      }
      return null;
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }
}
