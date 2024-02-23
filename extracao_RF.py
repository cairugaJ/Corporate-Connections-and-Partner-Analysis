# Bibliotecas
from bs4 import BeautifulSoup
import requests
import os
import time
from datetime import datetime
from tqdm import tqdm
import shutil

# URL para site da receita com dados do cadastro
url = r'https://dados.rfb.gov.br/CNPJ/'

# Caminho para diretório que armazenará os arquivos zipados
diretorio_destino = r"teste"
if not os.path.exists(diretorio_destino):
    # Create the directory
    os.makedirs(diretorio_destino)

### Coletando os dados para as tabelas de CNAES, Empresas, Estabelecimentos, Motivos, Municípios, Naturezas, Países, Qualificações, Simples e Sócios
    
# Baixa HTML da página
pagina = requests.get(url)
data = pagina.text

# Lê HTML
soup = BeautifulSoup(data, features="lxml")
zips = []

# Coleta os links para baixar os arquivos zipados
for link in soup.find_all('a'):
    if str(link.get('href')).endswith('.zip'):
        cam = link.get('href')
        if not cam.startswith('http'):
            zips.append(url+cam)
        else:
            zips.append(cam)

# Registra data da coleta dos dados
data_coleta = datetime.now().strftime('%Y-%m-%d') + '_'

# Baixa os arquivos
for url in tqdm(zips, desc="Downloading CNPJ data"):
    filename = os.path.join(diretorio_destino, data_coleta + os.path.split(url)[1])
    with requests.get(url, stream=True) as r:
        with open(filename, 'wb') as f:
            shutil.copyfileobj(r.raw, f)

### Coletando os dados para as tabelas de regime tributário
    
# Os dados para regime tributário estão em um diretório diferente dos demais
url_regime_tributario = r"https://dados.rfb.gov.br/CNPJ/regime_tributario/"

# Baixa HTML da página
pagina = requests.get(url_regime_tributario)
data = pagina.text

# Lê HTML
soup = BeautifulSoup(data, features="lxml")
zips_rt = []

# Coleta os links para baixar os arquivos zipados
for link in soup.find_all('a'):
    if str(link.get('href')).endswith('.zip'):
        cam = link.get('href')
        if not cam.startswith('http'):
            zips_rt.append(url_regime_tributario+cam)
        else:
            zips_rt.append(cam)


# Registra data da coleta dos dados
data_coleta = datetime.now().strftime('%Y-%m-%d') + '_'

# Baixa os arquivos
for url in tqdm(zips_rt, desc="Downloading tax regime data"):
    filename = os.path.join(diretorio_destino, data_coleta + os.path.split(url)[1])
    with requests.get(url, stream=True) as r:
        with open(filename, 'wb') as f:
            shutil.copyfileobj(r.raw, f)