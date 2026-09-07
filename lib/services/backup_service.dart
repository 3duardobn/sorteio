// Sorteio
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

import '../models/caixa.dart';

/// Gera e interpreta o backup JSON das caixas.
class BackupService {
  const BackupService();

  static const _versaoAtual = 1;

  /// Serializa [caixas] em um JSON legível com metadados do backup.
  String gerarJson(List<Caixa> caixas) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert({
      'app': 'sorteio',
      'version': _versaoAtual,
      'exportadoEm': DateTime.now().toIso8601String(),
      'caixas': caixas.map((c) => c.toJson()).toList(),
    });
  }

  /// Converte [json] em uma lista de caixas.
  ///
  /// Lança [BackupException] quando o conteúdo não é um backup válido.
  List<Caixa> importar(String json) {
    final dynamic decodificado;
    try {
      decodificado = jsonDecode(json);
    } catch (_) {
      throw const BackupException('JSON inválido.');
    }
    if (decodificado is! Map<String, dynamic>) {
      throw const BackupException('Formato de backup inválido.');
    }
    final caixas = decodificado['caixas'];
    if (caixas is! List) {
      throw const BackupException('Nenhuma caixa no backup.');
    }
    return caixas
        .whereType<Map>()
        .map((c) => Caixa.fromJson(c.cast<String, dynamic>()))
        .toList();
  }
}

class BackupException implements Exception {
  const BackupException(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}