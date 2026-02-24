import 'package:dio/dio.dart';
// Plus besoin d'importer 'http' ou 'json', Dio gère tout !
// API
class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000/api";
  //static const String baseUrl ="http://10.0.2.2:5000/api";
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
  }

  // --- RÉCUPÉRER LES MACHINES ---
  Future<List<dynamic>> getMachines() async {
    final response = await dio.get("/machines");
    return response.data;
  }

  // --- RÉCUPÉRER LES IDs POUR LE DROPDOWN (CSV) ---
  Future<List<String>> getAvailableMachines() async {
    try {
      // On utilise 'dio' pour rester cohérent
      final response = await dio.get("/available_machines");
      
      if (response.statusCode == 200) {
        // Avec Dio, response.data est déjà décodé en List ou Map
        List<dynamic> data = response.data;
        return data.map((e) => e.toString()).toList();
      } else {
        throw Exception('Erreur serveur');
      }
    } catch (e) {
      print("Erreur getAvailableMachines: $e");
      return []; // Retourne une liste vide en cas de crash
    }
  }

  // --- DÉTAILS D'UNE MACHINE ---
  Future<Map<String, dynamic>> getMachineDetails(String id) async {
    final response = await dio.get("/machines/$id");
    return Map<String, dynamic>.from(response.data);
  }

  // --- ARCHIVES (Historique) ---
  Future<List<dynamic>> getArchives(String date) async {
    try {
      final response = await dio.get(
        "/archive",
        queryParameters: {"date": date},
      );
      return response.data;
    } on DioException catch (e) {
      print("ERREUR ARCHIVE: ${e.response?.statusCode}");
      rethrow;
    }
  }

  // --- ALERTES ---
  Future<List<dynamic>> getAlerts() async {
    try {
      final response = await dio.get("/machines");
      final List<dynamic> allMachines = response.data;
      return allMachines.where((m) => m['status'] != "active").toList();
    } catch (e) {
      print("Erreur alertes: $e");
      return [];
    }
  }

  // --- TEST FAIL ---
  Future<void> forceFailure(String id) async {
    await dio.post("/test/force-failure/$id");
  }
}