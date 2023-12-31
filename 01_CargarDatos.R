# 1. Cargar el conjunto de datos

# En algunos casos es m�s pr�ctico cargar los datos desde su publicaci�n en la web
url <- "https://raw.githubusercontent.com/jairoescrito/00_MasterClass_R/master/dataset.csv"
# https://archive.ics.uci.edu/dataset/144/statlog+german+credit+data

# Si los datos se tienen en un repositorio local, es necesario copiar el archivo en el
# directorio de trabajo, o bien, en una variable tipo url, la ruta completa de acceso al
# archivo 
# Consultar mi directorio de trabajo: getwd()
# Modificar el directorio de trabajo: setwd("C:\\Directorio\de\Trabajo")

# Descargar el conjunto de datos y guardarlo en un arreglo de datos tipo dataframe
dataset <- read.csv(url) # Lectura de archivos planos (tipo csv)
rm(url) #eliminar la variable del entorno es �til para optimizar el uso de recursos
## 1. Entendimiento del dataset
# Conocer cada una de las variables que componen el dataset, el tipo de datos y las posibles
# variables de baja relevancia en el an�lisis a realizar

# Para cargar archivos xlsx, es necesaria la librer�a "openxlsx"
library(openxlsx)
# Lectura desde el fichero local definido como directorio de trabajo
dataset2<-read.xlsx("dataset.xlsx",sheet = 1) # Con el par�mentro sheet le mencionamos que hoja del 
# libro queremos que cargue en el dataframe. Esta instrucci�n carga una sola hoja

# Exploraci�n inicial del conjunto de datos

# Tama�o del dataset
cat(nrow(dataset), "filas y", ncol(dataset),"columnas")
head(dataset) # vista previa (en consola) de las primeras filas del dataset
View(dataset) # Funci�n predeterminada de RStudio para ver el dataset en una pesta�a auxiliar
'
status: estado de ingresos en cuentas (movimientos)
duration: duraci�n, en meses, del cr�dito solicitado
credit_history: historial crediticio
purpose: prop�sito del prestamo
amount: monto del prestamo
savings: ahorros
employment_duration: antig�edad en el empleo actual
installment_rate: proporci�n de recursos qque se destinan a pago de deudas
personal_status_sex: estado civil y g�nero
other_debtors: otras deudas
present_residence: antig�edad en la residencia actual 
property: Propiedades o activos
age: edad
other_installment_plans: otros planes de pago
housing: tipo de vivienda
number_credits: n�mero de cr�ditos en el banco
job: empleo
people_liable: personas a cargo
telephone: tel�fono a nombre del solicitante
foreign_worker: extranjero
credit_risk: riesgo de cr�dito
'
# An�lisis inicial del tipo de datos por variable (columna): se verificar el tipo de dato de cada
# variable corresponde al tipo de dato que contiene la columna, por ejemplo, que las columnas que
# tienen n�meros est�n guardados como n�meros.
sapply(dataset,class)
unique(sapply(dataset,class)) # Obtenemos los tipos de datos que tenemos en el dataset
sum(sapply(dataset,class) == "character") # Cantidad de variables tipo caracter
sum(sapply(dataset,class) == "integer") # cantidad de variables tipo entero



