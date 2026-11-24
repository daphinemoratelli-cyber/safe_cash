# SafeCash — FinTech Flow

Sistema de tesouraria para controlar entradas e saídas, desenvolvido como atividade escolar com **Node.js, Express, React, Vite e SQLite**.

## Funcionalidades

- Dashboard responsivo com saldo, total de entradas e total de saídas.
- CRUD de transações: listar, cadastrar, editar e excluir logicamente.
- Validação no frontend e na API: descrição, tipo, categoria, data e valor positivo.
- Valores monetários guardados em centavos inteiros no SQLite para reduzir erros de arredondamento.
- Prevenção de lançamentos duplicados com os mesmos dados ativos.
- Auditoria: autor, data de criação, última alteração e histórico de ações.
- Exclusão lógica: `DELETE` preenche `deleted_at`; não apaga a linha do banco.

## Requisitos

- Node.js 20 ou superior e npm.
- VS Code (recomendado).

## Como executar no VS Code

1. Descompacte a pasta `safecash` e abra-a no VS Code (**Arquivo > Abrir Pasta**).
2. Abra o terminal integrado (**Terminal > Novo Terminal**) na pasta raiz.
3. Instale as dependências:

   ```bash
   npm install
   npm run install:all
   ```

4. Inicie backend e frontend juntos:

   ```bash
   npm run dev
   ```

5. Acesse o endereço mostrado pelo Vite, normalmente `http://localhost:5173`.
   A API fica em `http://localhost:3001/api`.

> No Windows, se a instalação de `better-sqlite3` pedir ferramentas de compilação, instale a versão LTS do Node.js e tente novamente. O arquivo `backend/safecash.sqlite` é criado automaticamente ao iniciar a API.

## Rotas da API

| Método | Rota | Descrição |
|---|---|---|
| GET | `/api/health` | Verifica se a API está ativa |
| GET | `/api/transactions` | Lista transações não excluídas |
| POST | `/api/transactions` | Cadastra uma transação |
| PUT | `/api/transactions/:id` | Edita uma transação ativa |
| DELETE | `/api/transactions/:id` | Faz exclusão lógica |
| GET | `/api/transactions/:id/audit` | Consulta o histórico de auditoria |

### Exemplo de corpo para POST/PUT

```json
{
  "description": "Pagamento de aluguel",
  "type": "saida",
  "amount": 2000.00,
  "date": "2026-11-24",
  "category": "Moradia"
}
```

`type` aceita `entrada` ou `saida`; `amount` deve ser maior que zero. A API aceita o cabeçalho opcional `X-User` para registrar quem realizou a ação (demonstração escolar; autenticação real não está incluída).

## Banco de dados e integridade

O SQLite mantém duas tabelas. `transactions` armazena os lançamentos, os campos de auditoria e `deleted_at`; `audit_log` registra cada criação, edição e exclusão. A exclusão é sempre um `UPDATE`, preservando o registro original. O valor é persistido em centavos como inteiro (`amount_cents`), evitando cálculos financeiros com casas decimais binárias.

## Justificativa da stack

JavaScript permite usar a mesma linguagem na interface (React) e no servidor (Node.js), facilitando a integração e o compartilhamento de conhecimentos pela equipe. Node.js com Express oferece uma API REST leve e organizada. React atualiza o dashboard de forma dinâmica e permite uma interface responsiva para web e celular. SQLite simplifica a execução local e oferece estrutura relacional sem exigir instalar um servidor de banco separado; em produção, o banco poderia ser migrado para PostgreSQL.

## Sugestão de cronograma de sprints

| Sprint | Entregas |
|---|---|
| 1 — Planejamento e base | Requisitos, protótipo, repositório Git, estrutura backend/frontend e banco |
| 2 — API e regras | CRUD, validações, centavos inteiros, soft delete e auditoria |
| 3 — Interface | Dashboard React responsivo, formulário e integração com API |
| 4 — Testes e entrega | Testar rotas e cenários inválidos, corrigir erros, README e apresentação |

## Testes manuais recomendados

- Cadastrar uma entrada de R$ 3.500,00 e uma saída de R$ 2.000,00: saldo esperado de R$ 1.500,00.
- Tentar cadastrar valor zero ou negativo: deve ser rejeitado.
- Repetir uma transação idêntica: a API deve responder `409`.
- Editar uma transação: saldo deve recalcular automaticamente e a auditoria deve registrar `UPDATE`.
- Excluir uma transação: ela some da lista e do saldo, mas permanece no banco com `deleted_at` e evento `SOFT_DELETE`.

## Git e colaboração

Sugestão de branches: `main` para versão estável, `develop` para integração e branches curtas como `feat/api-transacoes`, `feat/dashboard` e `fix/validacao`. Façam commits pequenos, revisem o código em pull requests e registrem as tarefas no GitHub Projects ou Trello.

## Observação acadêmica

A solução é uma base funcional para demonstração didática. Para uso financeiro real seriam necessários autenticação/autorização, testes automatizados, proteção contra CSRF conforme arquitetura, controle de acesso por usuário/empresa, backups, observabilidade, política de retenção e revisão de segurança.
