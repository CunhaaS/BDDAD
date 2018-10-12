--eliminar tabelas (eventualmente) existentes
DROP TABLE fornecedor           CASCADE CONSTRAINTS PURGE;
DROP TABLE produto              CASCADE CONSTRAINTS PURGE;
DROP TABLE armazem              CASCADE CONSTRAINTS PURGE;
DROP TABLE fornecedor_produto   CASCADE CONSTRAINTS PURGE;
DROP TABLE armazem_produto      CASCADE CONSTRAINTS PURGE;
DROP TABLE empregado            CASCADE CONSTRAINTS PURGE;
DROP TABLE ordem_compra         CASCADE CONSTRAINTS PURGE;
DROP TABLE ordem_compra_produto CASCADE CONSTRAINTS PURGE;

--criar tabelas
CREATE TABLE fornecedor (
    cod_fornecedor  INTEGER         CONSTRAINT pk_fornecedor_cod_fornecedor PRIMARY KEY,
    nome            VARCHAR(20)     CONSTRAINT nn_fornecedor_nome           NOT NULL,
    morada          VARCHAR(100)    CONSTRAINT nn_fornecedor_morada         NOT NULL,
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
    morada          VARCHAR(100)    CONSTRAINT nn_armazem_morada            NOT NULL,
    cidade          VARCHAR(20)     CONSTRAINT nn_armazem_cidade            NOT NULL
);

CREATE TABLE fornecedor_produto (
    cod_fornecedor  INTEGER         CONSTRAINT pk_fornecedor_produto_cod_fornecedor PRIMARY KEY,
    cod_produto     INTEGER         CONSTRAINT pk_fornecedor_produto_cod_produto    PRIMARY KEY,
    preco_venda     NUMERIC(10,2)   CONSTRAINT nn_fornecedor_produto_preco_venda    NOT NULL,
    desconto        DECIMAL(5,2)    CONSTRAINT nn_fornecedor_produto_desconto       NOT NULL
);

ALTER TABLE fornecedor_produto ADD CONSTRAINT fk_fornecedor_produto_cod_fornecedor  FOREIGN KEY (cod_fornecedor)  REFERENCES fornecedor(cod_fornecedor);
ALTER TABLE fornecedor_produto ADD CONSTRAINT fk_fornecedor_produto_cod_produto     FOREIGN KEY (cod_produto)     REFERENCES produto(cod_produto);


CREATE TABLE armazem_produto (
    cod_armazem     INTEGER         CONSTRAINT pk_armazem_produto_cod_armazem       PRIMARY KEY,
    cod_produto     INTEGER         CONSTRAINT pk_armazem_produto_cod_produto       PRIMARY KEY,
    stock           INTEGER         CONSTRAINT nn_armazem_produto_stock             NOT NULL,
    stock_minimo    INTEGER         CONSTRAINT nn_armazem_produto_stock_minimo      NOT NULL,
    corredor        INTEGER         CONSTRAINT nn_armazem_produto_corredor          NOT NULL,
    prateleira      INTEGER         CONSTRAINT nn_armazem_produto_prateleira        NOT NULL
);

ALTER TABLE armazem_produto ADD CONSTRAINT fk_armazem_produto_cod_armazem     FOREIGN KEY (cod_armazem) REFERENCES armazem(cod_armazem);
ALTER TABLE armazem_produto ADD CONSTRAINT fk_armazem_produto_cod_produto     FOREIGN KEY (cod_produto) REFERENCES produto(cod_produto);


CREATE TABLE empregado (
    cod_empregado   INTEGER         CONSTRAINT pk_empregado_cod_empregado   PRIMARY KEY,
    cod_supervisor  INTEGER         REFERENCES empregado(cod_empregado),
    cod_armazem     INTEGER         REFERENCES armazem(cod_armazem),
    nome            VARCHAR(20)     CONSTRAINT nn_empregado_nome            NOT NULL,
    morada          VARCHAR(100)    CONSTRAINT nn_empregado_morada          NOT NULL,
    salario_semanal NUMERIC(10,2)   CONSTRAINT nn_empregado_salario_semanal NOT NULL,
    formacao        VARCHAR(30) 
);

CREATE TABLE ordem_compra (
    nr_ordem        INTEGER         CONSTRAINT pk_ordem_compra_produto_nr_ordem PRIMARY KEY,
    cod_fornecedor  INTEGER         REFERENCES fornecedor(cod_fornecedor),
    cod_empregado   INTEGER         REFERENCES empregado(cod_empregado),
    data_compra     DATE            CONSTRAINT nn_ordem_compra_data_compra      NOT NULL,
    valor_total     NUMERIC(10,2)   CONSTRAINT nn_ordem_compra_valor_total      NOT NULL,
    data_entrega    DATE            CONSTRAINT nn_ordem_compra_data_entrega     NOT NULL,
    estado          INTEGER         CONSTRAINT nn_ordem_compra_estado           NOT NULL
);

CREATE TABLE ordem_compra_produto (
    nr_ordem                INTEGER         CONSTRAINT pk_ordem_compra_produto                          PRIMARY KEY,
    linha                   INTEGER         CONSTRAINT pk_ordem_compra_produto_linha                    PRIMARY KEY,
    cod_produto             INTEGER         REFERENCES produto(cod_produto),
    quantidade_solicitada   INTEGER         CONSTRAINT nn_ordem_compra_produto_quantidade_solicitada    NOT NULL,
    desconto_pedido         DECIMAL(5,2)    CONSTRAINT nn_ordem_compra_produto_desconto_pedido          NOT NULL
);

ALTER TABLE ordem_compra_produto ADD CONSTRAINT fk_ordem_compra_produto_nr_ordem    FOREIGN KEY (nr_ordem) REFERENCES ordem_compra(nr_ordem);

--fornecedores
INSERT INTO fornecedor VALUES(1,'Jose Pedro','377 Cambridge St. Muskego; WI 53150',234567982,913736142);
INSERT INTO fornecedor VALUES(2,'Maria Antonia','66 Sugar Drive Vista; CA 92083',413212343,967435421);
INSERT INTO fornecedor VALUES(3,'Paulo Jeremias','816 Penn Street Waxhaw; NC 28173',234612732,912365741);
INSERT INTO fornecedor VALUES(4,'Carla Matos','9723 Gainsway Road Carrollton; GA 30117',453198631,934126745);
INSERT INTO fornecedor VALUES(5,'Francisco Mateus','9723 Gainsway Road Carrollton; GA 30117',342124541,913276775);
INSERT INTO fornecedor VALUES(6,'Arnaldo Gomes','8486 W. Peachtree Ave. De Pere; WI 54115',283712833,931263615);


--produtos
INSERT INTO produto VALUES(1,'parafuso pequeno',20,3.50);
INSERT INTO produto VALUES(2,'parafuso médio',20,4.50);
INSERT INTO produto VALUES(3,'parafuso grande',20,6.00);
INSERT INTO produto VALUES(4,'porca',10,5.00);
INSERT INTO produto VALUES(5,'chave allen',1,7.15);
INSERT INTO produto VALUES(6,'corda plastico',1,5.32);
INSERT INTO produto VALUES(7,'corda fibra',1,8.30);
INSERT INTO produto VALUES(8,'braçadeiras',10,4.17);
INSERT INTO produto VALUES(9,'ar condicionado',1,68.79);
INSERT INTO produto VALUES(10,'tábua de madeira',5,21.35);
INSERT INTO produto VALUES(11,'frigorífico',1,455.99);
INSERT INTO produto VALUES(12,'betoneira',1,855);

--produtos dos fornecedores
INSERT INTO fornecedor_produto VALUES(1,1,0.50,30);
INSERT INTO fornecedor_produto VALUES(1,2,0.75,30);
INSERT INTO fornecedor_produto VALUES(2,3,1,30);
INSERT INTO fornecedor_produto VALUES(2,4,2,40);
INSERT INTO fornecedor_produto VALUES(3,5,2.5,10);
INSERT INTO fornecedor_produto VALUES(3,6,1.43,20);
INSERT INTO fornecedor_produto VALUES(4,7,2.9,25);
INSERT INTO fornecedor_produto VALUES(4,8,2,10);
INSERT INTO fornecedor_produto VALUES(5,9,24.32,35);
INSERT INTO fornecedor_produto VALUES(5,10,4.20,32);
INSERT INTO fornecedor_produto VALUES(6,11,120,23);
INSERT INTO fornecedor_produto VALUES(6,12,180,9);

--armazens
INSERT INTO armazem VALUES(1,'Parafusos','8070 53rd St.West Babylon; NY 11704','Aveiro');
INSERT INTO armazem VALUES(2,'Tintas','346 Lower River Street Temple Hills; MD 20748','Braga');
INSERT INTO armazem VALUES(3,'Isep','560 Bow Ridge Street Harlingen, TX 78552','Porto');

--produtos nos armazens
INSERT INTO armazem_produto VALUES(1,1,500,160,1,1);
INSERT INTO armazem_produto VALUES(1,2,750,160,1,2);
INSERT INTO armazem_produto VALUES(1,3,650,160,1,3);
INSERT INTO armazem_produto VALUES(1,4,350,100,2,1);
INSERT INTO armazem_produto VALUES(1,5,56,15,2,2);
INSERT INTO armazem_produto VALUES(2,6,78,25,1,1);
INSERT INTO armazem_produto VALUES(2,7,90,25,1,2);
INSERT INTO armazem_produto VALUES(2,8,234,100,2,1);
INSERT INTO armazem_produto VALUES(3,9,76,10,1,1);
INSERT INTO armazem_produto VALUES(3,10,240,100,1,1);
INSERT INTO armazem_produto VALUES(3,11,30,20,2,1);
INSERT INTO armazem_produto VALUES(3,12,15,5,1,2);

--empregados

INSERT INTO empregado VALUES(2,NULL,1,'Carlos Vitoria','88 NE. 10th St. Quincy, MA 02169',600,'Gestão');
INSERT INTO empregado VALUES(1,2,1,'Vitor Pereira','309 Poplar Ave. Middleburg, FL 32068',400,'Organização');
INSERT INTO empregado VALUES(3,2,1,'Guilherme Oliveira','8394 River Drive Livonia, MI 48150',298,'Marketing');
INSERT INTO empregado VALUES(6,NULL,2,'Miguel Azevedo','635 George Drive Conyers, GA 30012',790,'Redes');
INSERT INTO empregado VALUES(4,6,2,'Jose António','40 Baker Road Little Rock, AR 72209',546,'Organização');
INSERT INTO empregado VALUES(5,6,2,'Pedro Marques','800 SE. Willow Dr. Goose Creek, SC 29445',456,'Informática');
INSERT INTO empregado VALUES(8,NULL,3,'Mário Silva','127 SE. Virginia Street Roswell, GA 30075',1000,'Iluminação');
INSERT INTO empregado VALUES(7,3,3,'João Maria','524 West Randall Mill Drive Marysville, OH 43040',320,'Electricidade');
INSERT INTO empregado VALUES(9,8,3,'Filipe Silva','52 Rock Maple Circle Oak Lawn, IL 60453',597,'Gestão');

--ordens de compra
INSERT INTO ordem_compra VALUES(1,1,1,TO_TIMESTAMP('11-08-2017 10:20','dd-mm-yyyy hh24:mi'),1500,TO_TIMESTAMP('18-08-2017 18:29','dd-mm-yyyy hh24:mi'),1);
INSERT INTO ordem_compra VALUES(2,1,2,TO_TIMESTAMP('27-10-2016 13:40','dd-mm-yyyy hh24:mi'),330,TO_TIMESTAMP('30-10-2016 13:10','dd-mm-yyyy hh24:mi'),2);
INSERT INTO ordem_compra VALUES(3,2,3,TO_TIMESTAMP('14-11-2015 18:29','dd-mm-yyyy hh24:mi'),432,TO_TIMESTAMP('20-11-2015 9:20','dd-mm-yyyy hh24:mi'),2);
INSERT INTO ordem_compra VALUES(4,2,4,TO_TIMESTAMP('28-09-2018 15:32','dd-mm-yyyy hh24:mi'),900,TO_TIMESTAMP('14-10-2018 8:40','dd-mm-yyyy hh24:mi'),3);
INSERT INTO ordem_compra VALUES(5,3,5,TO_TIMESTAMP('30-03-2013 07:34','dd-mm-yyyy hh24:mi'),1302,TO_TIMESTAMP('10-04-2013 7:53','dd-mm-yyyy hh24:mi'),1);
INSERT INTO ordem_compra VALUES(6,3,6,TO_TIMESTAMP('03-08-2012 09:54','dd-mm-yyyy hh24:mi'),2000,TO_TIMESTAMP('06-08-2012 18:00','dd-mm-yyyy hh24:mi'),2);
INSERT INTO ordem_compra VALUES(7,4,7,TO_TIMESTAMP('04-12-2017 18:23','dd-mm-yyyy hh24:mi'),1567,TO_TIMESTAMP('11-12-2017 10:20','dd-mm-yyyy hh24:mi'),1);
INSERT INTO ordem_compra VALUES(8,4,8,TO_TIMESTAMP('18-07-2018 12:21','dd-mm-yyyy hh24:mi'),520,TO_TIMESTAMP('25-07-2018 19:10','dd-mm-yyyy hh24:mi'),2);
INSERT INTO ordem_compra VALUES(9,5,9,TO_TIMESTAMP('27-02-2016 20:30','dd-mm-yyyy hh24:mi'),420,TO_TIMESTAMP('04-03-2016 10:01','dd-mm-yyyy hh24:mi'),3);
INSERT INTO ordem_compra VALUES(10,5,1,TO_TIMESTAMP('09-08-2015 16:20','dd-mm-yyyy hh24:mi'),1987,TO_TIMESTAMP('17-08-2015 13:59','dd-mm-yyyy hh24:mi'),1);
INSERT INTO ordem_compra VALUES(11,6,2,TO_TIMESTAMP('23-05-2018 14:54','dd-mm-yyyy hh24:mi'),6789,TO_TIMESTAMP('30-05-2018 20:40','dd-mm-yyyy hh24:mi'),2);
INSERT INTO ordem_compra VALUES(12,6,6,TO_TIMESTAMP('13-01-2018 14:10','dd-mm-yyyy hh24:mi'),126,TO_TIMESTAMP('20-01-2018 17:30','dd-mm-yyyy hh24:mi'),1);

--ordens de compra de um produto
INSERT INTO ordem_compra_produto VALUES(1,43,1,1700,20);
INSERT INTO ordem_compra_produto VALUES(2,2,2,330,10);
INSERT INTO ordem_compra_produto VALUES(3,3,3,432,5);
INSERT INTO ordem_compra_produto VALUES(4,5,4,1100,30);
INSERT INTO ordem_compra_produto VALUES(5,14,5,1302,10);
INSERT INTO ordem_compra_produto VALUES(6,20,6,2050,13);
INSERT INTO ordem_compra_produto VALUES(7,9,7,1600,16);
INSERT INTO ordem_compra_produto VALUES(8,13,8,520,24);
INSERT INTO ordem_compra_produto VALUES(9,12,9,420,10);
INSERT INTO ordem_compra_produto VALUES(10,10,1,2000,15);
INSERT INTO ordem_compra_produto VALUES(11,8,11,7000,32);
INSERT INTO ordem_compra_produto VALUES(12,1,12,126,25);
