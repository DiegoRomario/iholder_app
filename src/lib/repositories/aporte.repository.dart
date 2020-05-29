import 'dart:convert';
import 'package:http/http.dart';
import 'package:iholder_app/models/Aporte-view-model.dart';
import 'package:iholder_app/settings.dart';
import 'package:iholder_app/http/web-client.dart';

class AporteRepository {
  // Future<String> salvar(Aporte Aporte) async {
  //   String json = jsonEncode(Aporte.toJson());
  //   Response response;

  //   if (Aporte.id == null) {
  //     response =
  //         await webClient.post("${Settings.apiUrl}Aporte/cadastrar", body: json);
  //   } else {
  //     response = await webClient
  //         .put("${Settings.apiUrl}Aporte/alterar/${Aporte.id}", body: json);
  //   }

  //   return jsonDecode(response.body)["data"];
  // }

  Future<List<AporteViewModel>> obterTodos() async {
    Response response = await webClient.get("${Settings.apiUrl}Aporte");
    var responseJson = jsonDecode(response.body);
    return (responseJson["data"] as List)
        .map((data) => AporteViewModel.fromJson(data))
        .toList();
  }
}
