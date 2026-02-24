import 'package:dio/dio.dart';

class ApiService {

  // url
   static const String baseUrl = "http://192.168.99.107:5000/api";
  // Remplace l'ancienne IP par la nouvelle détectée
  //static const String baseUrl = "http://192.168.0.100:5000/api";
  //static const String baseUrl = "http://10.0.2.2:5000/api";
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,

        /// ⏱ Timeouts
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),

        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
  }

  
  // Get machines
  
  Future<List<dynamic>> getMachines() async {
    final response = await dio.get("/machines");
    return response.data;
  }

  
  // Details machines
  
  Future<Map<String, dynamic>> getMachineDetails(String id) async {
    final response = await dio.get("/machines/$id");
    return Map<String, dynamic>.from(response.data);
  }

  
  // Archives (History)
  
  Future<List<dynamic>> getArchives(String date) async {
    try {
      final response = await dio.get(
        "/archive",
        queryParameters: {
          "date": date,
        },
      );

      return response.data;
   } on DioException catch (e) {
  // Affiche plus de détails sur l'erreur réseau
  print("TYPE D'ERREUR: ${e.type}");
  print("CODE REPONSE: ${e.response?.statusCode}");
  print("DONNEES ERREUR: ${e.response?.data}"); 
  rethrow;
}
  }


  // Test
  Future<void> forceFailure(String id) async {
    await dio.post("/test/force-failure/$id");
  }
}