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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sorteio/l10n/app_localizations.dart';
import 'package:sorteio/models/caixa.dart';
import 'package:sorteio/screens/estatisticas_screen.dart';

void main() {
  testWidgets('palavra nunca sorteada mostra 0 vezes, não 1 (bug de plural pt)',
      (tester) async {
    tester.binding.platformDispatcher.localesTestValue = [const Locale('pt')];
    final caixa = Caixa.nova(nome: 'Nomes', palavras: ['A', 'B', 'C'])
      ..registrarSorteio('A');

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: EstatisticasScreen(caixa: caixa),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 sorteio no total'), findsOneWidget);
    expect(find.text('1 vez'), findsOneWidget);
    expect(find.text('0 vezes'), findsNWidgets(2));
  });
}
