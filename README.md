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
Скрипт - `data/MARA/HOCOMOCO/pwm_long_file_parse.py`. Из одного большого файла на выходе имеем по одному 
файлу для каждого мотива в папке _data/MARA/HOCOMOCO/PWM_.

#### 2.Подготовка распарсинных мотивов
Предподготовка pwm для sarus (замена пробелов на табы, удаление пустых строк, замена LF на CRLF).
Скрипт - `data/MARA/HOCOMOCO/motif preparation.sh`.
Для каждого файла мотива из папке PWM создается подготовленный файл в папке PWM1.
Также записывает в `analysis/motifs.txt` список всех мотивов. Этот файл будет использоваться на следущем шаге.

#### 3.Фильтрация массивов
В имеющихся мотивах есть кейсы, когда для одного мотива есть две разные версии. 
На этом шаге происходит фильтрация мотивов  на основе скора `{"si" : 1, "f1" : 2, "f2" : 3, "do" : 4}`.
Скрипт - `scripts/MARA/filter_motifs.R`.

#### 4.Скрипт для получения порога
Файл - `data/MARA/sarus/motif_treshold_finding.py`. Будет использоваться другим скриптом на **шаге 6**. 
На входе получает имя мотива, на выходе - его порог.

#### 5.Обработка данных Fantom
Скрипт - `data/MARA/Fantom_CAGE-hg19/read_cage_data.R`.
На выходе матрицы A и E (`analysis/A.csv` и `anaysis/E.csv` соответственно), а также сиквенс промотеров
для данных TSS в файле `data/seqs/hg19_promoters.mfa`.

#### 6.Получение матрицы вхождений
Для каждого промотера из `data/seqs/hg19_promoters.mfa` (полученного на предыдущем пункте) считается 
количество вхождний в него каждого мотива (полученных на шаге 2).
Скрипт - `data/MARA/sarus/motif_occurences.sh`. На выходе - `result.csv`.

#### 7.Подготовка матрицы вхождений
Для файла с матрицей, полученного на предыдущем шаге, производятся следущие шаги
* транспонирование
* фильтрация значений ниже порога до 0
* удаление ненужных столбцов
* фильтрация ненужных версий мотивов на основе скора `{"si" : 1, "f1" : 2, "f2" : 3, "do" : 4}`
Скрипт - `data/MARA/sarus/threshold_cut.py`. 
На выходе - `data/MARA/sarus/promoters_list.txt` со списком отфильтрованных промотеров,
а также файл `analysis/M.csv` с готовой матрицей М.