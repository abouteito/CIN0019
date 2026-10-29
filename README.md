# CIN0019
Projeto da Disciplina CIN0019 - BANCO DE DADOS
Repositório destinado ao armazenamento, à documentação e ao versionamento dos diagramas do projeto.

Transferi o modelo lógico do Hospital, antes em
[Modelo Lógico Hospital](https://docs.google.com/document/d/1PHL03k9P9km5vr7hvdxA0DnVYoLYkLfkzG0TutkT_5s/edit?usp=sharing) para [projeto_logico.md](projeto_logico.md).

## 📌 Objetivo

Manter os diagramas organizados e atualizados, preservando o histórico visual e editável das alterações realizadas ao longo do desenvolvimento. Cada atualização deve permitir identificar o que mudou, quando mudou e recuperar versões anteriores quando necessário.

## ✏️ Edição no VS Code

O diagrama pode ser editado visualmente no VS Code com a extensão **não oficial** [Draw.io Integration (`hediet.vscode-drawio`)](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio). Após instalar a extensão, abra `diagrama_atual.drawio` no editor do Draw.io. Se o arquivo abrir como XML, use **Reopen Editor With… / Reabrir Editor Com…** e selecione o editor Draw.io.

## 📁 Organização dos arquivos

Os arquivos devem seguir esta estrutura:

```text
CIN0019/
├── README.md
├── diagrama_atual.drawio
├── projeto_logico.md
├── docs/
│   ├── checklist.md
│   ├── duvidas.md
│   └── historico.md
└── historico/
    ├── diagramas/
    │   ├── 2026-10-28_diagrama.drawio
    │   └── ...
    ├── prints/
    │   ├── 2026-10-28_diagrama.png
    │   └── ...
    └── ...
```

- **[`diagrama_atual.drawio`](diagrama_atual.drawio)**: versão atual e editável do diagrama conceitual.
- **[`projeto_logico.md`](projeto_logico.md)**: entregável do projeto lógico, com relações, chaves e referências.
- **[`docs/checklist.md`](docs/checklist.md)**: documento de conferência dos requisitos conceituais e dos tipos de consultas SQL, usado para acompanhar o atendimento das exigências. Não substitui os entregáveis.
- **[`docs/duvidas.md`](docs/duvidas.md)**: questões de modelagem pendentes, com exemplos e alternativas para discussão da equipe. Uma proposta registrada nesse documento ainda não é uma decisão aplicada.
- **[`docs/historico.md`](docs/historico.md)**: registro das alterações realizadas, decisões de modelagem e suas justificativas.
- **`historico/diagramas/`**: versões antigas dos arquivos `.drawio`, preservadas para consulta ou restauração.
- **`historico/prints/`**: prints das versões anteriores, permitindo acompanhar visualmente as mudanças.
- **`AAAA-MM-DD_diagrama.drawio`**: versão do diagrama salva naquela data.
- **`AAAA-MM-DD_diagrama.png`**: print do diagrama após as modificações realizadas naquela data.

## 🔄 Procedimento para atualizar os diagramas

Sempre que houver uma alteração em qualquer diagrama, siga estas etapas:

1. **Modificar o diagrama:** realizar as alterações necessárias no draw.io.
2. **Preservar a versão anterior:** antes de substituir o arquivo atual, copiar a versão anterior para `historico/diagramas/`, utilizando o nome com a data correspondente àquela versão.
3. **Salvar a nova versão:** enviar o arquivo `.drawio` atualizado para a raiz do repositório, mantendo o nome `diagrama_atual.drawio`.
4. **Gerar um print:** exportar o diagrama atualizado como PNG, garantindo que as partes relevantes estejam visíveis e legíveis.
5. **Nomear o print:** utilizar o padrão `AAAA-MM-DD_diagrama.png`, substituindo a data pela data real da atualização.
6. **Preservar o histórico visual:** adicionar o novo print ao diretório `historico/prints/`, sem remover ou substituir os prints anteriores. Salvar também uma cópia da nova versão em `historico/diagramas/AAAA-MM-DD_diagrama.drawio`, com a mesma data do print. Se já existir um arquivo com esse nome, usar um sufixo para distinguir a atualização, sem sobrescrever o histórico.
7. **Registrar as mudanças:** atualizar [docs/historico.md](docs/historico.md) com a data, as modificações, suas justificativas e os links para o diagrama e o print correspondentes. Criar um commit com uma mensagem clara e objetiva, explicando as modificações realizadas.
8. **Enviar todos os arquivos:** incluir no mesmo commit o novo arquivo `.drawio`, a cópia da versão anterior, o print atualizado e quaisquer outros arquivos relacionados à alteração.

> **Importante:** nunca apague ou substitua uma versão antiga do diagrama ou um print histórico. Cada atualização deve preservar os registros anteriores e acrescentar os novos arquivos necessários.

## 🏷️ Padrão de nomenclatura

Utilize sempre o formato de data ISO 8601: `AAAA-MM-DD`.

| Arquivo | Finalidade |
|---|---|
| `diagrama_atual.drawio` | Versão atual editável |
| `projeto_logico.md` | Entregável do projeto lógico |
| `docs/checklist.md` | Conferência dos requisitos do projeto |
| `docs/duvidas.md` | Dúvidas e alternativas ainda em discussão |
| `docs/historico.md` | Registro das alterações e decisões aplicadas |
| `historico/diagramas/2026-10-19_diagrama.drawio` | Versão anterior preservada |
| `historico/prints/2026-10-19_diagrama.PNG` | Print correspondente à atualização de 19/10 |

Substitua as datas dos exemplos pela data real de cada versão.

Se houver mais de um diagrama, identifique cada um pelo nome:

```text
historico/
├── diagramas/
│   ├── 2026-10-19_modelagem-er.drawio
│   └── 2026-10-19_diagrama-classes.drawio
└── prints/
    ├── 2026-10-19_modelagem-er.png
    └── 2026-10-19_diagrama-classes.png
```

## 📝 Padrão das mensagens de commit

As mensagens dos commits devem resumir as alterações realizadas, facilitando a consulta ao histórico do projeto.

Utilize o seguinte padrão:

```text
Atualiza [nome do diagrama] — AAAA-MM-DD
```

Exemplo:

**Título:**
`Atualiza diagrama ER — 2026-10-19`

**Descrição:**

- Adicionada a entidade Pedido.
- Ajustados os relacionamentos entre Cliente e Pedido.
- Revisadas as cardinalidades dos relacionamentos.

Descreva somente as mudanças que realmente foram realizadas.

## ♻️ Como recuperar uma versão anterior

Caso seja necessário voltar a uma versão antiga:

1. Localize o arquivo desejado em `historico/diagramas/`.
2. Abra-o no draw.io para conferir se corresponde à versão desejada.
3. Copie essa versão para a raiz do repositório, utilizando novamente o nome `diagrama_atual.drawio`.
4. Gere um novo print da versão restaurada.
5. Registre a restauração em um novo commit, explicando qual versão foi recuperada e por quê.

A restauração deve ser registrada como uma nova alteração. Não apague os arquivos históricos nem os commits posteriores, pois eles documentam a evolução do projeto.

O histórico de commits do GitHub também pode ser utilizado para consultar versões anteriores dos arquivos e identificar as alterações realizadas em cada atualização.

## 📜 Histórico de versões

O histórico do projeto é preservado de quatro maneiras:

- **Arquivos `.drawio` antigos:** permitem abrir, editar e recuperar versões anteriores.
- **Prints datados:** permitem comparar visualmente a evolução dos diagramas.
- **Histórico de commits:** registra as datas, as descrições e os arquivos envolvidos em cada alteração.
- **Registro em [docs/historico.md](docs/historico.md):** explica as alterações e as decisões de modelagem de cada versão.

O arquivo `diagrama_atual.drawio` na raiz representa sempre a versão atual.

Os documentos de apoio ficam em `docs/`: consulte o [checklist](docs/checklist.md) para conferir os requisitos, registre questões ainda abertas em [dúvidas](docs/duvidas.md) e documente decisões aplicadas no [histórico](docs/historico.md). Atualize as marcações do checklist após verificar os requisitos e mantenha os links relativos ao local de cada documento.

## ✅ Checklist de atualização

Antes de concluir qualquer atualização, verifique:

- [ ] A versão anterior do `.drawio` foi preservada.
- [ ] O arquivo `.drawio` atualizado foi enviado.
- [ ] O print atualizado foi exportado e está legível.
- [ ] Os arquivos foram nomeados com a data correta.
- [ ] O novo print foi adicionado a `historico/prints/`.
- [ ] Os diagramas e prints antigos foram preservados.
- [ ] O registro da atualização foi acrescentado a [docs/historico.md](docs/historico.md).
- [ ] Os links entre o README, o projeto lógico e os documentos de `docs/` apontam para os locais corretos.
- [ ] A mensagem do commit descreve as mudanças realizadas.
- [ ] Todos os arquivos relacionados à atualização foram incluídos no commit.

---

**Regra geral:** toda alteração deve ser datada, rastreável e documentada por meio de commits descritivos, prints e versões editáveis preservadas. Nenhuma versão antiga deve ser apagada, garantindo que seja possível consultar e recuperar qualquer etapa anterior do projeto.
