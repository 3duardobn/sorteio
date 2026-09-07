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
import 'package:sorteio/l10n/app_localizations.dart';
import 'package:sorteio/models/caixa.dart';

class EstatisticasScreen extends StatelessWidget {
  const EstatisticasScreen({super.key, required this.caixa});

  final Caixa caixa;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final contagens = caixa.contagens;
    final total = caixa.palavras.fold<int>(
      0,
      (acc, palavra) => acc + (contagens[palavra] ?? 0),
    );
    final itens = caixa.palavras.map((palavra) {
      final count = contagens[palavra] ?? 0;
      return (palavra, count);
    }).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: caixa.palavras.isEmpty || total == 0
          ? Center(child: Text(l10n.statsEmpty))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.statsTotal(total),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                for (final (palavra, count) in itens)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: const Icon(Icons.policy_outlined),
                    title: Text(palavra),
                    trailing: Text(
                      l10n.statsDraws(count),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
              ],
            ),
    );
  }
}