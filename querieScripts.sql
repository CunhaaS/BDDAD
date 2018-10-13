--a)



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
