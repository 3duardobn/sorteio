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
import 'package:flutter_test/flutter_test.dart';
import 'package:roleta/data/caixa_repository.dart';
import 'package:roleta/models/caixa.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('começa vazio quando não há dados salvos', () async {
    final repo = CaixaRepository();

    expect(await repo.carregarTodas(), isEmpty);
  });

  test('salva e recarrega as caixas', () async {
    final repo = CaixaRepository();
    final caixas = [
      Caixa(id: '1', nome: 'Refeições', palavras: ['Pizza', 'Sushi']),
      Caixa(id: '2', nome: 'Filmes', palavras: ['Ação', 'Comédia']),
    ];

    await repo.salvarTodas(caixas);

    final carregadas = await repo.carregarTodas();
    expect(carregadas.length, 2);
    expect(carregadas[0].nome, 'Refeições');
    expect(carregadas[0].palavras, ['Pizza', 'Sushi']);
    expect(carregadas[1].nome, 'Filmes');
    expect(carregadas[1].palavras, ['Ação', 'Comédia']);
  });

  test('sobrescreve os dados anteriores ao salvar de novo', () async {
    final repo = CaixaRepository();
    await repo.salvarTodas([
      Caixa(id: '1', nome: 'A', palavras: ['x']),
    ]);
    await repo.salvarTodas([
      Caixa(id: '2', nome: 'B', palavras: ['y']),
    ]);

    final carregadas = await repo.carregarTodas();
    expect(carregadas.length, 1);
    expect(carregadas.first.nome, 'B');
  });

  test('dados corrompidos retornam lista vazia', () async {
    SharedPreferences.setMockInitialValues({'caixas': '{{não é json'});
    final repo = CaixaRepository();

    expect(await repo.carregarTodas(), isEmpty);
  });

  test('json com formato errado retorna lista vazia', () async {
    SharedPreferences.setMockInitialValues({'caixas': '[1, 2, 3]'});
    final repo = CaixaRepository();

    expect(await repo.carregarTodas(), isEmpty);
  });
}