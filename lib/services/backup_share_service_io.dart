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
import 'dart:io';

import 'package:share_plus/share_plus.dart';

Future<void> compartilharBackup(String json, String assunto) async {
  final dir = Directory.systemTemp;
  final arquivo = File('${dir.path}/sorteio_backup.json');
  await arquivo.writeAsString(json);
  await SharePlus.instance.share(
    ShareParams(files: [XFile(arquivo.path)], subject: assunto),
  );
}
