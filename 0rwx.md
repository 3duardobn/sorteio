# Declaração do Padrão 0rwx — Sorteio

[![0rwx: x](https://img.shields.io/badge/0rwx-x%20%7C%20execute-critical?style=flat-square)](https://0rwx.com)

Este repositório adota o **[Framework 0rwx](https://0rwx.com/)** para fornecer transparência completa sobre o nível de envolvimento de Inteligência Artificial no seu código-fonte, arquitetura e manutenção.

---

## Classificação do Projeto: **Level x (Execute / "I curate")**

Segundo a taxonomia do [0rwx](https://0rwx.com/):

| Nível | Rótulo Unix | Filosofia | Aplicação neste Projeto |
| :---: | :---: | :--- | :--- |
| **0** | *Zero* | *"I think"* | Código 100% manual, sem modelos de IA. |
| **r** | *Read* | *"I make"* | IA atua apenas como conselheira/leitora de documentação. |
| **w** | *Write* | *"I fix"* | IA escreve partes de código com inspeção linha a linha. |
| **x** | **Execute** | **"I curate"** | **Fluxo agêntico / vibe coding autônomo, com curadoria humana e validação comportamental no produto.** |

---

## Como o desenvolvimento acontece na prática

1. **Geração Agêntica**: O projeto é construído em modelo *vibe coding* utilizando agentes de IA (OpenCode, deepseek-v4-flash, Claude, Gemini, Antigravity) para gerar código Dart/Flutter, automações e infraestrutura.
2. **Curadoria e Direção Humana**: O desenvolvedor humano guia os requisitos, a identidade do produto, a experiência de uso no dispositivo Android e a estabilidade geral.
3. **Validação Comportamental**: Todo o comportamento gerado é testado no aplicativo em execução real (testes funcionais, testes de widgets/unidade e auditoria de build).
4. **Isenção de Garantias**: O software é disponibilizado "no estado em que se encontra" (AS-IS), sob os termos da licença GNU GPLv3.

---

## Contribuições e Pull Requests

Se você deseja enviar contribuições para este projeto:
- Contribuições manuais (níveis `0` ou `r`) e co-autoradas com IA (`w` ou `x`) são bem-vindas.
- Ao abrir um Pull Request, pedimos que declare no corpo da mensagem o nível 0rwx correspondente (ex.: `0rwx: w` ou `0rwx: x`) para manter a transparência da base de código.
