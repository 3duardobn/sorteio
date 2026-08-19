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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _themeKey = 'tema';
  static const _languageKey = 'idioma';
  static const _systemDefault = 'system';

  Future<ThemeMode> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeKey) ?? 0;
    final clamped = index.clamp(0, ThemeMode.values.length - 1);
    return ThemeMode.values[clamped];
  }

  Future<void> salvarTema(ThemeMode tema) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, tema.index);
  }

  /// Retorna `null` quando o idioma segue o padrão do sistema.
  Future<Locale?> carregarIdioma() async {
    final prefs = await SharedPreferences.getInstance();
    final codigo = prefs.getString(_languageKey);
    if (codigo == null || codigo == _systemDefault) return null;
    return Locale(codigo);
  }

  Future<void> salvarIdioma(Locale? idioma) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, idioma?.languageCode ?? _systemDefault);
  }
}
