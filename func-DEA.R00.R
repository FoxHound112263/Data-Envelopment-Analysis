# FUNCI�N 1 JUZGADOS ENTRE CIRCUITOS
deaJusticia<- function(datos,vec_col_entrada,vec_col_salida,out_liers) {
  library(readxl) 
  library(Benchmarking)
  juzgcirc <- datos
  inputs1 <- data.frame(juzgcirc[,vec_col_entrada]) #vector de entradas
  inputs1 <- as.matrix(inputs1) #matriz necesaria para la funci�n dea de Benchmarking
  outputs1 <- data.frame(juzgcirc[vec_col_salida]) #vector de salidas
  outputs1 <- as.matrix(outputs1)
  dea1 <- dea(inputs1,outputs1,RTS="vrs",ORIENTATION = "out",SLACK = TRUE, DUAL = TRUE)
  eftcircj <- 1/dea1$eff
  eft_circj <- data.frame(Circuito=juzgcirc[,1],Eficiencia_t�cnica=eftcircj)
  a<-list(EfTecnica=eft_circj)
  unidades1<-colnames(dea1$lambda)[colSums(dea1$lambda)!=0]
  col0<-which(colnames(dea1$lambda)%in%unidades1)
  recomen1 <- data.frame(DMU=juzgcirc[,1],
                         dea1$lambda[,col0],
                         eftcircj,
                         (1-eftcircj)*100)
  colnames(recomen1)<-c("Ind",as.character(eft_circj[,1][eft_circj$Eficiencia_t�cnica==1]),"Eficiencia_t�cnica",
                        "Aumento_recomendado_en_%")
  a[["recom"]]<-recomen1
  superdea1 <- sdea(inputs1,outputs1,RTS = "vrs",ORIENTATION = "out")
  superef1 <- data.frame(Ind=juzgcirc[,1],Super_eficiencia=1/superdea1$eff)
  a[["supereff"]]<-superef1
  D1<-det(t(as.matrix(cbind(inputs1,outputs1)))%*%as.matrix(cbind(inputs1,outputs1)))
  i1<-out_liers
  x1y1w1=as.matrix(cbind(inputs1,outputs1))
  R1<-c()
  i=2
  for (i in 1:length(i1)) {
    x1y1w1i1 = x1y1w1[-i1[i],]
    D1i <- det( t(x1y1w1i1) %*% x1y1w1i1 )
    R1i <- D1i/D1
    R1<-c(R1,R1i)
  }
  if (length(i1[R1==0.4])==0) {
    a[["outliers"]]<-"No son outliers"
  }else{
    a[["outliers"]]<-i1[R1==0.4]
  }
  return(a)
}
data1 <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-DEA.xlsx",sheet = 1)
info<-deaJusticia(datos = data1,vec_col_entrada = c(5,6),c(3),c(1,7))
info$outliers

#FUNCI�N 2 JUZGADOS ENTRE DISTRITOS (EN REALIDAD CIRCUITOS)
deaJusticia2<- function(datos2,vec_col_entrada2,vec_col_salida2,out_liers2) {
  library(readxl) 
  library(Benchmarking)
  juzgdist <- datos2
  inputs2 <- data.frame(juzgdist[,vec_col_entrada2]) #vector de entradas
  inputs2 <- as.matrix(inputs2) #matriz necesaria para la funci�n dea de Benchmarking
  outputs2 <- data.frame(juzgdist[vec_col_salida2]) #vector de salidas
  outputs2 <- as.matrix(outputs2)
  dea2 <- dea(inputs2,outputs2,RTS="vrs",ORIENTATION = "out",SLACK = TRUE, DUAL = TRUE)
  eftdistj <- 1/dea2$eff
  eft_distj <- data.frame(Distrito=juzgdist[,1],Eficiencia_t�cnica=eftdistj)
  a2<-list(EfTecnica=eft_distj)
  unidades2<-colnames(dea2$lambda)[colSums(dea2$lambda)!=0]
  col02<-which(colnames(dea2$lambda)%in%unidades2)
  recomen2 <- data.frame(DMU=juzgdist[,1],
                         dea2$lambda[,col02],
                         eftdistj,
                         (1-eftdistj)*100)
  colnames(recomen2)<-c("Ind",as.character(eft_distj[,1][eft_distj$Eficiencia_t�cnica==1]),"Eficiencia_t�cnica",
                        "Aumento_recomendado_en_%")
  a[["recom"]]<-recomen2
  superdea2 <- sdea(inputs2,outputs2,RTS = "vrs",ORIENTATION = "out")
  superef2 <- data.frame(Ind=juzgdist[,1],Super_eficiencia=1/superdea2$eff)
  a[["supereff"]]<-superef2
  D2<-det(t(as.matrix(cbind(inputs2,outputs2)))%*%as.matrix(cbind(inputs2,outputs2)))
  i2<-out_liers2
  x2y2w2=as.matrix(cbind(inputs2,outputs2))
  R2<-c()
  i=2
  for (i in 1:length(i2)) {
    x2y2w2i2 = x2y2w2[-i1[i],]
    D2i <- det( t(x2y2w2i2) %*% x2y2w2i2 )
    R2i <- D2i/D2
    R2<-c(R2,R2i)
  }
  if (length(i2[R2==0.4])==0) {
    a[["outliers"]]<-"No son outliers"
  }else{
    a[["outliers"]]<-i1[R1==0.4]
  }
  return(a)
}
datis2 <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-DEA.xlsx",sheet = 4)
info2<-deaJusticia2(datos2 = datis2,vec_col_entrada2 = c(5,6),c(3),c(1))
info$outliers



####################################
## AN�LISIS DE ENVOLTURA DE DATOS ##
####################################

library(readxl) 
library(Benchmarking) #paquete con funciones dea

#######################################################
# JUZGADOS proceso reparaci�n directa entre CIRCUITOS #
#######################################################
juzgcirc <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-DEA.xlsx",sheet = 1)

inputs1 <- data.frame(c(juzgcirc[5],juzgcirc[6])) #vector de entradas
inputs1 <- as.matrix(inputs1) #matriz necesaria para la funci�n dea de Benchmarking
outputs1 <- data.frame(juzgcirc[3]) #vector de salidas
outputs1 <- as.matrix(outputs1)
dea1 <- dea(inputs1,outputs1,RTS="vrs",ORIENTATION = "out",SLACK = TRUE, DUAL = TRUE) #rendimientos variables, orientado a salidas y 2 etapas
# EFICIENCIA t�cnica 
eftcircj <- 1/dea1$eff 
eftcircj
eft_circj <- data.frame(Circuito=juzgcirc$CIRCUITO,Eficiencia_t�cnica=eftcircj)
eft_circj
# unidades de REFERENCIA
unidades1 <- data.frame(dea1$lambda)
# RECOMENDACI�N
recomen1 <- data.frame(Circuito=juzgcirc$CIRCUITO,Bogot�=unidades1$L5,
                      Leticia=unidades1$L16,
                      Mocoa=unidades1$L19,
                      Pamplona=unidades1$L22,
                      Pasto=unidades1$L23,
                      Eficiencia_t�cnica=eftcircj,
                      "Aumento_recomendado_en_porcentaje"=(1-eftcircj)*100)
recomen1
# HOLGURAS (eficiencia fuerte o d�bil)
dea1$sx
dea1$sy
# PESOS (sensibilidad/impacto sobre la eficiencia)
dea1$ux
dea1$vy 

# SUPEREFICIENCIA (Para detectar valores at�pico/Diferenciar unidades frontera)
superdea1 <- sdea(inputs1,outputs1,RTS = "vrs",ORIENTATION = "out")
1/superdea1$eff
superef1 <- data.frame(Circuito=juzgcirc$CIRCUITO,Super_eficiencia=1/superdea1$eff)
superef1

superdea1$lambda



# detecci�n de DATOS AT�PICOS con nube de datos
x1 <- with(juzgcirc, cbind(juzgcirc$Jueces))
y1 <- with(juzgcirc, cbind(juzgcirc$Carga))
w1 <- with(juzgcirc, cbind(juzgcirc$Egresos))
x1y1w1 <- cbind(x1,y1,w1)
D1 <- det(t(x1y1w1)%*%x1y1w1)
i1 <- c(1) #n�mero de DMUs a quitarse, que se sospeche que sean at�picos: En este caso, Bogot�
x1y1w1i1 = x1y1w1[-i1,]
D1i <- det( t(x1y1w1i1) %*% x1y1w1i1 )
R1i <- D1i/D1
R1i #valores peque�os de Ri me indican presencia de datos at�picos

# GR�FICAMENTE, entre m�s DMUs se quiten, m�s tarda la gr�fica en generarse
atipico1 <- outlier.ap(inputs1,outputs1,NDEL=5)
# para que un dato sea at�pico, la distancia entre el punto ubicado en cero y la l�nea punteada tiene que ser muy grande
outlier.ap.plot(atipico1$ratio)






#######################################################
# JUZGADOS proceso reparaci�n directa entre DISTRITOS #
#######################################################
juzgdist <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-DEA.xlsx",sheet = 4)

inputs2 <- data.frame(c(juzgdist[5],juzgdist[6])) #vector de entradas
inputs2 <- as.matrix(inputs2) #matriz necesaria para la funci�n dea de Benchmarking
outputs2 <- data.frame(juzgdist[3]) #vector de salidas
outputs2 <- as.matrix(outputs2)
dea2 <- dea(inputs2,outputs2,RTS="vrs",ORIENTATION = "out",SLACK = TRUE, DUAL = TRUE) #rendimientos variables, orientado a salidas y 2 etapas
# EFICIENCIA t�cnica
eftdistj <- 1/dea2$eff 
eftdistj
eft_distj <- data.frame(Circuito=juzgdist$DISTRITO,Eficiencia_t�cnica=eftdistj)
eft_distj
# unidades de REFERENCIA
dea2$lambda
# HOLGURAS (eficiencia fuerte o d�bil)
dea2$sx
dea2$sy

# SUPEREFICIENCIA (para detectar valores at�pico/diferenciar unidades frontera)
superdea2 <- sdea(inputs2,outputs2,RTS = "vrs",ORIENTATION = "out")
1/superdea2$eff
superef2 <- data.frame(Distrito=juzgdist$DISTRITO,Super_eficiencia=1/superdea2$eff)
superef2

superdea2$lambda


# detecci�n de DATOS AT�PICOS con nube de datos
x2 <- with(juzgdist, cbind(juzgdist$Jueces))
y2 <- with(juzgdist, cbind(juzgdist$Carga))
w2 <- with(juzgdist, cbind(juzgdist$Egresos))
x2y2w2 <- cbind(x2,y2,w2)
D2 <- det(t(x2y2w2)%*%x2y2w2)
i2 <- c(1) #n�mero de  DMUs a quitarse, que se sospeche que sean at�picos
x2y2w2i2 = x2y2w2[-i2,]
D2i <- det( t(x2y2w2i2) %*% x2y2w2i2 )
R2i <- D2i/D2
R2i #valores peque�os de Ri me indican presencia de datos at�picos

# GR�FICAMENTE, entre m�s DMUs se quiten, m�s tarda la gr�fica en generarse
atipico2 <- outlier.ap(inputs1,outputs1,NDEL=5)
# para que un dato sea at�pico, la distancia entre el punto ubicado en cero y la l�nea punteada tiene que ser muy grande
outlier.ap.plot(atipico1$ratio)



#########################################################
# TRIBUNALES proceso reparaci�n directa entre DISTRITOS #
#########################################################
tribdist <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-DEA.xlsx",sheet = 6)

inputs3 <- data.frame(c(tribdist[5],tribdist[6])) #vector de entradas
inputs3 <- as.matrix(inputs3) #matriz necesaria para la funci�n dea de Benchmarking
outputs3 <- data.frame(tribdist[3]) #vector de salidas
outputs3 <- as.matrix(outputs3)
dea3 <- dea(inputs3,outputs3,RTS="vrs",ORIENTATION = "out",SLACK = TRUE, DUAL = TRUE) #rendimientos variables, orientado a salidas y 2 etapas
# eficiencia t�cnica
eftdistt <- 1/dea3$eff 
eftdistt
eft_distt <- data.frame(Distrito=tribdist$DISTRITO,Eficiencia_t�cnica=eftdistt)
eft_distt
# unidades de referencia
unidades3 <- data.frame(dea3$lambda)
# recomendaci�n
recomen3 <- data.frame(Distrito=tribdist$DISTRITO,Arauca=unidades3$L2,
                       Cundinamarca=unidades3$L13,
                       San_Andr�s=unidades3$L22,
                       Pamplona=unidades3$L22,
                       Eficiencia_t�cnica=eftdistt,
                       "Aumento_recomendado_en_porcentaje"=(1-eftdistt)*100)
recomen3
# holguras (evidencia eficiencia fuerte o d�bil)
dea3$sx
dea3$sy
# supereficiencia (para detectar valores at�pico/diferenciar unidades frontera)
superdea3 <- sdea(inputs3,outputs3,RTS = "vrs",ORIENTATION = "out")
1/superdea3$eff
superef3 <- data.frame(Distrito=tribdist$DISTRITO,Super_eficiencia=1/superdea3$eff)
superef3

superdea3$lambda

# Datos at�picos para tribunales entre distritos
x3 <- with(tribdist, cbind(tribdist$Jueces))
y3 <- with(tribdist, cbind(tribdist$Carga))
w3 <- with(tribdist, cbind(tribdist$Egresos))
x3y3w3 <- cbind(x3,y3,w3)
D3 <- det(t(x3y3w3)%*%x3y3w3)
i3 <- c(1) # DMUs a quitarse, que se sospeche que sean at�picos
x3y3w3i3 = x3y3w3[-i3,]
D3i <- det( t(x3y3w3i3) %*% x3y3w3i3 )
R3i <- D3i/D3
R3i # Valores peque�os de Ri me indican presencia de datos at�picos

# COMPARACI�N
comp <- data.frame(Distrito=tribdist$DISTRITO,eficiencia_juzgados=eftdistj,eficiencia_tribunales=eftdistt)
comp

##########################
## EXPORTAR eficiencias ##
##########################
library(xlsx)
write.xlsx(eft_circj,"C:/Users/CamiloAndr�s/Desktop/DNP/basejc.xlsx")
write.xlsx(eft_distj,"C:/Users/CamiloAndr�s/Desktop/DNP/basejd.xlsx")
write.xlsx(eft_distt,"C:/Users/CamiloAndr�s/Desktop/DNP/basetd.xlsx")

###########################################################################
## GR�FICOS DE FRONTERAS DE PRODUCCI�N (2 inputs para producir 1 output) ##
###########################################################################
library(ggplot2)
library(ggrepel)

#########################################
# Gr�fico para JUZGADOS entre CIRCUITOS #
#########################################

########### Gr�fico con funci�n del paquete para saber forma de la frontera
#inputnj_1 <- as.matrix(inputnj_1)
#inputct_1 <- as.matrix(inputct_1)
#plotef <- dea.plot.frontier(inputnj_1,inputct_1,RTS = "vrs")
###########

tablaf1 <- data.frame(juzgcirc,eficiencia=dea1$eff)
myColors <- c("firebrick4", "slateblue4")
tablalabelf1 <- data.frame(juzgcirc,eficiencia=dea1$eff)
tablalabelf1$eficiencia[-which(tablalabelf1$eficiencia==1)]=0
tablalabelf1$color=rep("firebrick4",length(tablalabelf1$CIRCUITO))
tablalabelf1$color[which(tablalabelf1$eficiencia==1)]=rep("slateblue4", 5)
tablalabelf1$eficiencia = as.factor(tablalabelf1$eficiencia)

tablaff1 <- tablaf1[which(tablaf1$eficiencia==1),] 
tablaff1

fronteraJC <- ggplot(data=tablalabelf1,
                     aes(x=Jueces,
                         y=Carga,
                         label=CIRCUITO)
                     )+
              geom_line(data=tablaff1,
                        aes(x=Jueces,
                            y=Carga),
                        color="firebrick4",
                        cex=1,
                        linetype="F1"
                        )+
              geom_point(aes(color=eficiencia,
                             size=eficiencia)
                         )+
              scale_color_manual(values=myColors
                                 )+
              theme(legend.position = "none",
                    rect=element_rect(fill = "transparent"),
                    plot.title = element_text(hjust = 0.5),
                    # para fondo blanco
                    panel.grid=element_blank(),
                    panel.background = element_blank(),
                    axis.line = element_line(colour = "black")
                    )+
              
              ggtitle("Eficiencia t�cnica proceso reparaci�n directa entre circuitos (juzgados)"
                      )+
              labs(x="N�mero de jueces",
                   y="Carga de trabajo (Demanda+Inventario)"
                   )+
              geom_label_repel(aes(label=CIRCUITO,
                                   color=eficiencia),
                               force=8,
                               arrow = arrow(length = unit(0.5, 'picas'))
                              )
fronteraJC



###########################################
# Gr�fico para TRIBUNALES entre DISTRITOS #
###########################################

########### Gr�fico con funci�n del paquete para saber forma de la frontera
#input_3 <- as.matrix(input_3)
#output_3 <- as.matrix(output_3)
#plotef3 <- dea.plot.frontier(input_3,output_3,RTS = "vrs")
###########

tablaf3 <- data.frame(tribdist,eficiencia=dea3$eff)
tablalabelf3 <- data.frame(tribdist,eficiencia=dea3$eff)
tablalabelf3$eficiencia[-which(tablalabelf3$eficiencia==1)]=0  
tablalabelf3$color=rep("firebrick4",length(tablalabelf3$DISTRITO))
tablalabelf3$color[which(tablalabelf3$eficiencia==1)]=rep("slateblue4",3)
tablalabelf3$eficiencia = as.factor(tablalabelf3$eficiencia)

tablaff3 <- tablaf3[which(tablaf3$eficiencia==1),] 


fronteraTD <- ggplot(data=tablalabelf3,
                     aes(x=Jueces,
                         y=Carga,
                         label=DISTRITO)
                    )+
              geom_line(data=tablaff3,
                        aes(x=Jueces,
                            y=Carga),
                        color="firebrick4",
                        cex=1,
                        linetype="F1"
                        )+
              geom_point(aes(color=eficiencia,
                             size=eficiencia)
                        )+
              scale_color_manual(values=myColors
                                )+
              theme(legend.position = "none",
                    rect=element_rect(fill = "transparent"),
                    plot.title = element_text(hjust = 0.5)
                    )+
              ggtitle("Eficiencia t�cnica proceso reparaci�n directa entre distritos para tribunales"
                      )+
              labs(x="N�mero de jueces",
                  y="Carga de trabajo (Demanda+Inventario)"
                  )+
              geom_label_repel(aes(label=DISTRITO,
                                   color=eficiencia),
                               force=8,
                               arrow = arrow(length = unit(0.5, 'picas'))
                              )
fronteraTD




#Bootstrap
library(remotes)
install_version("FEAR","1.0")

install.packages("FEAR")


