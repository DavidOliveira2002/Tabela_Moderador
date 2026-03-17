CREATE TABLE areas_atuacao (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    slug            VARCHAR(50) NOT NULL UNIQUE,
    nome            VARCHAR(100) NOT NULL,
    descricao       TEXT,
    ativo           BOOLEAN DEFAULT TRUE,
    criado_em       DATETIME DEFAULT CURRENT_TIMESTAMP,
    atualizado_em   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Exemplos iniciais de áreas de atuação
INSERT INTO areas_atuacao (slug, nome, descricao) VALUES
('games',          'Games e eSports',          'Conteúdo relacionado a jogos, streamers, torneios e cultura gamer'),
('tecnologia',     'Tecnologia e Ciência',     'Notícias, reviews, tutoriais e discussões sobre tech, gadgets, programação'),
('esportes',       'Esportes',                  'Futebol, vôlei, UFC, F1, NBA e demais modalidades esportivas'),
('humor',          'Humor e Memes',             'Memes, piadas, vídeos engraçados e conteúdo leve'),
('noticias',       'Notícias e Atualidades',    'Política, economia, internacional, Brasil e mundo'),
('musica',         'Música',                    'Discussões sobre artistas, lançamentos, gêneros musicais'),
('relacionamentos','Relacionamentos e Comportamento', 'Namoro, amizade, família, comportamento humano'),
('offtopic',       'Off-topic / Aleatório',     'Conversas livres, assuntos gerais sem categoria fixa');


-- 2. Tabela de usuários (necessária para banimentos)
CREATE TABLE usuarios (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username        VARCHAR(40) NOT NULL UNIQUE,
    email           VARCHAR(255),
    nome_exibicao   VARCHAR(100),
    ativo           BOOLEAN DEFAULT TRUE,
    banido          BOOLEAN DEFAULT FALSE,
    data_banimento  DATETIME NULL,
    motivo_ban      TEXT NULL,
    moderador_id    BIGINT UNSIGNED NULL,          -- quem baniu
    criado_em       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (moderador_id) REFERENCES usuarios(id)
);


-- 3. Tabela de conteúdos (posts, comentários, etc.)
CREATE TABLE conteudos (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tipo            ENUM('post', 'comentario', 'mensagem', 'foto', 'video') NOT NULL,
    usuario_id      BIGINT UNSIGNED NOT NULL,
    area_atuacao_id INT NULL,                        -- pode ser NULL em alguns casos
    conteudo        TEXT NOT NULL,
    visivel         BOOLEAN DEFAULT TRUE,
    removido        BOOLEAN DEFAULT FALSE,
    data_remocao    DATETIME NULL,
    moderador_id    BIGINT UNSIGNED NULL,           -- quem removeu
    motivo_remocao  TEXT NULL,
    criado_em       DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_usuario (usuario_id),
    INDEX idx_area (area_atuacao_id),
    INDEX idx_visivel_removido (visivel, removido),
    
    FOREIGN KEY (usuario_id)      REFERENCES usuarios(id),
    FOREIGN KEY (area_atuacao_id) REFERENCES areas_atuacao(id),
    FOREIGN KEY (moderador_id)    REFERENCES usuarios(id)
);


-- 4. Registro de ações de moderação (log)
CREATE TABLE moderacao_logs (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    moderador_id    BIGINT UNSIGNED NOT NULL,
    tipo_acao       ENUM(
        'banir_usuario',
        'desbanir_usuario',
        'remover_conteudo',
        'restaurar_conteudo',
        'ocultar_conteudo',
        'alterar_area',
        'aviso'
    ) NOT NULL,
    
    usuario_id      BIGINT UNSIGNED NULL,           -- afetado (quando ban ou aviso)
    conteudo_id     BIGINT UNSIGNED NULL,           -- quando remove conteúdo
    area_atuacao_id INT NULL,
    
    motivo          TEXT NOT NULL,
    detalhes        JSON NULL,                      -- informações extras (ex: prints, links)
    ip_moderador    VARCHAR(45) NULL,
    criado_em       DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (moderador_id)    REFERENCES usuarios(id),
    FOREIGN KEY (usuario_id)      REFERENCES usuarios(id),
    FOREIGN KEY (conteudo_id)     REFERENCES conteudos(id),
    FOREIGN KEY (area_atuacao_id) REFERENCES areas_atuacao(id)
);


-- 5. Funções de exemplo (stored procedures) - apenas ilustrativas

DELIMITER //

CREATE PROCEDURE moderar_chat(
    IN p_moderador_id BIGINT UNSIGNED,
    IN p_conteudo_id  BIGINT UNSIGNED,
    IN p_motivo       TEXT
)
BEGIN
    UPDATE conteudos
       SET visivel = FALSE,
           removido = TRUE,
           data_remocao = NOW(),
           moderador_id = p_moderador_id,
           motivo_remocao = p_motivo
     WHERE id = p_conteudo_id
       AND removido = FALSE;

    INSERT INTO moderacao_logs
    (moderador_id, tipo_acao, conteudo_id, motivo)
    VALUES
    (p_moderador_id, 'remover_conteudo', p_conteudo_id, p_motivo);
END //

CREATE PROCEDURE banir_usuario(
    IN p_moderador_id BIGINT UNSIGNED,
    IN p_usuario_id   BIGINT UNSIGNED,
    IN p_motivo       TEXT,
    IN p_duracao_dias INT          -- NULL = permanente
)
BEGIN
    DECLARE v_data_fim DATETIME;

    IF p_duracao_dias IS NULL THEN
        SET v_data_fim = NULL;
    ELSE
        SET v_data_fim = DATE_ADD(NOW(), INTERVAL p_duracao_dias DAY);
    END IF;

    UPDATE usuarios
       SET banido = TRUE,
           data_banimento = NOW(),
           moderador_id = p_moderador_id,
           motivo_ban = p_motivo
     WHERE id = p_usuario_id;

    INSERT INTO moderacao_logs
    (moderador_id, tipo_acao, usuario_id, motivo, detalhes)
    VALUES
    (p_moderador_id, 'banir_usuario', p_usuario_id, p_motivo,
     JSON_OBJECT('duracao_dias', p_duracao_dias, 'data_fim_prevista', v_data_fim));
END //

DELIMITER ;
