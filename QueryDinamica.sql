CREATE  DATABASE QueryDinamica
GO
USE QueryDinamica
GO

-- Criar a tabela Produto 
CREATE TABLE Produto (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Valor DECIMAL(10, 2)
);
 
-- Inserir alguns produtos para testar
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1001, 'Camiseta', 29.99);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1002, 'Calça Jeans', 59.99);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1003, 'Tênis Esportivo', 99.99);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1004, 'Shorts', 39.99);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1005, 'Vestido Floral', 79.99);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1006, 'Sapato Social', 89.99);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1007, 'Blusa de Frio', 49.99);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1008, 'Moletom', 69.99);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1009, 'Boné', 19.99);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1010, 'Meia Pack 3 Unidades', 9.99);
 
-- Criar a tabela ENTRADA 
CREATE TABLE  entrada (
    Codigo_Transacao INT PRIMARY KEY,
    Codigo_Produto INT,
    Quantidade INT,
    Valor_Total DECIMAL(10, 2)
);
 
-- Criar a tabela SAIDA 
CREATE TABLE  saida (
    Codigo_Transacao INT PRIMARY KEY,
    Codigo_Produto INT,
    Quantidade INT,
    Valor_Total DECIMAL(10, 2)
);
 
-- Criar a stored procedure para inserção de transações
CREATE PROCEDURE sp_inserir_transacao (
    @tipo CHAR(1),
    @codigo_transacao INT,
    @codigo_produto INT,
    @quantidade INT,
    @saida VARCHAR(80) OUTPUT
)
AS
BEGIN
    DECLARE @tabela VARCHAR(10);
    DECLARE @mensagem VARCHAR(80);
    
    -- Verificar se o tipo de transação é válido ('e' para entrada e 's' para saída)
    IF @tipo = 'e'
    BEGIN
        SET @tabela = 'entrada';
    END
    ELSE IF @tipo = 's'
    BEGIN
        SET @tabela = 'saida';
    END
    ELSE
    BEGIN
        -- Tipo de transação inválido
        SET @mensagem = 'Tipo de transação inválido. Use ''e'' para ENTRADA ou ''s'' para SAÍDA.';
        SET @saida = @mensagem;
        RETURN; -- Encerrar a execução da procedure
    END
 
    -- Inserir na tabela correspondente
    DECLARE @valor_total DECIMAL(10, 2);
    SELECT @valor_total = Valor * @quantidade FROM Produto WHERE Codigo = @codigo_produto;
 
    DECLARE @query NVARCHAR(200);
    SET @query = 'INSERT INTO ' + @tabela + ' (Codigo_Transacao, Codigo_Produto, Quantidade, Valor_Total) VALUES (@codigo_transacao, @codigo_produto, @quantidade, @valor_total)';
    
    BEGIN TRY
        EXEC sp_executesql @query, N'@codigo_transacao INT, @codigo_produto INT, @quantidade INT, @valor_total DECIMAL(10, 2)', @codigo_transacao, @codigo_produto, @quantidade, @valor_total;
        SET @mensagem = 'Transação inserida com sucesso em ' + @tabela;
        SET @saida = @mensagem;
    END TRY
    BEGIN CATCH
        SET @mensagem = 'Erro ao inserir transação em ' + @tabela + ': ' + ERROR_MESSAGE();
        SET @saida = @mensagem;
    END CATCH;
END;
 
-- Variáveis para armazenar a saída
DECLARE @saida VARCHAR(300);
 
-- Testando inserção de transações válidas
EXEC sp_inserir_transacao 'e', 1, 1001, 5, @saida OUTPUT; -- Inserir transação de entrada
PRINT @saida; -- Exibir a mensagem de saída

DECLARE @saida VARCHAR(300);
SET @saida = NULL -- Resetar a variável de saída para o próximo teste
EXEC sp_inserir_transacao 's', 2, 1002, 3, @saida OUTPUT; -- Inserir transação de saída
PRINT @saida; -- Exibir a mensagem de saída
 
-- Exibir os dados das tabelas para verificar as inserções
SELECT * FROM Produto
SELECT * FROM ENTRADA
SELECT * FROM SAIDA


