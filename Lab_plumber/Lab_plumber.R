library(plumber)
library(lubridate)
library(dplyr)
library(jsonlite)

#* @apiTitle Laboratorio Plumber
#* @apiDescription En este API se practican características útiles
#* de los Endpoints de plumber
#* 
#* Luz Arévalo - 20200392

#### Parte 1: Forward to another handler ####

#* Aplicamos el filtro
#* @filter logger

function(req=NULL){
  
if(length(req$args)!=0){
  folder <- paste0(getwd(),req$PATH_INFO,"/","year=",year(Sys.Date()),
                 "/","month=",month(Sys.Date()),"/","day=",day(Sys.Date()),
                 "/","hour=",hour(Sys.time()))
    
    if (file.exists(folder)) {
      
      x <- list('req'=req$args,
                'query'=req$QUERY_STRING,
                'user'=req$HTTP_USER_AGENT)
      x<- toJSON(x,auto_unbox = TRUE)
      
      write(x,file = paste0(folder,req$PATH_INFO,"-",as.integer(Sys.time()),".json"))
      
    } else {
      browser()
      dir.create(folder,recursive = TRUE)
      
      x <- list('req'=req$args,
                'query'=req$QUERY_STRING,
                'user'=req$HTTP_USER_AGENT)
      
      x<- toJSON(x,auto_unbox = TRUE)
      
      write(x,file = paste0(folder,req$PATH_INFO,"-",as.integer(Sys.time()),".json"))
      
    }}
  plumber::forward()
  
}

# Archivo de la predicción
fit <- readRDS("modelo_final.rds")

#* Se hace la predicción de supervivencia
#* @param Pclass clase en el que viajabe el pasajero
#* @param Sex Sexo del pasajero
#* @param Age edad del pasajero
#* @param SibSp numero de hermanos
#* @param Parch numero de parientes
#* @param Fare precio del boleto
#* @param Embarked puerto del que embarco
#* @post /titanic

function(Pclass, Sex, Age, SibSp, Parch, Fare, Embarked){
  features <- data_frame(Pclass = as.integer(Pclass),
                         Sex,
                         Age=as.integer(Age),
                         SibSp= as.integer(SibSp),
                         Parch = as.integer(Parch),
                         Fare = as.numeric(Fare),
                         Embarked)
  out <- predict(fit,features,type = "class")
  as.character(out)
}


#### Parte 2: Dynamic Routes ####

#EJEMPLO 1
# Creamos un data frame
users <- data.frame(
  uid=c(12,13),
  username=c("kim", "john")
)


# La respuesta será el nombre del usuario con el `id` ingresado. 
#* Lookup a user
#* @get /users/<id>
function(id){
  subset(users, uid %in% id)
}

#EJEMPLO 2

# Cargamos un csv
datos <- read.csv("earthquakes.csv")
datos$date <- ymd(paste(datos$time.year,datos$time.month,datos$time.day,sep = "-"))

# Devuelve los datos que se encuentran entre el rango de fechas y lugar especificado

#* Terremotos entre fechas
#* @serializer csv
#* @get /terremotos/<from>/<to>/<where>
function(from, to,where){
  
    datos%>%
      filter(date >= ymd(from) & date <= ymd(to) & location.name == where)%>%
      select(time.full,location.name,impact.magnitude)
}





#### Parte 3: Typed Dynamic Routes ####

#EJEMPLO 1

#* El tipo de datos siempre es "character"
#* @get /type/<name>/<id>
function(name,id){
  list(
    name = name,
    type = typeof(name),
    id = id,
    type = typeof(id)
  )
}

#EJEMPLO 2

#* Definir el tipo de dato
#* @get /suma/<x:int>/<y:int>
function(x,y){
  list(
    "valor de x=" = x,
    "valor de y=" = y,
    "suma="= x+y)
}

#* Variables de tipo boolean
#* @post /user/activated/<active:bool>
function(active){
  if (!active){
    print("No active")
  } else{
    print("Active")
  }
}