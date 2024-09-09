
import 'package:iot_app/api/apirepo.dart';

class SensorsRepo {
  static Future<dynamic> getSettingsById(int id)async{
    final response = await ApiRepository.get(path: '/sensors/${id}/setting');
    return response;
  }
  static Future<dynamic> updateSettingsById(int id, dynamic options)async{
    final response = await ApiRepository.put(path: 'sensors/${id}/setting', options:options );
    return response;
  }
  static Future<dynamic> getSensors()async{
    final response = await ApiRepository.get(path: '/sensors');
    return response;
  }

}