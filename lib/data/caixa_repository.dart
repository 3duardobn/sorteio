// Roleta
// Copyright (C) 2026 Eduardo Barroso Nunes
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
// SPDX-License-Identifier: GPL-3.0-only
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/caixa.dart';

class CaixaRepository {
  static const _storageKey = 'caixas';

  Future<List<Caixa>> carregarTodas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final lista = jsonDecode(raw) as List<dynamic>;
      return lista
          .map((e) => Caixa.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> salvarTodas(List<Caixa> caixas) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(caixas.map((c) => c.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  /// Atualiza uma caixa específica, criando-a caso ainda não exista.
  Future<void> salvarCaixa(Caixa caixa) async {
    final todas = await carregarTodas();
    final i = todas.indexWhere((c) => c.id == caixa.id);
    if (i >= 0) {
      todas[i] = caixa;
    } else {
      todas.add(caixa);
    }
    await salvarTodas(todas);
  }
}
