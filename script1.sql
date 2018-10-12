--eliminar tabelas (eventualmente) existentes
DROP TABLE fornecedor           CASCADE CONSTRAINTS PURGE;
DROP TABLE produto              CASCADE CONSTRAINTS PURGE;
DROP TABLE armazem              CASCADE CONSTRAINTS PURGE;
DROP TABLE fornecedor_produto    CASCADE CONSTRAINTS PURGE;
DROP TABLE armazem_produto       CASCADE CONSTRAINTS PURGE;
DROP TABLE empregado            CASCADE CONSTRAINTS PURGE;
DROP TABLE ordem_compra          CASCADE CONSTRAINTS PURGE;
DROP TABLE ordem_compra_produto   CASCADE CONSTRAINTS PURGE;

--criar tabelas
CREATE TABLE fornecedor (
    cod_fornecedor  INTEGER         CONSTRAINT pk_fornecedor_cod_fornecedor PRIMARY KEY,
    nome            VARCHAR(20)     CONSTRAINT nn_fornecedor_nome           NOT NULL,
    morada          VARCHAR(50)     CONSTRAINT nn_fornecedor_morada         NOT NULL,
    nif             NUMERIC(9)      CONSTRAINT nn_fornecedor_nif            NOT NULL,
    telefone        NUMERIC(9)      CONSTRAINT nn_fornecedor_telefone       NOT NULL
);

CREATE TABLE produto (
    cod_produto     INTEGER         CONSTRAINT pk_produto_cod_produto       PRIMARY KEY,
    descricao       VARCHAR(100)    CONSTRAINT nn_produto_descricao         NOT NULL,
    unidade_medida  VARCHAR(20)     CONSTRAINT nn_produto_unidade_medida    NOT NULL,
    preco           NUMERIC(10,2)   CONSTRAINT nn_produto_preco             NOT NULL
);

CREATE TABLE armazem (
    cod_armazem     INTEGER         CONSTRAINT pk_armazem_cod_armazem       PRIMARY KEY,
    nome            VARCHAR(20)     CONSTRAINT nn_armazem_nome              NOT NULL,
    morada          VARCHAR(50)     CONSTRAINT nn_armazem_morada            NOT NULL,
    cidade          VARCHAR(20)     CONSTRAINT nn_armazem_cidade            NOT NULL
);

CREATE TABLE fornecedor_produto (
    cod_fornecedor  INTEGER,
    cod_produto     INTEGER,
    preco_venda     NUMERIC(10,2)   CONSTRAINT nn_fornecedorproduto_preco_venda     NOT NULL,
    desconto        DECIMAL(5,2)    CONSTRAINT nn_fornecedorproduto_desconto        NOT NULL
);

ALTER TABLE fornecedor_produto ADD CONSTRAINT fk_fornecedorproduto_cod_fornecedor  FOREIGN KEY (cod_fornecedor)  REFERENCES fornecedor(cod_fornecedor);
ALTER TABLE fornecedor_produto ADD CONSTRAINT fk_fornecedorproduto_cod_produto     FOREIGN KEY (cod_produto)     REFERENCES produto(cod_produto);


CREATE TABLE armazem_produto (
    cod_armazem     INTEGER,
    cod_produto     INTEGER,
    stock           INTEGER         CONSTRAINT nn_armazemproduto_stock          NOT NULL,
    stock_minimo    INTEGER         CONSTRAINT nn_armazemproduto_stock_minimo   NOT NULL,
    corredor        INTEGER         CONSTRAINT nn_armazemproduto_corredor       NOT NULL,
    prateleira      INTEGER         CONSTRAINT nn_armazemproduto_prateleira     NOT NULL
);

ALTER TABLE armazem_produto ADD CONSTRAINT fk_armazemproduto_cod_armazem     FOREIGN KEY (cod_armazem) REFERENCES armazem(cod_armazem);
ALTER TABLE armazem_produto ADD CONSTRAINT fk_armazemproduto_cod_produto     FOREIGN KEY (cod_produto) REFERENCES produto(cod_produto);


CREATE TABLE empregado (
    cod_empregado   INTEGER         CONSTRAINT pk_empregado_cod_empregado   PRIMARY KEY,
    cod_supervisor  INTEGER         REFERENCES empregado(cod_empregado),
    nome            VARCHAR(20)     CONSTRAINT nn_empregado_nome            NOT NULL,
    morada          VARCHAR(30)     CONSTRAINT nn_empregado_morada          NOT NULL,
    samario_semanal NUMERIC(10,2)   CONSTRAINT nn_empregado_salario_semanal NOT NULL,
    formacao        VARCHAR(30) --Nao sei se esta correto
);

CREATE TABLE ordem_compra (
    nr_ordem        INTEGER         CONSTRAINT pk_ordemcompraproduto_nr_ordem   PRIMARY KEY,
    cod_fornecedor  INTEGER         REFERENCES fornecedor(cod_fornecedor),
    cod_empregado   INTEGER         REFERENCES empregado(cod_empregado),
    data_compra     DATE            CONSTRAINT nn_ordemcompra_data_compra       NOT NULL,
    valor_total     NUMERIC(10,2)   CONSTRAINT nn_ordemcompra_valor_total       NOT NULL,
    data_entrega    DATE            CONSTRAINT nn_ordemcompra_data_entrega      NOT NULL,
    estado          INTEGER         CONSTRAINT nn_ordemcompra_estado            NOT NULL
);

CREATE TABLE ordem_compra_produto (
    nr_ordem                INTEGER,
    linha                   VARCHAR(20)     CONSTRAINT pk_ordemcompraproduto_linha                  PRIMARY KEY,
    cod_produto             INTEGER         REFERENCES produto(cod_produto),
    quantidade_solicitada   INTEGER         CONSTRAINT nn_ordemcompraproduto_quantidade_solicitada  NOT NULL,
    desconto_pedido         DECIMAL(5,2)    CONSTRAINT nn_ordemcompraproduto_desconto_pedido        NOT NULL
);

ALTER TABLE ordem_compra_produto ADD CONSTRAINT fk_ordemcompraproduto_nr_ordem    FOREIGN KEY (nr_ordem) REFERENCES ordemcompra(nr_ordem);
