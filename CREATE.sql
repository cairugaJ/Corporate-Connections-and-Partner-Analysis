/*
	Script definitivo para banco de dados da Receita Federal
		- Considerando formas normais (evitar redundância)
        - Com chaves estrangeiras (indexação e otimização de consultas)
        - Tabelas:
			- EMPRESAS
            - CNAES
            - MUNICIPIOS
            - REGIME_TRIBUTARIO
            - SÓCIOS
            - ESTABELECIMENTOS
	Versão: 2024-01-02
*/

-- Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS rf;

-- Criação da tabela de Empresas
CREATE TABLE IF NOT EXISTS rf.empresas (
	cnpj_basico VARCHAR(8) PRIMARY KEY CHECK (LENGTH(cnpj_basico) = 8),
    razao_social TEXT,
    nat_juridica VARCHAR(4) CHECK (LENGTH(nat_juridica) = 4),
    quali_resp TINYTEXT,
    capital_social DOUBLE,
    porte VARCHAR(2),
    ente_fed_resp TINYTEXT
);
    
-- Criação da tabela de CNAEs
CREATE TABLE IF NOT EXISTS rf.cnaes (
		codigo VARCHAR(7) PRIMARY KEY CHECK (LENGTH(codigo) = 7),
        secao TINYTEXT,
        divisao TINYTEXT,
        grupo TINYTEXT,
        classe TINYTEXT,
        descricao TINYTEXT NOT NULL
);

-- Criação da tabela de Municípios
CREATE TABLE IF NOT EXISTS rf.municipios (
	cd_rf INT PRIMARY KEY,
    cd_ibge INT UNIQUE NOT NULL,
    nome_rf VARCHAR(60) NOT NULL,
    nome_ibge VARCHAR(60),
    uf VARCHAR(2)
);

-- Criação da tabela de Regime Tributário
CREATE TABLE IF NOT EXISTS rf.regime_tributario (
	cnpj_basico VARCHAR(8) CHECK (LENGTH(cnpj_basico) = 8),
    cnpj_ordem VARCHAR(8) CHECK (LENGTH(cnpj_ordem) = 4),
    cnpj_dv VARCHAR(8) CHECK (LENGTH(cnpj_dv) = 2),
    ano INT,
    cnpj_scp VARCHAR(14),
    forma_tributacao TINYTEXT,
    qtd_escrituracoes INT,
    PRIMARY KEY (cnpj_basico, cnpj_ordem, cnpj_dv)
);

-- Criação da tabela de Sócios
CREATE TABLE IF NOT EXISTS rf.socios (
	cnpj_basico VARCHAR(8) CHECK (LENGTH(cnpj_basico) = 8),
    tipo INT,
    nome VARCHAR (255),
    cpf_cnpj VARCHAR(14) CHECK (LENGTH(cpf_cnpj) > 10),
    qualificacao TINYTEXT,
    data_entrada_sociedade INT,
    pais VARCHAR(3),
    rep_legal TINYTEXT,
    nome_rep_legal TINYTEXT,
    quali_rep_legal TINYTEXT,
    faixa_etaria INT,
    PRIMARY KEY (cnpj_basico, nome, cpf_cnpj),
    CONSTRAINT fk_socios_empresas
        FOREIGN KEY (cnpj_basico) REFERENCES rf.empresas(cnpj_basico)
);

-- Criação da tabela de Estabelecimentos
CREATE TABLE IF NOT EXISTS rf.estabelecimentos (
	cnpj_basico VARCHAR(8) CHECK (LENGTH(cnpj_basico) = 8),
    cnpj_ordem VARCHAR(8) CHECK (LENGTH(cnpj_ordem) = 4),
    cnpj_dv VARCHAR(8) CHECK (LENGTH(cnpj_dv) = 2),
    id_matriz_filial INT,
    nome_fantasia TEXT,
    sit_cadastral VARCHAR(2),
    dt_sit_cadastral INT,
    motivo_sit_cadastral TINYTEXT,
    nome_cidade_ext TINYTEXT,
    pais VARCHAR(3),
    dt_inicio_atv INT,
    cnae_principal VARCHAR(7) CHECK (LENGTH(cnae_principal)= 7),
    cnae_secundaria TEXT,
    tipo_logradouro TINYTEXT,
    logradouro TINYTEXT,
    numero_end INT,
    complemento TINYTEXT,
    bairro TINYTEXT,
    cep VARCHAR(8) CHECK (LENGTH(cep)= 8),
    uf VARCHAR(2),
    municipio INT,
    ddd_1 VARCHAR(2),
    telefone_1 VARCHAR (9),
    ddd_2 VARCHAR (2),
    telefone_2 VARCHAR(9),
    ddd_fax VARCHAR (7),
    email TEXT,
    sit_especial TINYTEXT,
    dt_sit_especial INT,
    PRIMARY KEY(cnpj_basico, cnpj_ordem, cnpj_dv),
    CONSTRAINT fk_estab_empresas
		FOREIGN KEY (cnpj_basico) REFERENCES rf.empresas(cnpj_basico),
	CONSTRAINT fk_estab_rt
		FOREIGN KEY (cnpj_basico, cnpj_ordem, cnpj_dv) REFERENCES rf.regime_tributario(cnpj_basico, cnpj_ordem, cnpj_dv),
	CONSTRAINT fk_estab_muni
		FOREIGN KEY (municipio) REFERENCES rf.municipios(cd_rf),
	CONSTRAINT fk_estab_cnae
		FOREIGN KEY (cnae_principal) REFERENCES rf.cnaes(codigo)
);
    
    

    
	