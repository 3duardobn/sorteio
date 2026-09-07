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
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sorteio/data/caixa_repository.dart';
import 'package:sorteio/data/app_preferences.dart';
import 'package:sorteio/data/settings_repository.dart';
import 'package:sorteio/l10n/app_localizations.dart';
import 'package:sorteio/main.dart';
import 'package:sorteio/models/caixa.dart';
import 'package:sorteio/screens/sorteio_screen.dart';
import 'package:sorteio/services/shake_detector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeShakeDetector extends ShakeDetector {
  _FakeShakeDetector();

  final controller = StreamController<void>.broadcast();

  @override
  Stream<void> get onShake => controller.stream;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.instance.platformDispatcher.localesTestValue = [
      const Locale('pt'),
    ];
  });

  Future<void> sortear(WidgetTester tester) async {
    await tester.tap(find.byType(FilledButton));
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pump();
  }

  testWidgets('sorteio registra a contagem exatamente da palavra exibida',
      (tester) async {
    final repo = CaixaRepository();
    final caixa = Caixa.nova(nome: 'Nomes', palavras: ['A', 'B', 'C']);
    await repo.salvarCaixa(caixa);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SorteioScreen(
          caixa: caixa,
          repository: repo,
          shakeDetectorBuilder: _FakeShakeDetector.new,
        ),
      ),
    );

    await sortear(tester);

    final resultado = find.textContaining(RegExp(r'^(A|B|C)$')).evaluate().last;
    final palavra = (resultado.widget as Text).data!;
    expect(['A', 'B', 'C'], contains(palavra));

    final salvas = await repo.carregarTodas();
    expect(salvas.single.contagens[palavra], 1);
    expect(salvas.single.contagens.values.fold<int>(0, (a, b) => a + b), 1);
  });

  testWidgets('sorteios repetidos acumulam a contagem', (tester) async {
    final repo = CaixaRepository();
    final caixa = Caixa.nova(nome: 'Nomes', palavras: ['A', 'B', 'C']);
    await repo.salvarCaixa(caixa);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SorteioScreen(
          caixa: caixa,
          repository: repo,
          shakeDetectorBuilder: _FakeShakeDetector.new,
        ),
      ),
    );

    for (var i = 0; i < 4; i++) {
      await sortear(tester);
    }

    final salvas = await repo.carregarTodas();
    expect(salvas.single.contagens.values.fold<int>(0, (a, b) => a + b), 4);
  });

  testWidgets('fluxo completo: sorteio, voltar e abrir estatísticas',
      (tester) async {
    final repo = CaixaRepository();
    await repo.salvarCaixa(
      Caixa.nova(nome: 'Nomes', palavras: ['A', 'B', 'C']),
    );

    await tester.pumpWidget(SorteioApp(
        repository: repo,
        settings: AppPreferences(SettingsRepository()),
      ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nomes'));
    await tester.pumpAndSettle();
    expect(find.text('Sortear'), findsOneWidget);

    // A SorteioScreen real usa sensors_plus; em teste o shake é ignorado,
    // mas o botão Sortear funciona normalmente.
    await sortear(tester);

    // volta para a home
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // abre o menu e as estatísticas
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Estatísticas'));
    await tester.pumpAndSettle();

    expect(find.text('Estatísticas'), findsOneWidget);
    expect(find.text('1 sorteio no total'), findsOneWidget);
  });
}