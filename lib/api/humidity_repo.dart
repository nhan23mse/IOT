
import 'package:iot_app/api/apirepo.dart';

class HumidityRepo {
  static Future<dynamic> getHumidityTable(int sensorId)async{
    final response = await ApiRepository.get(path: 'humidity-data?sensor-id=${sensorId}');
    return response;
  }
  static Future<dynamic> getHumidityChart(int sensorId)async{
    final response = await ApiRepository.get(path: 'humidity-data/chart?sensor-id=${sensorId}');
    return response;
  }
}
