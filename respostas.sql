---------------------------------------------
-- QUERY's Utilizadas para criação do Dash --
---------------------------------------------

--GERAL
SELECT 
	NU_INSCRICAO 													AS NUMERO_INSCRICAO,
	NO_MUNICIPIO_PROVA 												AS NOME_ESTADO_ESCOLA,
	( CAST(NU_NOTA_CN AS FLOAT) + CAST(NU_NOTA_CH AS FLOAT) +
	CAST(NU_NOTA_LC AS FLOAT) + CAST(NU_NOTA_MT AS FLOAT) +
	CAST(NU_NOTA_REDACAO AS FLOAT) ) / 5 							AS MEDIA,
	CAST(NU_NOTA_CN AS FLOAT) 										AS NOTA_CIENCIA_NATUREZA,
	CAST(NU_NOTA_CH AS FLOAT) 										AS NOTA_CIENCIA_HUMANA,
	CAST(NU_NOTA_LC AS FLOAT) 										AS NOTA_LINGUAGEM_CODIGO,
	CAST(NU_NOTA_MT AS FLOAT) 										AS NOTA_MATEMATICA,
	CAST(NU_NOTA_REDACAO AS FLOAT) 									AS NOTA_REDACAO,
	TP_PRESENCA_CN 	                                                AS PRESENCA_CIENCIA_NATUREZA,
	TP_PRESENCA_CH 	                                                AS PRESENCA_CIENCIA_HUMANA,
	TP_PRESENCA_LC 	                                                AS PRESENCA_LINGUAGEM_CODIGO,
	TP_PRESENCA_MT 	                                                AS PRESENCA_MATEMATICA,
	TP_SEXO 		                                                AS SEXO,
	TP_COR_RACA 	                                                AS ETNIA
FROM 
    MICRODADOS_ENEM_2020

--ESCOLA_MEDIA - Qual a escola com a maior média de notas?
SELECT
    NO_MUNICIPIO_PROVA,
    (
        CAST(NU_NOTA_CN AS FLOAT) + CAST(NU_NOTA_CH AS FLOAT) + CAST(NU_NOTA_LC AS FLOAT) + CAST(NU_NOTA_MT AS FLOAT) + CAST(NU_NOTA_REDACAO AS FLOAT)
    ) / 5 AS media
FROM
    MICRODADOS_ENEM_2020
ORDER BY
    media DESC
LIMIT
    1

--ALUNO_MEDIA - Qual o aluno com a maior média de notas e o valor dessa média?
SELECT
    NU_INSCRICAO,
    (
        CAST(NU_NOTA_CN AS FLOAT) + CAST(NU_NOTA_CH AS FLOAT) + CAST(NU_NOTA_LC AS FLOAT) + CAST(NU_NOTA_MT AS FLOAT) + CAST(NU_NOTA_REDACAO AS FLOAT)
    ) / 5 AS media
FROM
    MICRODADOS_ENEM_2020
ORDER BY
    media DESC
LIMIT
    1

--MEDIA_GERAL - Qual a média geral?
SELECT
    AVG(
        CASE
            WHEN TP_PRESENCA_CH <> 0
            AND TP_PRESENCA_CN <> 0
            AND TP_PRESENCA_MT <> 0
            AND TP_PRESENCA_LC <> 0 THEN (
                CAST(NU_NOTA_CN AS FLOAT) + CAST(NU_NOTA_CH AS FLOAT) + CAST(NU_NOTA_LC AS FLOAT) + CAST(NU_NOTA_MT AS FLOAT) + CAST(NU_NOTA_REDACAO AS FLOAT)
            ) / 5
            ELSE NULL
        END
    ) AS media_geral
FROM
    MICRODADOS_ENEM_2020
ORDER BY
    media_geral DESC
LIMIT
    1

--PERCENTUAL_AUSENTES - Qual o % de Ausentes?
SELECT
    (COUNT(*) * 100.0) / (
        SELECT
            COUNT(*)
        FROM
            MICRODADOS_ENEM_2020
    ) AS PorcentagemAusentes
FROM
    MICRODADOS_ENEM_2020
WHERE
    TP_PRESENCA_CN = 0
    OR TP_PRESENCA_CH = 0
    OR TP_PRESENCA_MT = 0
    OR TP_PRESENCA_LC = 0

--NUM_TOTAL - Qual o número total de Inscritos?
SELECT  
    COUNT(*) 
FROM
    MICRODADOS_ENEM_2020 

--MEDIA_DISCIPLINA - Qual a média por disciplina?
SELECT
    'NU_NOTA_CN' AS Disciplina,
    AVG(
        CASE
            WHEN NU_NOTA_CN >= '1' THEN CAST(NU_NOTA_CN AS FLOAT)
            ELSE NULL
        END
    ) AS Media
FROM
    MICRODADOS_ENEM_2020
UNION
SELECT
    'NU_NOTA_CH' AS Disciplina,
    AVG(
        CASE
            WHEN NU_NOTA_CH >= '1' THEN CAST(NU_NOTA_CH AS FLOAT)
            ELSE NULL
        END
    ) AS Media
FROM
    MICRODADOS_ENEM_2020
UNION
SELECT
    'NU_NOTA_LC' AS Disciplina,
    AVG(
        CASE
            WHEN NU_NOTA_CH >= '1' THEN CAST(NU_NOTA_LC AS FLOAT)
            ELSE NULL
        END
    ) AS Media
FROM
    MICRODADOS_ENEM_2020
UNION
SELECT
    'NU_NOTA_MT' AS Disciplina,
    AVG(
        CASE
            WHEN NU_NOTA_MT >= '1' THEN CAST(NU_NOTA_MT AS FLOAT)
            ELSE NULL
        END
    ) AS Media
FROM
    MICRODADOS_ENEM_2020
UNION
SELECT
    'NU_NOTA_REDACAO' AS Disciplina,
    AVG(
        CASE
            WHEN NU_NOTA_REDACAO >= '1' THEN CAST(NU_NOTA_REDACAO AS FLOAT)
            ELSE NULL
        END
    ) AS Media
FROM
    MICRODADOS_ENEM_2020

--MEDIA_SEXO - Qual a média por Sexo?
WITH medias AS (
    SELECT
        TP_SEXO,
        AVG(
            CASE
                WHEN NU_NOTA_CN >= '1' THEN CAST(NU_NOTA_CN AS FLOAT)
                ELSE NULL
            END
        ) AS media_CN,
        AVG(
            CASE
                WHEN NU_NOTA_CH >= '1' THEN CAST(NU_NOTA_CH AS FLOAT)
                ELSE NULL
            END
        ) AS media_CH,
        AVG(
            CASE
                WHEN NU_NOTA_LC >= '1' THEN CAST(NU_NOTA_LC AS FLOAT)
                ELSE NULL
            END
        ) AS media_LC,
        AVG(
            CASE
                WHEN NU_NOTA_MT >= '1' THEN CAST(NU_NOTA_MT AS FLOAT)
                ELSE NULL
            END
        ) AS media_MT,
        AVG(
            CASE
                WHEN NU_NOTA_REDACAO >= '1' THEN CAST(NU_NOTA_REDACAO AS FLOAT)
                ELSE NULL
            END
        ) AS media_REDACAO
    FROM
        MICRODADOS_ENEM_2020
    GROUP BY
        TP_SEXO
)
SELECT
    TP_SEXO,
    AVG(
        media_CN + media_CH + media_LC + media_MT + media_REDACAO
    ) / 5 AS media_total
FROM
    medias
GROUP BY
    TP_SEXO

--MEDIA_ETNIA - Qual a média por Etnia?
WITH medias AS (
    SELECT
        CASE
            WHEN TP_COR_RACA = '0' THEN 'Não declarado'
            WHEN TP_COR_RACA = '1' THEN 'Branca'
            WHEN TP_COR_RACA = '2' THEN 'Preta'
            WHEN TP_COR_RACA = '3' THEN 'Parda'
            WHEN TP_COR_RACA = '4' THEN 'Amarela'
            WHEN TP_COR_RACA = '5' THEN 'Indígena'
        END AS TP_COR_RACA,
        AVG(
            CASE
                WHEN NU_NOTA_CN >= '1' THEN CAST(NU_NOTA_CN AS FLOAT)
                ELSE NULL
            END
        ) AS media_CN,
        AVG(
            CASE
                WHEN NU_NOTA_CH >= '1' THEN CAST(NU_NOTA_CH AS FLOAT)
                ELSE NULL
            END
        ) AS media_CH,
        AVG(
            CASE
                WHEN NU_NOTA_LC >= '1' THEN CAST(NU_NOTA_LC AS FLOAT)
                ELSE NULL
            END
        ) AS media_LC,
        AVG(
            CASE
                WHEN NU_NOTA_MT >= '1' THEN CAST(NU_NOTA_MT AS FLOAT)
                ELSE NULL
            END
        ) AS media_MT,
        AVG(
            CASE
                WHEN NU_NOTA_REDACAO >= '1' THEN CAST(NU_NOTA_REDACAO AS FLOAT)
                ELSE NULL
            END
        ) AS media_REDACAO
    FROM
        MICRODADOS_ENEM_2020
    GROUP BY
        TP_COR_RACA
)
SELECT
    TP_COR_RACA,
    AVG(
        media_CN + media_CH + media_LC + media_MT + media_REDACAO
    ) / 5 AS media_total
FROM
    medias
GROUP BY
    TP_COR_RACA

------------------------------
-- Querys utilizadas a mais --
------------------------------

--MEDIA_LINGUA
SELECT
    CASE
        WHEN TP_LINGUA = '0' THEN 'Inglês'
        WHEN TP_LINGUA = '1' THEN 'Espanhol'
    END AS TIPO_LINGUA,
    AVG(
        CASE
            WHEN TP_PRESENCA_CH <> 0
            AND TP_PRESENCA_CN <> 0
            AND TP_PRESENCA_MT <> 0
            AND TP_PRESENCA_LC <> 0 THEN (
                CAST(NU_NOTA_CN AS FLOAT) + CAST(NU_NOTA_CH AS FLOAT) + CAST(NU_NOTA_LC AS FLOAT) + CAST(NU_NOTA_MT AS FLOAT) + CAST(NU_NOTA_REDACAO AS FLOAT)
            ) / 5
            ELSE NULL
        END
    ) AS media_geral
FROM
    MICRODADOS_ENEM_2020
GROUP BY
    TP_LINGUA

--MEDIA_ESTADO
SELECT
    SG_UF_PROVA,
    MAX(
        (
            CAST(NU_NOTA_CN AS FLOAT) + CAST(NU_NOTA_CH AS FLOAT) + CAST(NU_NOTA_LC AS FLOAT) + CAST(NU_NOTA_MT AS FLOAT) + CAST(NU_NOTA_REDACAO AS FLOAT)
        ) / 5
    ) AS media,
    COUNT(
        CASE
            WHEN TP_PRESENCA_CN = '1'
            AND TP_PRESENCA_CH = '1'
            AND TP_PRESENCA_LC = '1'
            AND TP_PRESENCA_MT = '1' THEN NU_INSCRICAO
        END
    ) AS PRESENTES
FROM
    MICRODADOS_ENEM_2020
GROUP BY
    SG_UF_PROVA
ORDER BY
    media DESC