
import 'package:iot_app/api/apirepo.dart';

class TemperatureRepo {
  static Future<dynamic> getTemperatureTable(int sensorId)async{
    final response = await ApiRepository.get(path: '/temperature-data?sensor-id=${sensorId}');
    return response;
  }

  static Future<dynamic> getTemperatureChart(int sensorId)async{
    final response = await ApiRepository.get(path: '/temperature-data/chart?sensor-id=${sensorId}');
    return response;
  }
}
