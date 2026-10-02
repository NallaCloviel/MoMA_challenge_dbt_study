# 🏛️ MoMA Collection Data Pipeline: dbt + DuckDB

Pipeline analítico e modelagem dimensional do acervo aberto do **Museum of Modern Art (MoMA)** utilizando **dbt** (`dbt-duckdb`) e **DuckDB** como motor OLAP local e embarcado.

Este projeto resolve problemas complexos de desnormalização, dados aninhados (múltiplos artistas e nacionalidades em uma mesma string) e integridade referencial, gerando uma camada dimensional pronta para consultas analíticas de alta performance.

---

## 🚀 Arquitetura e Modelagem de Dados

O acervo do MoMA apresenta dados semiestruturados onde uma obra de arte pode possuir múltiplos criadores encapsulados em colunas com delimitadores e parênteses. 

O pipeline transforma os dados brutos (`raw`) em um esquema dimensional normalizado com tabela ponte de relacionamento muitos-para-muitos (N:N):

```
                   [ raw_artworks / raw_artists ]
                                 │
         ┌───────────────────────┼────────────────────────┐
         ▼                       ▼                        ▼
  stg_department        stg_classification           stg_artwork
         │                       │                        │
         ▼                       ▼                        ▼
    department             classification              artwork (Fato)
                                                          ▲
                                                          │ (artwork_id)
[ stg_artist ] ──► [ artist ] ◄────────────────────── [ creators ] (Ponte N:N)
                                     (artist_id)
```

### Principais Entidades Modeladas:
* **`raw_artworks` / `raw_artists`**: Ingestão direta dos arquivos CSV via DuckDB (`read_csv_auto`).
* **`department` / `classification`**: Dimensões de apoio com IDs gerados por particionamento (`ROW_NUMBER()`).
* **`artist`**: Dimensão de criadores desaninhandos via `str_split` e `unnest`, com anos de nascimento e morte convertidos e higienizados.
* **`artwork`**: Tabela de fatos com medidas físicas normalizadas (altura, largura, peso, dimensões) e chaves estrangeiras (`department_id`, `classification_id`).
* **`creators`**: Tabela de junção N:N mapeando cada obra aos seus múltiplos artistas individuais.

---

## 🛠️ Tecnologias Utilizadas

* **[DuckDB](https://duckdb.org/)**: Banco de dados analítico colunar (in-process OLAP).
* **[dbt-core](https://www.getdbt.com/)** & **`dbt-duckdb`**: Orquestração, compilação de SQL, linhagem de dados e transformações declarativas.
* **Python**: Ambiente e gerenciamento de dependências.

---

## 📂 Estrutura do Repositório

```text
moma_duckdb/
├── data/                 # Arquivos brutos (Artworks.csv, Artists.csv) - ignorados no Git
├── models/
│   ├── raw_artists.sql
│   ├── raw_artworks.sql
│   ├── stg_department.sql
│   ├── department.sql
│   ├── stg_classification.sql
│   ├── classification.sql
│   ├── stg_artwork.sql
│   ├── artwork.sql
│   ├── stg_artist.sql
│   ├── artist.sql
│   └── creators.sql
├── dbt_project.yml
├── .gitignore
└── README.md
```

---

## 🔧 Como Executar o Projeto Localmente

### 1. Pré-requisitos
* Python 3.9+ instalado
* Git

### 2. Instalação das dependências
Clone o repositório e crie o ambiente virtual:

```bash
git clone https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
cd SEU_REPOSITORIO/moma_duckdb

python3 -m venv .venv
source .venv/bin/activate  # No Windows: .venv\Scripts\activate

pip install dbt-duckdb
```

### 3. Obtenção dos Dados
Baixe os arquivos mais recentes do repositório oficial do [MoMA no GitHub](https://github.com/MuseumofModernArt/collection) e coloque-os dentro do diretório `data/`:
* `data/Artworks.csv`
* `data/Artists.csv`

### 4. Configurar o perfil do dbt (`~/.dbt/profiles.yml`)
Adicione a configuração de conexão ao seu arquivo de perfis:

```yaml
moma_duckdb:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: moma.duckdb
      schema: main
```

### 5. Executar as Transformações

Verifique a conexão:
```bash
dbt debug
```

Execute o pipeline completo:
```bash
dbt run
```

---

## 🔍 Exemplos de Consultas Analíticas

Com o arquivo `moma.duckdb` gerado, você pode abri-lo diretamente com o CLI do DuckDB (`duckdb moma.duckdb`) ou via script Python:

### Top 5 Obras com seus Criadores e Departamentos
```sql
SELECT 
    ar.name AS artista,
    aw.title AS obra,
    d.department AS departamento
FROM creators c
JOIN artwork aw ON c.artwork_id = aw.object_id
JOIN artist ar ON c.artist_id = ar.id
JOIN department d ON aw.department_id = d.id
LIMIT 5;
```

### Top 10 Artistas com mais Obras no Acervo
```sql
SELECT 
    ar.name AS artista,
    COUNT(c.artwork_id) AS total_obras
FROM creators c
JOIN artist ar ON c.artist_id = ar.id
GROUP BY ar.name
ORDER BY total_obras DESC
LIMIT 10;
```

---

## 📜 Licença e Créditos
* Fonte dos dados: [The Museum of Modern Art (MoMA) Collection](https://github.com/MuseumofModernArt/collection).