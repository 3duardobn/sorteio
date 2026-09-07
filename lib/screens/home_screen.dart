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
import 'package:sorteio/data/app_preferences.dart';
import 'package:sorteio/data/caixa_repository.dart';
import 'package:sorteio/l10n/app_localizations.dart';
import 'package:sorteio/models/caixa.dart';
import 'package:sorteio/screens/caixa_form_screen.dart';
import 'package:sorteio/screens/estatisticas_screen.dart';
import 'package:sorteio/screens/sorteio_screen.dart';
import 'package:sorteio/screens/settings_screen.dart';
import 'package:sorteio/widgets/confirm_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.repository,
    required this.settings,
  });

  final CaixaRepository repository;
  final AppPreferences settings;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Caixa>? _caixas;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final caixas = await widget.repository.carregarTodas();
    if (mounted) setState(() => _caixas = caixas);
  }

  Future<void> _abrirForm([Caixa? caixa]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CaixaFormScreen(repository: widget.repository, caixa: caixa),
      ),
    );
    _carregar();
  }

  Future<void> _abrirConfiguracoes() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          settings: widget.settings,
          repository: widget.repository,
        ),
      ),
    );
  }

  Future<void> _abrirEstatisticas(Caixa caixa) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EstatisticasScreen(caixa: caixa),
      ),
    );
  }

  Future<void> _excluir(Caixa caixa) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmar = await confirmarAcao(
      context,
      title: l10n.deleteDrawTitle,
      message: l10n.deleteDrawMessage(caixa.nome),
      confirmLabel: l10n.delete,
    );
    if (!confirmar || !mounted) return;

    final caixas = List<Caixa>.of(_caixas ?? [])
      ..removeWhere((c) => c.id == caixa.id);
    await widget.repository.salvarTodas(caixas);
    setState(() => _caixas = caixas);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            onPressed: _abrirConfiguracoes,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirForm(),
        icon: const Icon(Icons.add),
        label: Text(l10n.newDraw),
      ),
      body: Column(
        children: [
          ListenableBuilder(
            listenable: widget.settings,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.themeSystem),
                    icon: const Icon(Icons.brightness_auto),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeLight),
                    icon: const Icon(Icons.light_mode),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeDark),
                    icon: const Icon(Icons.dark_mode),
                  ),
                ],
                selected: {widget.settings.themeMode},
                onSelectionChanged: (selection) {
                  widget.settings.setThemeMode(selection.first);
                },
              ),
            ),
          ),
          Expanded(child: _corpo(l10n)),
        ],
      ),
    );
  }

  Widget _corpo(AppLocalizations l10n) {
    final caixas = _caixas;
    if (caixas == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (caixas.isEmpty) {
      return Center(
        child: Text(
          l10n.emptyState,
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      itemCount: caixas.length,
      itemBuilder: (context, i) {
        final caixa = caixas[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(caixa.nome),
            subtitle: Text(l10n.wordCount(caixa.palavras.length)),
            trailing: PopupMenuButton<String>(
              onSelected: (acao) {
                switch (acao) {
                  case 'editar':
                    _abrirForm(caixa);
                  case 'excluir':
                    _excluir(caixa);
                  case 'estatisticas':
                    _abrirEstatisticas(caixa);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'editar', child: Text(l10n.edit)),
                PopupMenuItem(value: 'estatisticas', child: Text(l10n.statsTitle)),
                PopupMenuItem(value: 'excluir', child: Text(l10n.delete)),
              ],
            ),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SorteioScreen(
                    caixa: caixa,
                    repository: widget.repository,
                  ),
                ),
              );
              _carregar();
            },
          ),
        );
      },
    );
  }
}