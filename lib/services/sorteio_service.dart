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

class SorteioService {
  const SorteioService();

  /// Sorteia uma palavra de [palavras] usando [random].
  ///
  /// Lança [SorteioException] quando a lista está vazia.
  String sortear(List<String> palavras, [Random? random]) {
    final rng = random ?? Random();
    if (palavras.isEmpty) {
      throw SorteioException('Nenhuma palavra para sortear.');
    }
    return palavras[rng.nextInt(palavras.length)];
  }

  /// Sorteia o índice de uma palavra de [palavras] usando [random].
  ///
  /// Lança [SorteioException] quando a lista está vazia.
  int sortearIndice(List<String> palavras, [Random? random]) {
    final rng = random ?? Random();
    if (palavras.isEmpty) {
      throw SorteioException('Nenhuma palavra para sortear.');
    }
    return rng.nextInt(palavras.length);
  }
}

class SorteioException implements Exception {
  const SorteioException(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}
