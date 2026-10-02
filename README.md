# MoMA Collection Data Pipeline: dbt + DuckDB

Pipeline analítico e modelagem dimensional do acervo aberto do **Museum of Modern Art (MoMA)** utilizando **dbt** (`dbt-duckdb`) e **DuckDB** como motor OLAP local e embarcado.

Este projeto resolve problemas complexos de desnormalização, dados aninhados (múltiplos artistas e nacionalidades em uma mesma string) e integridade referencial, gerando uma camada dimensional pronta para consultas analíticas de alta performance.
