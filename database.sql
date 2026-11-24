-- FinTech Flow | PostgreSQL
-- Execute no banco fintech_flow pelo pgAdmin / Query Tool.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP TABLE IF EXISTS transacoes CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  senha_hash TEXT NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE transacoes (
  id SERIAL PRIMARY KEY,
  descricao VARCHAR(180) NOT NULL,
  categoria VARCHAR(80) NOT NULL,
  tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('entrada', 'saida')),
  valor NUMERIC(14,2) NOT NULL CHECK (valor > 0),
  data_transacao DATE NOT NULL DEFAULT CURRENT_DATE,
  observacao TEXT,
  criado_por INTEGER NOT NULL REFERENCES usuarios(id),
  criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  atualizado_por INTEGER REFERENCES usuarios(id),
  atualizado_em TIMESTAMPTZ,
  excluido BOOLEAN NOT NULL DEFAULT FALSE,
  excluido_por INTEGER REFERENCES usuarios(id),
  excluido_em TIMESTAMPTZ
);

CREATE INDEX idx_transacoes_data ON transacoes(data_transacao DESC);
CREATE INDEX idx_transacoes_ativas ON transacoes(excluido) WHERE excluido = FALSE;

-- O pgcrypto gera hash bcrypt para a senha inicial Admin@123
INSERT INTO usuarios (nome, email, senha_hash) VALUES
('Administrador', 'admin@fintechflow.com', crypt('Admin@123', gen_salt('bf', 10))),
('Ana Souza', 'ana@fintechflow.com', crypt('Admin@123', gen_salt('bf', 10))),
('Bruno Lima', 'bruno@fintechflow.com', crypt('Admin@123', gen_salt('bf', 10)));

INSERT INTO transacoes
(descricao, categoria, tipo, valor, data_transacao, observacao, criado_por)
VALUES
('Capital inicial', 'Investimento', 'entrada', 12000.00, CURRENT_DATE - 12, 'Aporte inicial da empresa', 1),
('Pagamento de aluguel', 'Moradia', 'saida', 2000.00, CURRENT_DATE - 8, 'Aluguel do escritório', 1),
('Venda de serviço', 'Serviços', 'entrada', 3500.00, CURRENT_DATE - 2, 'Recebimento de cliente', 2);
