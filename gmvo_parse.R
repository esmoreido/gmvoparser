Sys.setlocale("LC_ALL","Russian")
# зависимости
library(readxl)     
library(writexl)
library(reshape2)
library(lubridate)
library(ggplot2)
library(rvest)
library(stringi)
library(dplyr)
setwd("d:/maps/GMVO/parser")

# считываем логин-пароль из файла
credentials <- read.csv('gmvo_pass.txt')
# заход на страницу авторизации
login <- 'https://gmvo.skniivh.ru/index.php?id=1'
# открываем сессию
pgsession <- session(login)
# форма авторизации
pgform <- html_form(pgsession)[[1]]
# заполняем 
filled_form <- html_form_set(pgform, username=credentials$login, password=credentials$pass)
# авторизация
session_submit(pgsession, filled_form)
# переход на страницу с формой запроса среднесуточных расходов воды
qpage <- session_jump_to(pgsession, url = 'https://gmvo.skniivh.ru/index.php?id=186')
# превращем в форму для заполнения
qform <- html_form(qpage)
# заполняем что знаем
filled_qform <- html_form_set(qform[[1]], 
                              `data_year[]` = qform[[1]][['fields']][['data_year[]']][['options']][[1]], 
                              sbo = 1, 
                              srb = 1)
# выполняем запрос
session <- session_submit(pgsession, filled_qform, submit = 'submit') 
# парсим полученную таблицу
table <- session %>% html_table()
table
  