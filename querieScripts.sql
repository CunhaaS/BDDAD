--a)
select avg(E.salario_semanal), (E.salario_semanal * 48) as Salario_Anual 
from empregado E
where E.cod_armazem = (
        select A.cod_armazem 
        from armazem A
        where A.nome like 'Parafusos'
);

--b)




--c)
--armazem que possui o maior numero de empregados
SELECT cod_armazem
FROM empregado
GROUP BY cod_armazem
HAVING COUNT(cod_empregado) = (SELECT MAX(COUNT(cod_empregado))
                               FROM empregado
                               GROUP BY cod_armazem);
--todos os produtos fornecidos a um determinado armazem
SELECT cod_produto
FROM armazem_produto
WHERE cod_armazem = (SELECT cod_armazem
                 FROM empregado
                 GROUP BY cod_armazem
                 HAVING COUNT(cod_empregado) = (SELECT MAX(COUNT(cod_empregado))
                                                FROM empregado
                                                GROUP BY cod_armazem));
                                                
SELECT DISTINCT A.nome
FROM  armazem_produto AP
INNER JOIN armazem A ON A.cod_armazem = AP.cod_armazem
WHERE cod_produto IN (SELECT cod_produto
                      FROM armazem_produto
                      WHERE cod_armazem = (SELECT cod_armazem
                                           FROM empregado
                                           GROUP BY cod_armazem
                                           HAVING COUNT(cod_empregado) = (SELECT MAX(COUNT(cod_empregado))
                                                                           FROM empregado
                                                                           GROUP BY cod_armazem)));   
--d)

with data_estado as (
select A.cod_armazem, A.nome, A.cidade, OC.data_entrega,OC.estado from armazem A
INNER JOIN Empregado E ON E.cod_armazem = A.cod_armazem
INNER JOIN OrdemCompra OC ON OC.cod_empregado = E.cod_empregado
where (OC.data_entrega BETWEEN '01/03/2018' AND '15/10/2018'))
select DE.cod_armazem from data_estado DE
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




--h)




--i)




--j)
