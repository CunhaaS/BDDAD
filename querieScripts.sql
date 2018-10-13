--a)



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
