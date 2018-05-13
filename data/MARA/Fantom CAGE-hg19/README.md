# Started from the bottom
Это первый этап в пайплайне.
Основной код - в файле *read cage data.R*.
Данные по экспрессии - [с проeкта Fantom](http://fantom.gsc.riken.jp/5/datafiles/phase2.0/extra/CAGE_peaks/hg19.cage_peak_phase1and2combined_tpm_ann.osc.txt.gz)


Основные шаги в скрипте: 
1. Чтение файла экспресии
2. Получение спи
3. Анализ пересечения CAGE-пиков и аннотированных промотеров
4. Получение последовательностей пикам по рейнджам
5. Сумарная экспресия каждого ТФ по всем альтернитивным промотерам (на выходе файл для матрицы А)
6. Получение HUGO-символов ТФ по их id (hgnc или entrezgene) через BiomaRt (на выходе файл с таблицей соответствия)

Структура файла:
`tail -n +1841 robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp | head -n 1`

```
1 - ##ColumnVariables[00Annotation]=CAGE peak id
2 - ##ColumnVariables[short_description]=short form of the description below. Common descriptions in the long descriptions has been omited
3 - ##ColumnVariables[description]=description of the CAGE peak
4 - ##ColumnVariables[association_with_transcript]=transcript which 5end is the nearest to the the CAGE peak
5 - ##ColumnVariables[entrezgene_id]=entrezgene (genes) id associated with the transcript
6 - ##ColumnVariables[hgnc_id]=hgnc (gene symbol) id associated with the transcript
7 - ##ColumnVariables[uniprot_id]=uniprot (protein) id associated with the transcript
8 - ##ParemeterValue[genome_assembly]=hg19
9 - ##ColumnVariables ...
...
1838 - column names ...
1839 - 01STAT:MAPPED	...
1840 - 02STAT:NORM_FACTOR ..
1841 - chr10:100013403..100013414,- ...```