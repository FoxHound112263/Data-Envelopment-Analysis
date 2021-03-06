####################################
## AN�LISIS DE ENVOLTURA DE DATOS ##
####################################

# PAQUETES
library(readxl)
library(plotrix)
library(plotly)
library(ggplot2)
library(ggrepel)
library(zoo)

#############################
######### EJEMPLOS ##########
############################

# Cargar datos en su totalidad
data <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/Base filtrada/Base esta si es.xlsx")
# Cargar datos solo espcialidad civil
data <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/BaseCivil.xlsx")

# dataframe para la funci�n dea
inputdata <- data.frame(data[3])
outputdata <- data.frame(data[2])
input <- as.matrix(inputdata)
output <- as.matrix(outputdata)

# Test de rendimientos a escala
rendimientos <- rts.test(input,output,model="output",H0="constant",bw="cv", B=100,alpha = 0.05)
rendimientos$pvalue

# Eficiencia t�cnica
e <- dea(XREF=input,YREF=output,input,output, RTS = "variable", model = "output")
e
summary(e)
e$thetaOpt
tabla_eficiencias <- data.frame(Departamento=data$dmu,"Eficiencia_t�cnica"=e$thetaOpt)
tabla_eficiencias

# Eficiencia sin Bogot�
datos2 <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/BaseCivilSinBogota.xlsx")

inputdata2 <- data.frame(datos2[3])
outputdata2 <- data.frame(datos2[2])
input2 <- as.matrix(inputdata2)
output2 <- as.matrix(outputdata2)

ef <- dea(XREF=input2,YREF=output2,input2,output2, RTS = "variable", model = "output")
ef

tabla2 <- data.frame(Departamento=datos2$dmu,Eficiencia_t�cnica=e$thetaOpt)
tabla2

# plot frontera de producci�n
frontera <- dea.plot.frontier(input,output,
                              xlab="# jueces",
                              ylab="# casos resueltos",
                              pch=20,
                              lwd=1,
                              lty=5,
                              col="red",
                              cex.axis=1,
                              cex = 1,
                              xlim=range(0,150),
                              ylim=range(0,20000),
                              main="Eficiencia t�cnica especialidad civil"
)

# dataframes para el gr�fico

tabla <- data.frame(data,eficiencia=e$thetaOpt)

tablalabel <- data.frame(data,eficiencia=e$thetaOpt)
tablalabel$eficiencia[-which(tablalabel$eficiencia==1)]=0  

tablalabel$color=rep("firebrick4",length(tablalabel$dmu))
tablalabel$color[which(tablalabel$eficiencia==1)]=rep("slateblue4",3)


tablalabel$eficiencia = as.factor(tablalabel$eficiencia)

myColors <- c("firebrick4", "slateblue4")



tabla2 <- tabla[which(tabla$eficiencia==1),] 
tabla <- tabla[-which(tabla$eficiencia==1),]

# ggplot con un mejor trato para los labels
# cortes�a de Laura
efplot2 <- ggplot(data=tablalabel,aes(x=jueces_civil,y=sali_civil,label=dmu))+
  geom_line(data=tabla2,aes(x=jueces_civil,y=sali_civil),color="firebrick4",cex=1,linetype="F1")+
  geom_point(aes(color=eficiencia,size=eficiencia))+
  scale_color_manual(values=myColors)+
  theme(legend.position = "none",rect=element_rect(fill = "transparent"),plot.title = element_text(hjust = 0.5),
        # para fondo blanco
        panel.grid=element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black")
  )+
  ggtitle("Eficiencia t�cnica especialidad civil")+
  labs(x="N�mero de jueces",y="N�mero de casos resueltos")+
  geom_label_repel(aes(label=dmu,color=eficiencia),force=8,arrow = arrow(length = unit(0.5, 'picas'))
  )

efplot2

ggsave("frontera_civil3.png",efplot2,dpi = 700, bg= "white")

# ggplot teniendo que usar "force"

efplot <- ggplot(data=tabla,aes(x=jueces_civil,y=sali_civil,label=dmu))+
  geom_point(color="firebrick4")+
  geom_label_repel(aes(label=dmu),size=2,color="dimgrey",force=8,arrow = arrow(length = unit(0.01, 'npc')))+
  geom_line(data=tabla2,aes(x=jueces_civil,y=sali_civil),color="firebrick4",cex=1,linetype="F1")+
  geom_point(data=tabla2,aes(x=jueces_civil,y=sali_civil),color="slateblue4",cex=2.5)+
  geom_label_repel(data = tabla2,aes(label=dmu),size=3,color="white",fill="slateblue4",force=800)+
  labs(x="N�mero de jueces",y="N�mero de casos resueltos")+
  ggtitle("Eficiencia t�cnica especialidad civil")+
  theme(rect=element_rect(fill = "transparent"),plot.title = element_text(hjust = 0.5))

efplot

# Guardar .png 
getwd()
ggsave("frontera_civil2.png",efplot,dpi = 700, bg="transparent")




# EJEMPLOS rDEA


## load data on Japanese hospitals (Besstremyannaya 2013, 2011)
data("hospitals", package="rDEA")

## inputs and outputs for analysis
Y = hospitals[c('inpatients', 'outpatients')]
X = hospitals[c('labor', 'capital')]
W = hospitals[c('labor_price', 'capital_price')]

## Naive input-oriented DEA score for the first 20 firms under variable returns-to-scale
firms=1:20
di_naive = dea(XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], model="input", RTS="variable")
di_naive$thetaOpt

## Naive DEA score in cost-minimization model for the first 20 firms under variable returns-to-scale
ci_naive = dea(XREF=X, YREF=Y, X=X[firms,], Y=Y[firms,], W=W[firms,],
               model="costmin", RTS="variable")
ci_naive$XOpt
ci_naive$gammaOpt

############################################################


# Funci�n DEA



library(readxl)
library(lpSolve)


################################################################
## ORIENTADO A LAS ENTRADAS CON RETTORNOS CONSTANTES A ESCALA ##
################################################################

data <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-C�lculo_DEA.xlsx",sheet = 1)

inputs <- data.frame(data[c(5,6)])
outputs <- data.frame(data[3])
N <- dim(data)[1] # number of DMUs
s <- dim(inputs)[2] # number of inputs
m <- dim(outputs)[2] # number of outputs

f.rhs <- c(rep(0,1,N),1) # RHS constraints
f.dir <- c(rep("<=",1,N),"=") # Direction of constraints
aux <- cbind(-1*inputs,outputs) # matrix of constraints coefficients in (6)


for (i in 1:N) {
  f.obj <- c(0*rep(1,s),as.numeric(outputs[i,])) #objective function coefficients
  f.con <- rbind(aux,c(as.numeric(inputs[i,]),rep(0,1,m))) # add LHS of b^T_Z=1
  results <- lp("max",as.numeric(f.obj),f.con,f.dir,f.rhs,scale=0,compute.sens = TRUE) # solve LPP
  #multipliers <- results$solution #input and output weigths
  #efficiency <- results$objval #efficiency score
  #duals <- results$duals # shadow prices
  if (i==1) {
    weights <- results$solution
    effcrs <- results$objval
    lambdas <- results$duals[seq(1,N)]
  } else {
    weights <- rbind(weights,results$solution)
    effcrs <- rbind(effcrs,results$objval)
    lambdas <- rbind(lambdas,results$duals[seq(1,N)])
  }
  
}

library(xlsx)
library(readxl)
library(lpSolve)


###############################################################
## ORIENTADO A LAS SALIDAS CON RETTORNOS CONSTANTES A ESCALA ##
###############################################################

data <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-C�lculo_DEA.xlsx",sheet = 1)

inputs <- data.frame(data[c(5,6)])
outputs <- data.frame(data[3])
N <- dim(data)[1] # number of DMUs
s <- dim(inputs)[2] # number of inputs
m <- dim(outputs)[2] # number of outputs


f.rhs <- c(rep(0,1,N),1) # RHS constraints
f.dir <- c(rep(">=",1,N),"=") # Direction of constraints
aux <- cbind(inputs, -1*outputs) # matrix of constraints coefficients in

for (i in 1:N) {
  f.obj <- c(as.numeric(inputs[i,]),0*rep(0,1,m)) #objective function coefficients
  f.con <- rbind(aux,c(rep(0,1,s),as.numeric(outputs[i,]))) # add LHS of c^T_z
  results <- lp("min",as.numeric(f.obj),f.con,f.dir,f.rhs,scale=0,compute.sens = TRUE) # solve LPP
  if (i==1) {
    weights <- results$solution
    effcrs <- results$objval
    lambdas <- results$duals[seq(1,N)]
  } else {
    weights <- rbind(weights,results$solution)
    effcrs <- rbind(effcrs,results$objval)
    lambdas <- rbind(lambdas,results$duals[seq(1,N)])
  }
  
}

###################
# c�digo �til
# creaci�n entradas para n�mero de jueces
dataflist <- lapply(listainputnj, data.frame)
nam <- "inputnj_"
val <- c(1:length(dataflist))
for(i in 1:length(val)){
  assign(
    paste(nam, val, sep = "")[i], dataflist[[i]]
  ) }


