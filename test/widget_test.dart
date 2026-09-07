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
import 'package:sorteio/data/caixa_repository.dart';
import 'package:sorteio/data/app_preferences.dart';
import 'package:sorteio/data/settings_repository.dart';
import 'package:sorteio/main.dart';
import 'package:sorteio/models/caixa.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.instance.platformDispatcher.localesTestValue = [
      const Locale('pt'),
    ];
  });

  Future<void> bombearApp(WidgetTester tester, CaixaRepository repo) async {
    tester.binding.platformDispatcher.localesTestValue = [const Locale('pt')];
    await tester.pumpWidget(
      SorteioApp(
        repository: repo,
        settings: AppPreferences(SettingsRepository()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('home exibe os sorteios salvos', (tester) async {
    final repo = CaixaRepository();
    await repo.salvarTodas([
      Caixa.nova(nome: 'Jantares', palavras: ['Pizza', 'Sushi']),
    ]);

    await bombearApp(tester, repo);

    expect(find.text('Jantares'), findsOneWidget);
    expect(find.text('2 palavras'), findsOneWidget);
  });

  testWidgets('home vazia mostra mensagem para criar sorteio', (tester) async {
    final repo = CaixaRepository();

    await bombearApp(tester, repo);

    expect(find.textContaining('Nenhum sorteio ainda'), findsOneWidget);
  });

  testWidgets('excluir caixa pede confirmação', (tester) async {
    final repo = CaixaRepository();
    await repo.salvarTodas([
      Caixa.nova(nome: 'Jantares', palavras: ['Pizza']),
    ]);

    await bombearApp(tester, repo);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Excluir sorteio?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Jantares'), findsNothing);
  });

  testWidgets('cancelar mantém a caixa', (tester) async {
    final repo = CaixaRepository();
    await repo.salvarTodas([
      Caixa.nova(nome: 'Jantares', palavras: ['Pizza']),
    ]);

    await bombearApp(tester, repo);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Jantares'), findsOneWidget);
  });

  testWidgets('configurações permite trocar o idioma', (tester) async {
    final repo = CaixaRepository();

    await bombearApp(tester, repo);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Configurações'), findsWidgets);
    expect(find.text('Padrão do sistema'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('System default'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('free-code'),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.textContaining('free-code'), findsOneWidget);
  });

  testWidgets('idioma escolhido é persistido e aplicado ao abrir o app',
      (tester) async {
    final repo = CaixaRepository();
    await repo.salvarTodas([
      Caixa.nova(nome: 'Jantares', palavras: ['Pizza']),
    ]);
    final settings = SettingsRepository();
    await settings.salvarIdioma(const Locale('en'));

    await tester.pumpWidget(
      SorteioApp(
        repository: repo,
        settings: AppPreferences(settings),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Draws'), findsOneWidget);
    expect(find.text('1 word'), findsOneWidget);
  });
}
