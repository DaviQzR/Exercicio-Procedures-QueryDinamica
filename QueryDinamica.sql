CREATE DATABASE querydinamica
GO
USE querydinamica
GO

-- Criar a tabela Produto (se ainda n�o existir)
CREATE TABLE  Produto (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Valor DECIMAL(10, 2)
);
 
-- Inserir alguns produtos para testar
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1001, 'Camiseta', 29.99);
INSERT INTO Produto (Codigo, Nome, Valor) VALUES (1002, 'Cal�a Jeans', 59.99);
 
-- Criar a tabela ENTRADA (se ainda n�o existir)
CREATE TABLE  ENTRADA (
    Codigo_Transacao INT PRIMARY KEY,
    Codigo_Produto INT,
    Quantidade INT,
    Valor_Total DECIMAL(10, 2)
);
 
-- Criar a tabela SAIDA (se ainda n�o existir)
CREATE TABLE  SAIDA (
    Codigo_Transacao INT PRIMARY KEY,
    Codigo_Produto INT,
    Quantidade INT,
    Valor_Total DECIMAL(10, 2)
);
 
-- Criar a stored procedure para inser��o de transa��es
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
    
    -- Verificar se o tipo de transa��o � v�lido ('e' para entrada e 's' para sa�da)
    IF @tipo = 'e'
    BEGIN
        SET @tabela = 'ENTRADA';
    END
    ELSE IF @tipo = 's'
    BEGIN
        SET @tabela = 'SAIDA';
    END
    ELSE
    BEGIN
        -- Tipo de transa��o inv�lido
        SET @mensagem = 'Tipo de transa��o inv�lido. Use ''e'' para ENTRADA ou ''s'' para SA�DA.';
        SET @saida = @mensagem;
        RETURN; -- Encerrar a execu��o da procedure
    END
 
    -- Inserir na tabela correspondente
    DECLARE @valor_total DECIMAL(10, 2);
    SELECT @valor_total = Valor * @quantidade FROM Produto WHERE Codigo = @codigo_produto;
 
    DECLARE @query NVARCHAR(200);
    SET @query = 'INSERT INTO ' + @tabela + ' (Codigo_Transacao, Codigo_Produto, Quantidade, Valor_Total) VALUES (@codigo_transacao, @codigo_produto, @quantidade, @valor_total)';
    
    BEGIN TRY
        EXEC sp_executesql @query, N'@codigo_transacao INT, @codigo_produto INT, @quantidade INT, @valor_total DECIMAL(10, 2)', @codigo_transacao, @codigo_produto, @quantidade, @valor_total;
        SET @mensagem = 'Transa��o inserida com sucesso em ' + @tabela;
        SET @saida = @mensagem;
    END TRY
    BEGIN CATCH
        SET @mensagem = 'Erro ao inserir transa��o em ' + @tabela + ': ' + ERROR_MESSAGE();
        SET @saida = @mensagem;
    END CATCH;
END;
 
-- Testando a stored procedure com diferentes cen�rios
 
-- Vari�veis para armazenar a sa�da
DECLARE @saida VARCHAR(300);
 
-- Testando inser��o de transa��es v�lidas
EXEC sp_inserir_transacao 'e', 1, 1001, 5, @saida OUTPUT; -- Inserir transa��o de entrada
PRINT @saida; -- Exibir a mensagem de sa�da

DECLARE @saida VARCHAR(300)
EXEC sp_inserir_transacao 's', 2, 1002, 3, @saida OUTPUT; -- Inserir transa��o de sa�da
PRINT @saida; -- Exibir a mensagem de sa�da
 
-- Exibir os dados das tabelas para verificar as inser��es
SELECT * FROM Produto;
SELECT * FROM ENTRADA;
SELECT * FROM SAIDA;