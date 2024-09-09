
import 'package:iot_app/api/apirepo.dart';

class MoistureRepo {
  static Future<dynamic> getMoistureTable(int sensorId)async{
    final response = await ApiRepository.get(path: 'moisture-data?sensor-id=${sensorId}');
    return response;
  }
  static Future<dynamic> getMoistureChart(int sensorId)async{
    final response = await ApiRepository.get(path: 'moisture-data/chart?sensor-id=${sensorId}');
    return response;
  }
}
