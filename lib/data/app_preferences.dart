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

import 'settings_repository.dart';

/// Estado observável das preferências do app (tema e idioma).
///
/// Persiste cada mudança via [SettingsRepository] e notifica os ouvintes,
/// eliminando a necessidade de repassar valores e callbacks tela a tela.
class AppPreferences extends ChangeNotifier {
  AppPreferences(this._settings);

  final SettingsRepository _settings;

  ThemeMode themeMode = ThemeMode.system;

  /// `null` significa seguir o idioma do sistema.
  Locale? locale;

  /// Carrega as preferências salvas. Falhas de leitura mantêm os padrões.
  Future<void> carregar() async {
    try {
      final tema = await _settings.carregarTema();
      final idioma = await _settings.carregarIdioma();
      themeMode = tema;
      locale = idioma;
      notifyListeners();
    } catch (_) {
      // Mantém os valores padrão.
    }
  }

  Future<void> setThemeMode(ThemeMode modo) async {
    if (themeMode == modo) return;
    themeMode = modo;
    notifyListeners();
    await _settings.salvarTema(modo);
  }

  Future<void> setLocale(Locale? idioma) async {
    if (locale == idioma) return;
    locale = idioma;
    notifyListeners();
    await _settings.salvarIdioma(idioma);
  }
}
