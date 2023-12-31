library(tidyverse)
# No en todos los casos los outliers son sujetos a eliminaci�n, es posible que los
# mismos requieran un "an�lisis" adicional fuera del conjunto global de datos
# Creaci�n de un subconjunto de datos con filter
df_amount <- filter(dataset,dataset$amount>4000)
df_duration <- filter(dataset,dataset$duration>36)
# Creaci�n de un subconjunto de datos con subset
df_age <- subset(dataset, dataset$age>55)
# Creaci�n de grupos mediante funciones de agregaci�n
# Monto promedio de solicitudes de pr�stamo para personas mayores de 55 a�os
av_age_mayores <- df_age |> 
                    group_by(age) |>
                      summarise(prom = mean(amount))
# Monto promedio de solicitudes detalladas por plazo
av_plazo <- df_duration %>%
              group_by(duration) %>%
                summarise(prom = mean(amount))
# Construcci�n de una tabla de frecuencia con group_by
tf_1<- dataset |>
        group_by(purpose,personal_status_sex) |>
          summarise(Frec = length(purpose), .groups = "drop")


# 2. Data Tyding - Preparaci�n, limpieza y organizaci�n de datos
# Se ejecutan una serie de tareas a fin de limpiar, transformar o reorganizar el conjunto de datos
# a fin de hacer m�s f�cil su an�lisis:

# 1) El dataset debe tener una estructura de variables (columnas) y registros (filas)
# A veces, los valores de una variable aparecen como variables, se debe eliminar esa dinamizaci�n
# 2) Desagregar los valores de variables fundidos (cuando dos o mas variables est�n en una sola)
# 3) Ajustar el tipo o clase de dato seg�n corresponda a la informaci�n que contiene cada variable
# 4) Tratar los NA's
# 5) Tratamiento de outliers


# Modificaci�n de los tipos de variables

# Las variables tipo "caracter" requieren ser ajustadas a tipo "factor" esto es, convertirlas a 
# variables categ�ricas. En las variables tipo factor se definen los niveles (o categor�as) lo cual 
# facilita el an�lisis de los datos. Consultar los valores �nicos que toma cada una de las variables
# tipo caracter ayuda a identificar aquellas que pueden transformarse en categ�ricas. 
# Tambi�n, es importante tener en cuenta que no todas las variables num�ricas lo son en s�,
# Algunas son variable dummie (son variables discretas que toman un n�mero limitado de valores)
# Usar la funci�n summary (que entrega un resumen de los datos) tambi�n puede ser �til
summary(dataset)
# Adicional a las variables tipo caracter, se tiene las variables 
# installment_rate, present_residence, number_credits, people_liable, credit_risk
# Pese a que son n�mericas, no es l�gico un an�lisis num�rico, su naturaleza es m�s
# categ�rica, son variables tipo dummie
# Las variables tipo caracter se van a ajustar todas a categ�ricas (factor)
# Algunas tipo entero deben ser ajustadas, tambi�n, a tipo factor, no obstante, hay que
# tener claramente identificadas cuales. Los resultados de summary proporcionan informaci�n
# si se requiere ver solo las variables num�ricas
# Observado el resumen de variables, solo las variables "duration", "amount" y "age" 
# tienen caracter num�rico (integer)
index_num <- which(names(dataset) %in% c("duration","amount","age")) # variable que contiene los �ndices de las columnas
# que no voy a modificar. Con el ciclo modifico una a una las variables del dataset
i = 1
for (i in (1:ncol(dataset))){
  if (!(i %in% index_num)){
    dataset[,i] <- as.factor(dataset[,i]) 
  }
}
rm(i) # Elimino las variables que no necesito m�s
summary(dataset) # Resumen de las variables con el ajuste en el dataset

# Identificaci�n y tratamiento de los Missing Values (NA's)

# Es com�n que en los dataset tengan NA's, esto se debe a debilidades en el proceso de captura de datos
# Un NA's hace referencia a un dato que no fue recolectado u observado pese a que el mismo existe
# Un NA (en t�rminos de bases de datos) es diferente a un valor nulo, para este �ltimo se asume que el mismo
# no existe

sum(is.na(dataset)) #Cantidad total de missing values 
library(VIM)
nas <- aggr(dataset) # Gr�fica de identificaci�n de los NA's
summary(nas) # Resumen num�rico de la identificaci�n de NA's
var_nas<-nas$missings$Variable[nas$missings[2]>0]
rm(nas)

# Una vez identificados los NA's es necesario generarles un tratamiento
# En el tratamiento se pueden contemplar varias opciones: eliminaci�n de la observaci�n
# Imputar por media o mediana (para variables num�ricas), moda o proporciones (para categ�ricas)
# o usar el m�todo de vecinos cercanos (kNN): media de los k vecinos para variables num�ricas y
# mayor proporci�n para las variables categ�ricas

# Variables con NA's: purpose, amount y housing
# Imputaci�n con kNN para k = 5 
dataset<-kNN(dataset,k=5,variable=var_nas, imp_var = FALSE)
rm(var_nas)
# Identificaci�n de outliers
summary(dataset[,index_num]) # Revisi�n de las variables num�ricas
caja <- boxplot(dataset[,index_num]) # Gr�fico de caja 
caja <- boxplot(scale(dataset[,index_num])) # Datos centrados en la media
# LS = Q3 + 1.5 * (Q1 - Q3) 
# LI = Q1 - 1.5 * (Q1 - Q3)
caja <- boxplot(scale(dataset[,index_num]), outcol="red") # Detalle de los "outliers"
# Para tener el valor real de las observaciones, en cada variable, de los "outliers"
# se hace el c�lculo sin scale
caja <- boxplot(dataset[,index_num], outcol="red")
# Valores que la gr�fica identifica como valores at�picos
# Group contiene el n�mero de la variable y caja el dato observado at�pico
outliers <- data.frame(caja$group,caja$out)
library(tidyverse)
outliers <- outliers %>% # Reemplazar los n�meros por los nombres de las variables
  mutate(caja.group = case_when(
    caja.group==1 ~ names(dataset[index_num[1]]),
    caja.group==2 ~ names(dataset[index_num[2]]),
    caja.group==3 ~ names(dataset[index_num[3]]),
    )
  )
# Separar en dataframes distintos los outliers por variables
list_outliers <- split(outliers, f = outliers$caja.group)
rm(outliers,caja,index_num)
names(list_outliers)
# De acuerdo al conocimiento del negocio (y de los datos) se decide si los puntos marcados
# como outliers se eliminan del dataset
# Si se decidiesen eliminar se debe identificar en qu� filas est�n los valores at�picos y
# luego se excluyen del dataset
# Para el dataset en cuesti�n las variables age y duration no contienen datos at�picos
# los valores marcados como tal se consideran dentro de los valores t�picos que una variable
# de este tipo puede tomar.
# Bajo el supuesto que para la variable "amount" si existen outliers, se proceder� entonces a 
# eliminar estos puntos, es de resaltar que se debe eliminar la observaci�n completa.
# Para esto, se requiere conocer el �ndice de fila (en el dataset) donde est�n los outliers 
f_out <- which(dataset$amount %in% list_outliers$amount$caja.out) # identifico las filas de 
# los registros con observaciones at�picas
df<- dataset[-f_out,] # dataset sin los registros que contienen las observaciones at�picas
rm(df,f_out,list_outliers)