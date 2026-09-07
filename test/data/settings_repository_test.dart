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
import 'package:sorteio/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('idioma começa no padrão do sistema', () async {
    final repo = SettingsRepository();

    expect(await repo.carregarIdioma(), isNull);
  });

  test('salva e recarrega o idioma', () async {
    final repo = SettingsRepository();
    await repo.salvarIdioma(const Locale('en'));

    expect(await repo.carregarIdioma(), const Locale('en'));
  });

  test('salvar null volta ao padrão do sistema', () async {
    final repo = SettingsRepository();
    await repo.salvarIdioma(const Locale('es'));
    await repo.salvarIdioma(null);

    expect(await repo.carregarIdioma(), isNull);
  });

  test('valor "system" armazenado é tratado como padrão do sistema', () async {
    SharedPreferences.setMockInitialValues({'idioma': 'system'});
    final repo = SettingsRepository();

    expect(await repo.carregarIdioma(), isNull);
  });

  test('tema continua funcionando', () async {
    final repo = SettingsRepository();
    await repo.salvarTema(ThemeMode.dark);

    expect(await repo.carregarTema(), ThemeMode.dark);
  });
}