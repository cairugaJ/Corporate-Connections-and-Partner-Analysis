# Imports
from bs4 import BeautifulSoup
import requests
import os
import time
from datetime import datetime
from tqdm import tqdm
import shutil

# URL
url = r'https://dados.rfb.gov.br/CNPJ/'

# Path to directory that will store the ZIP files
diretorio_destino = r"directory_name"
if not os.path.exists(diretorio_destino):
    # Create the directory
    os.makedirs(diretorio_destino)

### Downloadin data for the tables Empresas (Companies) and Sócios (Partners)
    
# Downloading the page's HTML
pagina = requests.get(url)
data = pagina.text

# Reading the HTML
soup = BeautifulSoup(data, features="lxml")
zips = []

# Get the link of the zip files
for link in soup.find_all('a'):
    if str(link.get('href')).endswith('.zip') and ("Empresas" in str(link.get('href')) or "Socios" in str(link.get('href'))):
        cam = link.get('href')
        if not cam.startswith('http'):
            zips.append(url+cam)
        else:
            zips.append(cam)

# Registers the date of the extraction
data_coleta = datetime.now().strftime('%Y-%m-%d') + '_'

# Download files
for url in tqdm(zips, desc="Downloading CNPJ data"):
    filename = os.path.join(diretorio_destino, data_coleta + os.path.split(url)[1])
    with requests.get(url, stream=True) as r:
        with open(filename, 'wb') as f:
            shutil.copyfileobj(r.raw, f)
