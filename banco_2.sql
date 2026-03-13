DROP TABLE IF EXISTS strings_da_imagem;

CREATE TABLE strings_da_imagem (
    id INT PRIMARY KEY AUTO_INCREMENT,
    texto VARCHAR(255) NOT NULL
);

-- Inserção das strings extraídas da imagem
INSERT INTO strings_da_imagem (texto) VALUES (
    'Moderador'
);
INSERT INTO strings_da_imagem (texto) VALUES (
    'area_atuacao'
);
INSERT INTO strings_da_imagem (texto) VALUES (
    'moderar_chat()'
);
INSERT INTO strings_da_imagem (texto) VALUES (
    'banir_usuario()'
);
INSERT INTO strings_da_imagem (texto) VALUES (
    'remover_conteudo()'
);

-- Comandos de consulta para cada string
SELECT * FROM strings_da_imagem WHERE texto = 'Moderador';
SELECT * FROM strings_da_imagem WHERE texto = 'area_atuacao';
SELECT * FROM strings_da_imagem WHERE texto = 'moderar_chat()';
SELECT * FROM strings_da_imagem WHERE texto = 'banir_usuario()';
SELECT * FROM strings_da_imagem WHERE texto = 'remover_conteudo()';

-- Consulta de todas as strings
SELECT * FROM strings_da_imagem;
