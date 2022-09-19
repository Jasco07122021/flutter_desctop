
import 'package:logger/logger.dart';

import '../../main.dart';

class BillingApiRepository {
  Future<String?> paymentUrl(Map<String, dynamic> body) async {
    try {
      String t = "/api/v1/billing/robokassa/payment-url";
      var response = await sessionApi.generalRequestGet(
        url: t,
        queryParameters: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      }
      return null;
    } catch (e) {
      Logger().e(e.toString());
      return null;
    }
  }
}
