import 'global.dart';

class ApiManager{

  Future<String> callApiMethod(String apiMethod, {int connectTimeoutInSec = 10, int receiveTimeoutInSec = 10, bool isPost = false, Map<String, dynamic>? queryParams, Map<String, dynamic>? data}) async {
    connectTimeoutInSec = connectTimeoutInSec * 1000;
    receiveTimeoutInSec = receiveTimeoutInSec * 1000;

    GlobalVars.dio.options.connectTimeout = Duration(seconds: connectTimeoutInSec);
    GlobalVars.dio.options.receiveTimeout = Duration(seconds: receiveTimeoutInSec);

    GlobalVars.dio.options.headers['content-type'] = 'application/json';

    dynamic resp;
    if(isPost){
      resp = await GlobalVars.dio.post('${GlobalVars.mobileApiURL}/$apiMethod', queryParameters: queryParams, data: data);
    }else{
      resp = await GlobalVars.dio.get('${GlobalVars.mobileApiURL}/$apiMethod', queryParameters: queryParams);
    }

    return resp.toString();
  }
}