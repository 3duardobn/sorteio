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
import 'dart:math';

class Caixa {
  Caixa({
    required this.id,
    required this.nome,
    required this.palavras,
  });

  final String id;
  String nome;
  List<String> palavras;

  factory Caixa.nova({required String nome, List<String> palavras = const []}) {
    return Caixa(
      id: _uuid(),
      nome: nome,
      palavras: List.of(palavras),
    );
  }

  factory Caixa.fromJson(Map<String, dynamic> json) {
    return Caixa(
      id: json['id'] as String? ?? _uuid(),
      nome: json['nome'] as String? ?? '',
      palavras: (json['palavras'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'palavras': palavras,
      };

  Caixa copia() => Caixa(id: id, nome: nome, palavras: List.of(palavras));

  static String _uuid() {
    final rng = Random.secure();
    final hex = List.generate(16, (_) => rng.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
    return '$hex-${DateTime.now().microsecondsSinceEpoch}';
  }
}
