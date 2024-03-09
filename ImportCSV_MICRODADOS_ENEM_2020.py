import csv
import sqlite3
import os



# Abrindo o arquivo CSV
with open(r'C:\Users\User953\Desktop\Teste_Mesha\DADOS\MICRODADOS_ENEM_2020.csv', 'r') as csvfile:

    # Criando conexão com o banco de dados SQLite
    conexao = sqlite3.connect('MICRODADOS_ENEM_2020.db')
    cursor = conexao.cursor()

    # Lendo o cabeçalho do CSV
    leitor = csv.reader(csvfile, delimiter=';')
    cabecalho = next(leitor)

    # Criando a tabela SQLite
    comando_sql = f"""
        CREATE TABLE IF NOT EXISTS MICRODADOS_ENEM_2020 (
            {', '.join(f'{coluna} TEXT' for coluna in cabecalho)}
        )
    """
    cursor.execute(comando_sql)

    # Inserindo os dados do CSV na tabela SQLite
    for linha in leitor:
        comando_sql = f"""
            INSERT INTO MICRODADOS_ENEM_2020 ({', '.join(cabecalho)})
            VALUES ({", ".join("'" + valor + "'" for valor in linha)})
        """
        print(comando_sql)
        cursor.execute(comando_sql)

    # Salvando as alterações no banco de dados
    conexao.commit()

    # Fechando a conexão com o banco de dados
    conexao.close()