--a)
SELECT (SELECT AVG(E.salario_semanal)
        FROM empregado) AS media_salario_semanal
,(E.salario_semanal * 60) AS Salario_Anual
FROM empregado E
WHERE E.cod_armazem = (
        SELECT A.cod_armazem
        FROM armazem A
        WHERE A.nome like 'Parafusos');

--b)
SELECT *
FROM ordem_compra
WHERE estado = 3
AND cod_fornecedor NOT IN (
    SELECT cod_fornecedor
    FROM fornecedor_produto
    WHERE desconto = (
        SELECT MAX(desconto)
        FROM fornecedor_produto
    )
);

--c)
SELECT DISTINCT A.nome
FROM  armazem_produto APA
INNER JOIN armazem A ON A.cod_armazem = APA.cod_armazem
WHERE NOT EXISTS(
                SELECT cod_produto
                 FROM armazem_produto
                 WHERE cod_armazem = (SELECT cod_armazem AS cod_armazem_empregados
                                                             FROM empregado
                                                             GROUP BY cod_armazem
                                                             HAVING COUNT(cod_empregado) = (SELECT MAX(COUNT(cod_empregado))
                                                                                                                                FROM empregado
                                                                                                                                GROUP BY cod_armazem))
MINUS
SELECT cod_produto
FROM armazem_produto APB
WHERE APA.cod_armazem = APB.cod_armazem
);

--d)

SELECT *
FROM ARMAZEM WHERE cod_armazem IN (
         SELECT cod_armazem FROM(
                            SELECT A.cod_armazem ,COUNT(*) AS NUM_VENDAS
                            FROM ORDEMCOMPRA OC, ARMAZEM A, Empregado Emp
                            WHERE OC.cod_empregado = Emp.cod_empregado
                                              AND Emp.cod_armazem = A.cod_armazem
                                              AND OC.ESTADO = 2
                            GROUP BY A.cod_armazem
                            HAVING COUNT(*) > (
                                            SELECT MAX(NUM_VENDAS) FROM(
                                                                   SELECT COUNT(*) AS NUM_VENDAS, A.cod_armazem
                                                                   FROM ORDEMCOMPRA OC, ARMAZEM A, Empregado Emp
                                                                   WHERE OC.cod_empregado = Emp.cod_empregado
                                                                                AND Emp.cod_armazem = A.cod_armazem
                                                                                AND A.cidade = 'Porto' AND OC.data_compra BETWEEN TO_DATE('2018-03-01', 'YYYY-MM-DD')
                                                                                AND TO_DATE('2018-10-15', 'YYYY-MM-DD')
                                                                                AND OC.estado = 2
                                                                   GROUP BY A.cod_armazem
                                                                   ORDER BY (cod_armazem)) TEMP)));



--e)
SELECT nome
FROM empregado
WHERE cod_empregado IN (
    SELECT cod_empregado
    FROM (
        SELECT COUNT(O.nr_ordem) as numero_de_ordens, E.cod_empregado
        FROM empregado E, ordem_compra O
        WHERE E.cod_supervisor IS NULL
        AND E.cod_empregado = O.cod_empregado
        GROUP BY E.cod_empregado
    )
    WHERE numero_de_ordens > (
        SELECT COUNT(*)
        FROM ordem_compra
        WHERE cod_empregado IN (
            SELECT cod_empregado
            FROM empregado
            WHERE cod_supervisor IS NOT NULL
            AND salario_semanal*4 BETWEEN 1000 AND 3000
        )
    )
);


--f)

SELECT cod_armazem,corredor,prateleira
FROM armazem_produto
WHERE cod_produto IN (SELECT cod_produto
                       FROM ordem_compra_produto OP
                       GROUP BY cod_produto
                       HAVING COUNT(*) = (SELECT MIN(COUNT(*))
                                          FROM ordem_compra_produto
                                          GROUP BY cod_produto));
--g)

SELECT corredor
FROM armazem_produto AP
WHERE cod_produto IN(SELECT cod_produto
                    FROM ordem_compra_produto
                    WHERE desconto_pedido > 20
                    GROUP BY cod_produto
                    HAVING COUNT(nr_ordem) = (SELECT MAX(COUNT(nr_ordem))
                                              FROM ordem_compra_produto
                                              WHERE desconto_pedido > 20
                                              GROUP BY cod_produto));

--h)
SELECT COUNT(PP.cod_produto) as quantidade, PP.mes, PP.cod_produto, P.descricao, P.unidade_medida, P.preco
FROM (
    SELECT OCP.cod_produto, EXTRACT(month FROM OC.data_compra) as mes
    FROM ordem_compra OC, ordem_compra_produto OCP
    WHERE EXTRACT(year FROM OC.data_compra) = 2018
    AND OC.nr_ordem = OCP.nr_ordem
    AND OCP.cod_produto IN(
        SELECT cod_produto
        FROM produto
        WHERE cod_produto IN (
            SELECT cod_produto
            FROM armazem_produto
            WHERE stock*1.5 > stock_minimo
        )
    )
) PP, produto P
WHERE PP.cod_produto = P.cod_produto
GROUP BY PP.mes, PP.cod_produto, P.descricao, P.unidade_medida, P.preco
ORDER BY PP.mes;

--i)
SELECT *
FROM ordem_compra
WHERE TO_CHAR(data_compra,'MM') BETWEEN 6 AND 8
    AND TO_CHAR(data_compra,'YYYY') = 2018
    AND estado = 3
    AND (cast(data_entrega AS DATE) - cast(data_compra AS DATE)) > 10
    AND TO_CHAR(data_compra,'HH') <10;
--j)
