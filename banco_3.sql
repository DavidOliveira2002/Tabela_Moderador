DROP TABLE IF EXISTS dados_moderador;

CREATE TABLE dados_moderador (
    id INT PRIMARY KEY AUTO_INCREMENT,
    texto VARCHAR(255) NOT NULL
);

-- Inserção das strings extraídas da imagem
INSERT INTO dados_moderador (texto) VALUES (
    'Moderador'
);
INSERT INTO dados_moderador (texto) VALUES (
    'area_atuacao'
);
INSERT INTO dados_moderador (texto) VALUES (
    'moderar_chat()'
);
INSERT INTO dados_moderador (texto) VALUES (
    'banir_usuario()'
);
INSERT INTO dados_moderador (texto) VALUES (
    'remover_conteudo()'
);

-- Comandos de consulta para cada string
SELECT * FROM dados_moderador WHERE texto = 'Moderador';
SELECT * FROM dados_moderador WHERE texto = 'area_atuacao';
SELECT * FROM dados_moderador WHERE texto = 'moderar_chat()';
SELECT * FROM dados_moderador WHERE texto = 'banir_usuario()';
SELECT * FROM dados_moderador WHERE texto = 'remover_conteudo()';

-- Consulta de todas as strings
SELECT * FROM dados_moderador;
