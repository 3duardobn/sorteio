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
import 'dart:math';

class SorteioService {
  const SorteioService();

  /// Sorteia uma palavra de [palavras] usando [random].
  ///
  /// Palavras em [excluidos] não participam do sorteio (ex.: a última
  /// sorteada ou palavras já removidas).
  ///
  /// Lança [SorteioException] quando a lista está vazia ou todas as palavras
  /// estão excluídas.
  String sortear(
    List<String> palavras, [
    Random? random,
    Set<String>? excluidos,
  ]) {
    final rng = random ?? Random();
    final disponiveis = _disponiveis(palavras, excluidos);
    if (disponiveis.isEmpty) {
      throw SorteioException('Nenhuma palavra disponível para sortear.');
    }
    return disponiveis[rng.nextInt(disponiveis.length)];
  }

  /// Retorna as palavras que podem ser sorteadas, excluindo [excluidos].
  List<String> _disponiveis(List<String> palavras, Set<String>? excluidos) {
    if (excluidos == null || excluidos.isEmpty) return palavras;
    return palavras.where((p) => !excluidos.contains(p)).toList();
  }
}

class SorteioException implements Exception {
  const SorteioException(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}
