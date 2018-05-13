# Started from the bottom
Это первый этап в пайплайне.
Основной код - в файле *read_cage_data.R*.
Данные по экспрессии - [с проeкта Fantom](http://fantom.gsc.riken.jp/5/datafiles/phase2.0/extra/CAGE_peaks/hg19.cage_peak_phase1and2combined_tpm_ann.osc.txt.gz).


Основные шаги в скрипте: 
1. Чтение файла экспресии
2. Получение спи
3. Анализ пересечения CAGE-пиков и аннотированных промотеров
4. Получение последовательностей пикам по рейнджам
5. Сумарная экспресия каждого ТФ по всем альтернитивным промотерам (на выходе файл для матрицы А)
6. Получение HUGO-символов ТФ по их id (hgnc или entrezgene) через BiomaRt (на выходе файл с таблицей соответствия)

Структура файла:
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
1841 - chr10:100013403..100013414,- ...
```
 
Посмотреть содержимое самой таблицы - `tail -n +1841 robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp | head -n 1` 

## 1.Чтение файла экспресии
Читаем файл начиная со строки 1841 (после комментариев и нормировочных констант) в переменную df. 
Сохраняем переменную в двоичный файл и далее вся работа происходит с ней, изначальный файл не трогаем.

## 2.Сумарная экспресия каждого ТФ по всем альтернитивным промотерам
Фильтруем транскрипты в матрице экспресии по наличию аннотированного id гена, далее суммируем экспрессию (строки), 
сгруппировав по этому id гена. 
На выходе dfA для матрицы А.

## 3.Получение HUGO-символов ТФ по их id (hgnc или entrezgene)
Данную информацию получаем через BiomaRt (для запуска этого блока потребуется подключение к интернету).
На выходе файл _genes.rd_ с таблицей соответствия.

## 4.Фильтрация матрицы А по имеющимся ТФ
На этом этапе строки матрицы из пункта 2 (каждая содержит наблюдение для одного гена) фильтруются таким образом,
чтобы остались только промотеры генов-ТФ, соответсвующие мотивам в нашей базе. 
На выходе - опять dfA для матрицы А. Также сама матрица записана в csv-файл _analysis/A.csv_.

## 5.Получение матрицы E
Этап с матрицей E - самый затратный по ресурсам (как и первый).
**Этот этап должен быть переписан на bash**.

## 6.Получение рейнджей
Рейнджы нужны для двух последний пунктов. **Фильтрация стооблцов должна быть переписана на _bash_**.
`tail -n +1841 robust_phase1_pls_2.tpm.desc121113.osc.txt.gz.tmp | head -n 100 | cut -f1,2,5`.

## 7.Получение последовательностей пикам по рейнджам

## 8.Анализ пересечения CAGE-пиков и аннотированных промотеров
Этот этап необязательный, нужен для подтверждения того, что пики находятся в промотерах.
**В дальнейшем этот этап поддержваться не будет**.

