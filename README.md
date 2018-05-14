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
Для каждого файла мотива из папке PWM создается подготовленный файл в папке PWM1