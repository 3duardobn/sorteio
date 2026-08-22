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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roleta/l10n/app_localizations.dart';

import 'data/app_preferences.dart';
import 'data/caixa_repository.dart';
import 'data/settings_repository.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

const _larguraMaximaWeb = 600.0;
const _margemLateralWeb = 16.0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RoletaApp(
    repository: CaixaRepository(),
    settings: AppPreferences(SettingsRepository()),
  ));
}

class RoletaApp extends StatefulWidget {
  const RoletaApp({
    super.key,
    required this.repository,
    required this.settings,
  });

  final CaixaRepository repository;
  final AppPreferences settings;

  @override
  State<RoletaApp> createState() => _RoletaAppState();
}

class _RoletaAppState extends State<RoletaApp> {
  @override
  void initState() {
    super.initState();
    widget.settings.carregar();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settings,
      builder: (context, _) => MaterialApp(
        title: 'Roleta',
        debugShowCheckedModeBanner: false,
        theme: buildLightTheme(),
        darkTheme: buildDarkTheme(),
        themeMode: widget.settings.themeMode,
        locale: widget.settings.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) {
          if (!kIsWeb || child == null) return child!;
          return ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _margemLateralWeb),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: _larguraMaximaWeb,
                  ),
                  child: child,
                ),
              ),
            ),
          );
        },
        home: HomeScreen(
          repository: widget.repository,
          settings: widget.settings,
        ),
      ),
    );
  }
}
