# Project Information

[README](../README.md) · [Projeto lógico](../projeto_logico.md) · [Diagrama conceitual](../diagrama_atual.drawio) · [Dúvidas de modelagem](duvidas.md) · [Histórico de alterações](historico.md)

<aside>
💡

O projeto com o tema de **saúde** deve cumprir todo o checklist abaixo para obter nota máxima, conforme relatado no https://drive.google.com/drive/folders/1b4FXtHsR1L4dZYGHkzxfXQ9sav99PiK0.

</aside>

## 🗺️ 00 - Checklist do Minimundo e Projeto Conceitual

> 🎯 **Objetivo:** Para que os projetos alcancem a nota máxima (10 - dez), esses devem ter os seguintes conceitos, os quais podem ser combinados em uma única construção.
> 

**Atributos**

- [x]  🧩 Atributo composto
- [x]  📚 Atributo multivalorado
- [x]  🔑 Atributo discriminador em relacionamento

**Relacionamentos**

- [x]  🔗 Relacionamento 1:1
- [x]  🔀 Relacionamento 1:N
- [x]  🔄 Relacionamento N:M
- [x]  🌓 Relacionamento parcial-total
- [x]  🌗 Relacionamento parcial-parcial
- [x]  🔁 Relacionamento Unário ou Auto Relacionamento
- [x]  🛡️ Relacionamento Identificador ou Entidade Fraca
- [x]  👫 Relacionamento Binário
- [x]  🕸️ Relacionamento N-ário

**Entidades e Herança**

- [x]  🤝 Entidade Associativa
- [x]  🧬 Herança (qualquer tipo)

> ⚠️ **Atenção - Regras do Modelo:**
> 
> - 🎯 **Foco:** Não se preocupe em cobrir todo o domínio do problema. O objetivo é exercitar os conceitos aprendidos e não resolver um problema real.
> - 📊 **Quantidade:** Especifique poucos atributos por entidade.
> - 📌 **Tipos de Dados Obrigatórios:**
>     - [x]  🔢 Numérico (ex: salário, quantidade, valor...)
>     - [x]  📅 Data (ex: dt_nascimento, dt_abertura, dt_realização...)
>     - [x]  📝 Texto (ex: nome, descrição, CPF...)

## 💻 00 - Checklist dos Tipos de Consultas SQL

> 🔎 **Objetivo:** Seu projeto geral da equipe deve ter *todos* os tipos de consultas abaixo.
> 

**Consultas Obrigatórias no Projeto**

- [ ]  🗂️ Group by / Having
- [ ]  🔗 Junção interna
- [ ]  🌐 Junção externa
- [ ]  🌗 Semi junção
- [ ]  🚫 Anti-junção
- [ ]  🔢 Subconsulta do tipo escalar
- [ ]  ➖ Subconsulta do tipo linha
- [ ]  🔲 Subconsulta do tipo tabela
- [ ]  ➕ Operação de conjunto

> ⚠️ **Atenção - Requisito Individual (Por Aluno):**
> 
> 
> Cada membro da equipe deve fazer:
> 
> - [ ]  🧑‍💻 Ao menos **01** das consultas listadas acima
> 
> **E mais 01** das opções abaixo:
> 
> - [ ]  ⚙️ Procedimento com SQL embutida e parâmetro
> - [ ]  🛠️ Função com SQL embutida e parâmetro
> - [ ]  ⚡ Gatilho
