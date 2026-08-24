# Histórico

## 2026-08-22 — Versão web publicada no GitHub Pages

Branch de trabalho: `feature/web` (merge fast-forward para `main`, tudo em `0dbef12`).

### O que foi feito

- **Plataforma web**: `flutter create --platforms web --project-name roleta .`
  - `web/index.html`: título "Roleta", `lang="pt-BR"`, meta description do app.
  - `web/manifest.json`: nome/descrição do app e cores do tema (`#6C5CE7`).
  - Ícones (`favicon.png`, `Icon-192/512`, variantes maskable) gerados a partir de
    `assets/icons/icon_roleta.png` com ImageMagick.
  - `.metadata` restaurado para manter também a entrada da plataforma android.
- **Compatibilidade web**: único bloqueio era o `dart:io` em
  `lib/screens/settings_screen.dart` (arquivo temporário ao compartilhar backup).
  Extraído para serviço com conditional import:
  - `lib/services/backup_share_service.dart` — exporta io ou web
  - `lib/services/backup_share_service_io.dart` — comportamento original (Android)
  - `lib/services/backup_share_service_web.dart` — `XFile.fromData` sem `dart:io`
  - Plugins (`shared_preferences`, `file_picker`, `share_plus`, `url_launcher`,
    `sensors_plus`) já tinham implementação web endossada — nenhuma outra mudança.
- **Layout web**: app renderiza numa coluna centralizada de 600dp de largura
  máxima com 16dp de margem lateral (nunca toca as extremidades), via
  `MaterialApp.builder` em `lib/main.dart`; laterais pintadas com
  `colorScheme.surfaceContainerHighest`. Restrição só se aplica com `kIsWeb`;
  telas, dialogs, bottom sheets e snackbars ficam dentro da coluna.
- **CI/CD**: novo `.github/workflows/deploy-web.yml` — push na `main` +
  `workflow_dispatch`; roda analyze e test antes de
  `flutter build web --release --base-href /roleta/` e publica via
  configure-pages/upload-pages-artifact/deploy-pages.

### Validação

- `flutter analyze` sem issues; 46/46 testes passando.
- Build release web OK; smoke test local servindo em `/roleta/`
  (index, `main.dart.js`, service worker e assets → HTTP 200).

### Deploy

- Primeira execução falhou por falta de permissão do token do workflow para
  criar o site do Pages (`enablement: true` não bastou). Site criado via API
  com `gh api -X POST repos/3duardobn/roleta/pages -f build_type=workflow`;
  re-run ficou verde.
- Site no ar: **https://3duardobn.github.io/roleta/**
- Deploys seguintes são automáticos a cada push na `main`.

### Observações

- Dados ficam no localStorage do navegador (por dispositivo/navegador);
  não há sincronização com o app Android nem entre navegadores.
