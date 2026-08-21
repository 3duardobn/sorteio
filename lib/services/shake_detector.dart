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
import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

/// Detecta o gesto de "agitar" o celular usando o acelerômetro.
///
/// O stream do acelerômetro é iniciado no primeiro listener e parado quando
/// o último é removido, de modo que chamar [onShake] mais de uma vez (ou
/// ouvir novamente depois de um erro de sensor) não cria listeners extras.
class ShakeDetector {
  ShakeDetector({
    this.threshold = 25.0,
    this.minInterval = const Duration(milliseconds: 800),
  }) {
    _controller = StreamController<void>.broadcast(
      onListen: _iniciar,
      onCancel: _parar,
    );
  }

  final double threshold;
  final Duration minInterval;

  late final StreamController<void> _controller;
  StreamSubscription<UserAccelerometerEvent>? _sub;
  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);

  /// Emite sempre que o aparelho é agitado com intensidade acima do limiar.
  Stream<void> get onShake => _controller.stream;

  void _iniciar() {
    _sub ??= userAccelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(
      (event) {
        final magnitude = sqrt(
          event.x * event.x + event.y * event.y + event.z * event.z,
        );
        final now = DateTime.now();
        if (magnitude > threshold &&
            now.difference(_lastShake) >= minInterval) {
          _lastShake = now;
          if (!_controller.isClosed) {
            _controller.add(null);
          }
        }
      },
      onError: (_) => _parar(),
    );
  }

  void _parar() {
    _sub?.cancel();
    _sub = null;
  }

  /// Encerra definitivamente o detector e libera os recursos do sensor.
  void dispose() {
    _parar();
    _controller.close();
  }
}
