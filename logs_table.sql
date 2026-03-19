CREATE TABLE logs (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tipo_acao           VARCHAR(100) NOT NULL, -- Descrição da ação (ex: 'usuario_criado', 'conteudo_atualizado', 'login_falho')
    usuario_id          BIGINT UNSIGNED NULL,    -- Usuário que realizou a ação (pode ser NULL para ações do sistema)
    entidade_tipo       VARCHAR(50) NULL,        -- Tipo da entidade afetada (ex: 'usuario', 'conteudo', 'area_atuacao')
    entidade_id         BIGINT UNSIGNED NULL,    -- ID da entidade afetada
    mensagem            TEXT NULL,               -- Mensagem descritiva do log
    detalhes            JSON NULL,               -- Detalhes adicionais em formato JSON (ex: {old_value: '...', new_value: '...'}, {ip: '...'})
    ip_origem           VARCHAR(45) NULL,        -- Endereço IP de origem da ação
    criado_em           DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Índices para otimização de consultas
CREATE INDEX idx_logs_tipo_acao ON logs (tipo_acao);
CREATE INDEX idx_logs_usuario_id ON logs (usuario_id);
CREATE INDEX idx_logs_entidade ON logs (entidade_tipo, entidade_id);
CREATE INDEX idx_logs_criado_em ON logs (criado_em);

-- Adicionando chaves estrangeiras (opcional, dependendo da granularidade desejada e performance)
-- FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL;
-- FOREIGN KEY (entidade_id) REFERENCES conteudos(id) ON DELETE SET NULL; -- Exemplo, pode ser mais complexo para entidades diversas
