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

import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/services/sorteio_service.dart';

void main() {
  const service = SorteioService();

  group('sortear', () {
    test('retorna uma palavra que existe na lista', () {
      final palavras = ['A', 'B', 'C', 'D'];

      for (var seed = 0; seed < 100; seed++) {
        final sorteada = service.sortear(palavras, Random(seed));
        expect(palavras, contains(sorteada));
      }
    });

    test('é determinístico com o mesmo random', () {
      final palavras = ['A', 'B', 'C', 'D'];

      final a = service.sortear(palavras, Random(7));
      final b = service.sortear(palavras, Random(7));

      expect(a, b);
    });

    test('lança exceção com lista vazia', () {
      expect(
        () => service.sortear(const [], Random(1)),
        throwsA(isA<SorteioException>()),
      );
    });

    test('não sorteia palavras excluídas', () {
      final palavras = ['A', 'B', 'C', 'D'];

      for (var seed = 0; seed < 100; seed++) {
        final sorteada =
            service.sortear(palavras, Random(seed), {'A', 'B'});
        expect(sorteada, isNot(anyOf('A', 'B')));
      }
    });

    test('lança exceção quando todas as palavras estão excluídas', () {
      expect(
        () => service.sortear(['A', 'B'], Random(1), {'A', 'B'}),
        throwsA(isA<SorteioException>()),
      );
    });
  });
}