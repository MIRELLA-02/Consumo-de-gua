import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'consumo_agua.dart';

class GerenciarConsumo {
  static const String chave = 'consumos_agua';

  Future<List<ConsumoAgua>> listar() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString(chave);

    if (dados == null) {
      return [];
    }

    final List lista = jsonDecode(dados);

    return lista.map((item) => ConsumoAgua.fromMap(item)).toList();
  }

  Future<void> salvar(List<ConsumoAgua> consumos) async {
    final prefs = await SharedPreferences.getInstance();

    final lista = consumos.map((consumo) => consumo.toMap()).toList();

    await prefs.setString(chave, jsonEncode(lista));
  }
}
