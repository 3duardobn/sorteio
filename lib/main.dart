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
import 'package:roleta/l10n/app_localizations.dart';

import 'data/caixa_repository.dart';
import 'data/settings_repository.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RoletaApp(
    repository: CaixaRepository(),
    settings: SettingsRepository(),
  ));
}

class RoletaApp extends StatefulWidget {
  const RoletaApp({
    super.key,
    required this.repository,
    required this.settings,
  });

  final CaixaRepository repository;
  final SettingsRepository settings;

  @override
  State<RoletaApp> createState() => _RoletaAppState();
}

class _RoletaAppState extends State<RoletaApp> {
  ThemeMode _themeMode = ThemeMode.system;

  /// `null` significa seguir o idioma do sistema.
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final tema = await widget.settings.carregarTema();
    final idioma = await widget.settings.carregarIdioma();
    if (!mounted) return;
    setState(() {
      _themeMode = tema;
      _locale = idioma;
    });
  }

  Future<void> _mudarTema(ThemeMode tema) async {
    setState(() => _themeMode = tema);
    await widget.settings.salvarTema(tema);
  }

  Future<void> _mudarIdioma(Locale? idioma) async {
    setState(() => _locale = idioma);
    await widget.settings.salvarIdioma(idioma);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roleta',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: HomeScreen(
        repository: widget.repository,
        settings: widget.settings,
        themeMode: _themeMode,
        onThemeChanged: _mudarTema,
        locale: _locale,
        onLocaleChanged: _mudarIdioma,
      ),
    );
  }
}