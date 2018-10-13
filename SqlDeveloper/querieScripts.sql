--a)
SELECT (SELECT AVG(E.salario_semanal)
        FROM empregado)
,(E.salario_semanal * 60) as Salario_Anual
FROM empregado E
WHERE E.cod_armazem = (
        SELECT A.cod_armazem
        FROM armazem A
        WHERE A.nome like 'Parafusos'
);

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

    SELECT DISTINCT(nome), cod_armazem, morada, cidade
    FROM (SELECT a.* FROM armazem a
    INNER JOIN empregado e ON a.cod_armazem = e.cod_armazem
    INNER JOIN Ordem_compra oc ON oc.cod_empregado = e.cod_empregado
    WHERE UPPER(cidade) NOT LIKE 'PORTO' AND (SELECT Count(*) AS numero_total_ordem_compra
                                               FROM  Ordem_compra o
                                               INNER JOIN Empregado e ON o.cod_empregado = e.cod_empregado
                                               INNER JOIN armazem a ON e.cod_armazem = a.cod_armazem
                                               WHERE estado = 2 AND TO_CHAR(oc.data_compra,'DD-MM-YYYY') BETWEEN '01/03/2018'
                                               AND '15/10/2018' GROUP BY e.cod_empregado) > (SELECT Count(*) AS numero_total_ordem_compras
                                                                                             FROM  Ordem_compra o
                                                                                             INNER JOIN Empregado e ON o.cod_empregado = e.cod_empregado
                                                                                             INNER JOIN armazem a ON e.cod_armazem = a.cod_armazem
                                                                                             WHERE UPPER(a.cidade) LIKE 'PORTO'
                                                                                                AND TO_CHAR(oc.data_compra,'DD-MM-YYYY') BETWEEN '01/03/2018'
                                                                                                AND '15/10/2018' GROUP BY a.cidade));


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
    AND estado = 2
    AND (cast(data_entrega AS DATE) - cast(data_compra AS DATE)) > 10
    AND TO_CHAR(data_compra,'HH') <10;
--j)
