# bioinformatics-algoritm
Realisation of bioinformatic's algoritm

Documenting:
* methods and workflows
* the origin of all data in project directory
* when downloaded data
* data version information
* how downloaded the data
* the versions of the software that ran

### Этапы:
#### 1.Парсинг скачанных мотивов
Скрипт - `data/HOCOMOCO/pwm_long_file_parse.py`. Из одного большого файла на выходе имеем по одному 
файлу для каждого мотива в папке _data/HOCOMOCO/PWM_.

#### 2.Подготовка распарсинных мотивов
Предподготовка pwm для sarus (замена пробелов на табы, удаление пустых строк, замена LF на CRLF).
Скрипт - `data/HOCOMOCO/motif preparation.sh`.
Для каждого файла мотива из папке PWM создается подготовленный файл в папке PWM1.
Также записывает в `analysis/motifs.txt` список всех мотивов. Этот файл будет использоваться на следущем шаге.

#### 3.Фильтрация массивов
В имеющихся мотивах есть кейсы, когда для одного мотива есть две разные версии. 
На этом шаге происходит фильтрация мотивов  на основе скора `{"si" : 1, "f1" : 2, "f2" : 3, "do" : 4}`.
Скрипт - `scripts/filter_motifs.R`. На выходе - файл `analysis/filter_motifs.txt` со таблицей отфильтрованных мотивов.

#### 4.Скрипт для получения порога
Файл - `data/sarus/motif_treshold_finding.py`. Будет использоваться другим скриптом на **шаге 6**. 
На входе получает имя мотива, на выходе - его порог.

#### 5.Обработка данных Fantom
Скрипт - `data/MARA/Fantom_CAGE-hg19/read_cage_data.R`.
На выходе матрицы A и E (`analysis/A.csv` и `anaysis/E.csv` соответственно), сиквенс промотеров
для данных TSS в файле `data/seqs/hg19_promoters.mfa`, а также мотивы из файла `analysis/filter_motifs.txt`, для ТФ которых есть данные по экспрессии в Фантоме - записанные в `analysis/overall_motifs`.
Файлы `A.csv` и `E.csv` без заголовков, но с индексами.
### 5.1 
Скрипт `1. read_file_and_matrix_a.R`. На выходе `df.rd`  и `dfA.rf`.

### 5.2
Скрипт `2. gene_symbols_mapping.R`. На выходе `genes.rd`.

### 5.3
Скрипт `3. existing_motif_filtering.R`. На выходе `dfA.rd`, `analysis/overall_motifs.txt` и `analysis/A.csv`.

### 5.4
Скрипт `4. matrix_e.R`. На выходе `analysis.E.csv` и `dfE.rd`.

### 5.5
Скрипт `5. promoters_seqs.R`. На выходе `range.rd`, `prom.rd` и `data/seqs/hg19_promoters.mfa`.

#### 6.Получение матрицы вхождений
Для каждого промотера из `data/seqs/hg19_promoters.mfa` (полученного на предыдущем пункте) считается 
количество вхождний в него каждого мотива (полученных на шаге 2).
Скрипт - `data/sarus/motif_occurences.sh`. На выходе - `analysis/result.csv`.
В файле заголовок (нобез индекса) записи вида:
```
promoters,thresholds,seq_name1,seq_name2,...
motif1,threshold1,..
....
motifN,thresholdN,...
```


#### 7.Подготовка матрицы вхождений
Для файла с матрицей, полученного на предыдущем шаге, производятся следущие шаги
* фильтрация значений ниже порога до 0
* транспонирование
* удаление ненужных столбцов
* -фильтрация ненужных версий мотивов на основе скора `{"si" : 1, "f1" : 2, "f2" : 3, "do" : 4}`-
* фильтрация мотивов, которых нет в в Фантоме ли не ассоциированных с entrezgene_id (по файлу `analysis/overall_motifs`)
Скрипт - `data/sarus/threshold_cut.py`. 
На выходе - `data/sarus/promoters_list.txt` со списком отфильтрованных промотеров,
а также файл `analysis/M.csv` с готовой матрицей М.

#### 8.Подсчет матрицы активности промотеров
Используются полученные ранее матрицы E,M,A. Скрипт - `scripts/MARA.py`.
```
E = M * EA

Mt = V*Dt*Ut

OLS: EA = (Mt*M)-1 * Mt * B
SVD: M = U*D*Vt => EA = (V*Dt*Ut*U*D*Vt)-1*V*Dt*Ut *B = (V*Dt*D*Vt)-1*V*Dt*Ut *B = #т.к. матррица U - унитарна
 = ( (DVt)t*(DVt) )-1*V*Dt*Ut *B = (V*(Dt*D)*Vt)-1*V*Dt*Ut *B = Vt-1*(Dt*D)-1*V-1*V*Dt*Ut *B =
 = V * (Dt*D)-1 * Dt *Ut * B = V * D-1 * Ut * B
```
На выходе - матрица активности ТФ в файлу `analysis/ACT.csv`.

### Deployments
cwl-runner expirements.cwl job-inputs.yml
