# Sorteio

[![License: GPL-3.0](https://img.shields.io/badge/Licença-GPL--3.0-blue.svg)](LICENSE)
[![F-Droid](https://img.shields.io/f-droid/v/dev.edbn.sorteio.svg)](https://f-droid.org/packages/dev.edbn.sorteio/)
[![Flutter](https://img.shields.io/badge/Flutter-3.41+-02569B.svg)](https://flutter.dev)
[![0rwx: x](https://img.shields.io/badge/0rwx-x%20%7C%20execute-critical?style=flat-square)](https://0rwx.com)

Um aplicativo Flutter (Android) para sortear palavras. Crie "sorteios" (caixas) com nome e uma lista de palavras, edite quando quiser e sorteie uma palavra aleatória — pelo botão ou agitando o celular.

## Baixar

- **F-Droid**: [dev.edbn.sorteio](https://f-droid.org/packages/dev.edbn.sorteio/) (ou busque "Sorteio" no cliente F-Droid)
- **APK**: baixe a última tag `v*` em [Releases](https://github.com/3duardobn/sorteio/releases)

<!-- Sugestão: adicione screenshots aqui
| Sorteio | Edição | Estatísticas |
|---|---|---|
| ![sorteio](fastlane/metadata/android/pt-BR/images/icon.png) | | |
-->

## Funcionalidades

- **Múltiplos sorteios**: crie quantos quiser, cada um com nome e lista própria de palavras.
- **Persistência local**: tudo fica salvo no dispositivo (`shared_preferences`), sem necessidade de conta ou internet.
- **Editar e excluir**: adicione/remova palavras e renomeie o sorteio a qualquer momento, com confirmação antes de excluir.
- **Sorteio com efeito de flash**: as palavras alternam rapidamente (acelerando e desacelerando, ~2,3 s) até parar na palavra sorteada.
- **Botão ou gesto**: sortei pelo botão **Sortear** ou agitando o celular (acelerômetro via `sensors_plus`).
- **Tema claro/escuro**: opções Sistema / Claro / Escuro, preferência salva.
- **Idiomas**: português, inglês e espanhol, ou padrão do sistema, escolhido na tela de Configurações.
- **Estatísticas por sorteio**: veja quantas vezes cada palavra foi sorteada, na ordem das mais sorteadas.
- **Opções de sorteio**: evite repetir a última palavra sorteada e/ou remova cada palavra sorteada do sorteio (sorteio que vai diminuindo, recomeçando ao acabar).
- **Backup em JSON**: exporte seus sorteios (compartilhando ou salvando um arquivo `.json`) e restaure-os quando quiser.
- **Sem anúncios, sem rastreamento, sem coleta de dados**: os dados ficam só no dispositivo.

## Requisitos

- Flutter SDK (testado com Flutter 3.41+ / Dart 3.11+)
- Android SDK com licenças aceitas

## Como rodar

```sh
flutter pub get
flutter run
```

Para gerar o APK:

```sh
flutter build apk --debug   # debug
flutter build apk --release # release (assinado com debug key)
```

## Testes

```sh
flutter test
```

Cobre o modelo `Caixa`, o repositório de persistência, o serviço de sorteio e as telas principais (widget tests).

## Estrutura

```
lib/
  main.dart                      # entrada do app
  theme.dart                     # temas claro/escuro
  models/caixa.dart              # modelo de dados (com copyWith e igualdade)
  data/
    app_preferences.dart         # tema/idioma observáveis (ChangeNotifier)
    caixa_repository.dart        # persistência (shared_preferences)
    settings_repository.dart     # preferências persistidas
  screens/
    home_screen.dart             # lista de sorteios
    caixa_form_screen.dart       # criar/editar sorteio
    sorteio_screen.dart          # tela de sorteio
    settings_screen.dart         # configurações (idioma, backup, licença, contato)
  services/
    sorteio_service.dart         # lógica de sorteio (testável)
    shake_detector.dart          # detecção de "agitar" (sensors_plus)
    backup_service.dart          # exportar/importar JSON
  widgets/
    confirm_dialog.dart          # diálogo de confirmação reutilizável
  l10n/                          # localizações (app_en/app_pt/app_es.arb)
test/                            # testes unitários e de widget
fdroid/                          # metadado para publicação no F-Droid
fastlane/                        # descrições, changelogs e ícone da loja
```

## Publicação no F-Droid

O metadado de build vive em [`fdroid/dev.edbn.sorteio.yml`](fdroid/dev.edbn.sorteio.yml) — copie-o para o repositório [`fdroiddata`](https://gitlab.com/fdroid/fdroiddata) (em `metadata/`) e abra um Merge Request. Depois de aceito, novas tags `v*` são publicadas automaticamente.

- Versões são definidas em `pubspec.yaml` (`version: 1.0.0+1`) e builds usam tags `v1.0.0`, `v1.0.1`, ...
- Descrições, changelogs e ícone da loja ficam em [`fastlane/metadata/android/`](fastlane/metadata/android) (pt-BR, en-US e es).
- O build usa apenas o SDK do Flutter (app 100% Dart) — ver seção `Builds` do metadado.

## Transparência de IA (0rwx: x)

Este projeto segue o padrão do **[Framework 0rwx](https://0rwx.com/)** no nível **x (Execute / "I curate")**.

Este app foi *vibe-coded* com o apoio de agentes de IA (incluindo [OpenCode](https://opencode.ai), deepseek-v4-flash, Claude e Gemini). O papel humano é de curador e auditor de comportamento: definindo rumos, validando a usabilidade no Android e aprovando cada funcionalidade. Consulte [0rwx.md](0rwx.md) para detalhes da política.

## Licença

O **código** deste projeto é licenciado sob a **GNU General Public License v3.0** — veja o arquivo [LICENSE](LICENSE).

### Artes (ícones)

As **artes** em [`assets/icons/`](assets/icons) foram dedicadas ao **domínio público** sob a [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) — veja o arquivo [`assets/LICENSE-CC0.txt`](assets/LICENSE-CC0.txt). Você pode usar, modificar e redistribuir as artes livremente, sem pedir permissão e sem atribuição.