# Script SQL - Gerenciamento de Estoque

## Descrição do Script
O script SQL fornecido é utilizado para criar um banco de dados de gerenciamento de estoque com tabelas para produtos, transações de entrada e transações de saída. Também inclui uma stored procedure para inserir transações de forma dinâmica.

## Estrutura do Banco de Dados
- **Database**: QueryDinamica
  - **Tabelas**:
    - **Produto**: Armazena informações dos produtos.
    - **Entrada**: Registra transações de entrada de produtos.
    - **Saida**: Registra transações de saída de produtos.
  - **Stored Procedure**:
    - **sp_inserir_transacao**: Responsável por inserir transações de forma dinâmica.

## Funcionalidades
- **Produto**: Armazena informações como código, nome e valor dos produtos.
- **Entrada**: Registra transações de entrada, incluindo código da transação, código do produto, quantidade e valor total.
- **Saida**: Registra transações de saída, com campos semelhantes à tabela de entrada.
- **Stored Procedure sp_inserir_transacao**: Permite inserir transações de entrada ou saída de forma dinâmica, calculando o valor total com base na quantidade e valor do produto.

## Testes
O script inclui testes para inserção de transações válidas e inválidas na stored procedure `sp_inserir_transacao`, demonstrando o funcionamento do sistema.

## Observações
- Certifique-se de executar o script em um ambiente compatível com SQL Server.
- É recomendável ajustar o script conforme as necessidades do sistema, como adicionar mais campos às tabelas ou modificar a lógica da stored procedure.

