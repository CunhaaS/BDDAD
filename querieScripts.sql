--a)
select AVG(salario_mensal),(E.salario_semanal * 48) as Salario_Anual 
from empregado E
where E.cod_armazem = (
        select A.cod_armazem 
        from armazem A
        where A.nome like 'Parafusos'
);

--b)




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

with data_estado as (
select A.cod_armazem, A.nome, A.cidade, OC.data_entrega,OC.estado from armazem A
INNER JOIN Empregado E ON E.cod_armazem = A.cod_armazem
INNER JOIN Ordem_Compra OC ON OC.cod_empregado = E.cod_empregado
where (OC.data_entrega BETWEEN '01/03/2018' AND '15/10/2018'))
select DE.cod_armazem 
from data_estado DE
Group by DE.cod_armazem
HAVING
    COUNT(*) = (
        SELECT
            MAX(COUNT(*) )
        FROM
            data_estado DE1
        WHERE
            DE1.estado = 2 and DE1.cidade Like 'Porto'
        GROUP BY
            DE1.cod_armazem
    );

--e)




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




--i)
SELECT *
FROM ordem_compra
WHERE TO_CHAR(data_compra,'MM') BETWEEN 6 AND 8 
    AND TO_CHAR(data_compra,'YYYY') = 2018
    AND estado = 2
    AND (cast(data_entrega AS DATE) - cast(data_compra AS DATE)) > 10
    AND TO_CHAR(data_compra,'HH') <10;
--j)
