CREATE TABLE logs_sistema (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id          BIGINT UNSIGNED NULL,
    nivel               ENUM('INFO', 'WARNING', 'ERROR', 'CRITICAL', 'AUDIT') DEFAULT 'INFO',
    categoria           VARCHAR(50) NOT NULL,
    acao                VARCHAR(100) NOT NULL,
    tabela_afetada      VARCHAR(64) NULL,
    registro_id         BIGINT UNSIGNED NULL,
    valor_antigo        JSON NULL,
    valor_novo          JSON NULL,
    ip_origem           VARCHAR(45) NULL,
    user_agent          TEXT NULL,
    criado_em           DATETIME DEFAULT CURRENT_TIMESTAMP,

    -- Índices para performance
    INDEX idx_logs_usuario (usuario_id),
    INDEX idx_logs_categoria_acao (categoria, acao),
    INDEX idx_logs_tabela_registro (tabela_afetada, registro_id),
    INDEX idx_logs_data (criado_em),

    -- Chave estrangeira para manter integridade com a tabela de usuários
    CONSTRAINT fk_logs_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
