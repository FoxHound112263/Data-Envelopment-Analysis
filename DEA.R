####################################
## AN�LISIS DE ENVOLTURA DE DATOS ##
####################################

library(readxl) 

#######################################################
# JUZGADOS proceso reparaci�n directa entre CIRCUITOS #
#######################################################
juzgcirc <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-DEA.xlsx",sheet = 1)

inputs1 <- data.frame(c(juzgcirc[5],juzgcirc[6])) #vector de entradas
inputs1 <- as.matrix(inputs1) #matriz necesaria para la funci�n dea de Benchmarking
outputs1 <- data.frame(juzgcirc[3]) #vector de salidas
outputs1 <- as.matrix(outputs1)
library(rDEA) #paquete con test de rendimientos a escala
# test de rendimientos a escala
rendimientos1 <- rts.test(inputs1,outputs1,model="output",H0="constant",bw="cv", B=100,alpha = 0.05)
rendimientos1$pvalue #si es mayor a 0.05, los rendimientos son variables
detach(package:rDEA)

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
library(Benchmarking) #paquete con funciones dea
# GR�FICAMENTE, entre m�s DMUs se quiten, m�s tarda la gr�fica en generarse
atipico1 <- outlier.ap(inputs1,outputs1,NDEL=5) #proceso lento
# para que se sospeche de un dato at�pico, la distancia entre el punto ubicado en cero y la l�nea punteada tiene que ser muy grande
outlier.ap.plot(atipico1$ratio)

dea1 <- dea(inputs1,outputs1,RTS="vrs",ORIENTATION = "out",SLACK = TRUE, DUAL = TRUE) #rendimientos variables, orientado a salidas y 2 etapas
# EFICIENCIA t�cnica 
eftcircj <- 1/dea1$eff 
eftcircj
eft_circj <- data.frame(Circuito=juzgcirc$CIRCUITO,Eficiencia_t�cnica=eftcircj)
eft_circj_ordenada <- eft_circj[order(-eft_circj$Eficiencia_t�cnica),] # ordenar por eficiencia
eft_circj_ordenada
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
recomen1_ordenada <- recomen1[order(-eft_circj$Eficiencia_t�cnica),]
recomen1_ordenada
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
superef1_ordenada <- superef1[order(-superef1$Super_eficiencia),]
superef1_ordenada
superdea1$lambda

#######################################################
# JUZGADOS proceso reparaci�n directa entre DISTRITOS #
#######################################################
juzgdist <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-DEA.xlsx",sheet = 4)

inputs2 <- data.frame(c(juzgdist[5],juzgdist[6])) #vector de entradas
inputs2 <- as.matrix(inputs2) #matriz necesaria para la funci�n dea de Benchmarking
outputs2 <- data.frame(juzgdist[3]) #vector de salidas
outputs2 <- as.matrix(outputs2)

detach(package:Benchmarking)
library(rDEA) #paquete con test de rendimientos a escala
# test de rendimientos a escala
rendimientos2 <- rts.test(inputs2,outputs2,model="output",H0="constant",bw="cv", B=100,alpha = 0.05)
rendimientos2$pvalue #si es mayor a 0.05, los rendimientos son variables
detach(package:rDEA)
library(Benchmarking)

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
atipico2 <- outlier.ap(inputs2,outputs2,NDEL=5)
# para que se sospeche de un at�pico, la distancia entre el punto ubicado en cero y la l�nea punteada tiene que ser muy grande
outlier.ap.plot(atipico2$ratio)

dea2 <- dea(inputs2,outputs2,RTS="vrs",ORIENTATION = "out",SLACK = TRUE, DUAL = TRUE) #rendimientos variables, orientado a salidas y 2 etapas

# EFICIENCIA t�cnica
eftdistj <- 1/dea2$eff 
eftdistj
eft_distj <- data.frame(Circuito=juzgdist$DISTRITO,Eficiencia_t�cnica=eftdistj)
eft_distj
eft_distj_ordenada <- eft_distj[order(-eft_distj$Eficiencia_t�cnica),] #ordenar por eficiencia
eft_distj_ordenada
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

#########################################################
# TRIBUNALES proceso reparaci�n directa entre DISTRITOS #
#########################################################
tribdist <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-DEA.xlsx",sheet = 6)

inputs3 <- data.frame(c(tribdist[5],tribdist[6])) #vector de entradas
inputs3 <- as.matrix(inputs3) #matriz necesaria para la funci�n dea de Benchmarking
outputs3 <- data.frame(tribdist[3]) #vector de salidas
outputs3 <- as.matrix(outputs3)

detach(package:Benchmarking)
library(rDEA) #paquete con test de rendimientos a escala
# test de rendimientos a escala
rendimientos3 <- rts.test(inputs3,outputs3,model="output",H0="constant",bw="cv", B=100,alpha = 0.05)
rendimientos3$pvalue #si es mayor a 0.05, los rendimientos son variables
detach(package:rDEA)
library(Benchmarking)

# detecci�n de DATOS AT�PICOS con nube de datos
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

# GR�FICAMENTE, entre m�s DMUs se quiten, m�s tarda la gr�fica en generarse
atipico3 <- outlier.ap(inputs3,outputs3,NDEL=5)
# para que se sospeche de un dato at�pico, la distancia entre el punto ubicado en cero y la l�nea punteada tiene que ser muy grande
outlier.ap.plot(atipico3$ratio)

dea3 <- dea(inputs3,outputs3,RTS="vrs",ORIENTATION = "out",SLACK = TRUE, DUAL = TRUE) #rendimientos variables, orientado a salidas y 2 etapas

# EFICIENCIA t�cnica
eftdistt <- 1/dea3$eff 
eftdistt
eft_distt <- data.frame(Distrito=tribdist$DISTRITO,Eficiencia_t�cnica=eftdistt)
eft_distt
eft_distt_ordenada <- eft_distt[order(-eft_distt$Eficiencia_t�cnica),] #ordenar por eficiencia
eft_distt_ordenada
# unidades de REFERENCIA
unidades3 <- data.frame(dea3$lambda)
# RECOMENDACI�N
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
# SUPEREFICIENCIA (para detectar valores at�pico/diferenciar unidades frontera)
superdea3 <- sdea(inputs3,outputs3,RTS = "vrs",ORIENTATION = "out")
1/superdea3$eff
superef3 <- data.frame(Distrito=tribdist$DISTRITO,Super_eficiencia=1/superdea3$eff)
superef3

superdea3$lambda

# COMPARACI�N entre primera y segunda instancia
comp <- data.frame(Distrito=tribdist$DISTRITO,eficiencia_juzgados=eftdistj,eficiencia_tribunales=eftdistt)
comp

##########################
## EXPORTAR eficiencias ##
##########################
library(xlsx)
write.xlsx(eft_circj_ordenada,"C:/Users/CamiloAndr�s/Desktop/basejc_ordenada.xlsx")
write.xlsx(eft_distj_ordenada,"C:/Users/CamiloAndr�s/Desktop/basejd_ordenada.xlsx")
write.xlsx(eft_distt_ordenada,"C:/Users/CamiloAndr�s/Desktop/basetd_ordenada.xlsx")
write.xlsx(recomen1_ordenada,"C:/Users/CamiloAndr�s/Desktop/recomen1_ordenada.xlsx")
write.xlsx(superef1_ordenada,"C:/Users/CamiloAndr�s/Desktop/superef1_ordenada.xlsx")

###########################################################################
## GR�FICOS DE FRONTERAS DE PRODUCCI�N (2 inputs para producir 1 output) ##
###########################################################################
library(ggplot2)
library(ggrepel)

#########################################
# Gr�fico para JUZGADOS entre CIRCUITOS #
#########################################

########### Gr�fico con funci�n del paquete para saber forma de la frontera
#inputs1 <- as.matrix(inputs1)
#outputs11 <- as.matrix(outputs1)
#plotef <- dea.plot.frontier(inputs1,outputs1,RTS = "vrs")
###########

tablaf1 <- data.frame(juzgcirc,eficiencia=dea1$eff)
myColors <- c("firebrick4", "slateblue4") #colores de eficiencia e ineficiencia
tablalabelf1 <- data.frame(juzgcirc,eficiencia=dea1$eff)
tablalabelf1$eficiencia[-which(tablalabelf1$eficiencia==1)]=0
tablalabelf1$color=rep("firebrick4",length(tablalabelf1$CIRCUITO))
tablalabelf1$color[which(tablalabelf1$eficiencia==1)]=rep("slateblue4", 5) #n�mero de unidades eficientes
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

# Guardar .png en directorio actual
ggsave("frontera1.png",fronteraJC,dpi = 700, bg= "white")


###########################################
# Gr�fico para TRIBUNALES entre DISTRITOS #
###########################################

########### Gr�fico con funci�n del paquete para saber forma de la frontera
#inputs3 <- as.matrix(inputs3)
#outputs3 <- as.matrix(outputs3)
#plotef3 <- dea.plot.frontier(inputs3,outputs3,RTS = "vrs")
###########

tablaf3 <- data.frame(tribdist,eficiencia=dea3$eff)
tablalabelf3 <- data.frame(tribdist,eficiencia=dea3$eff)
tablalabelf3$eficiencia[-which(tablalabelf3$eficiencia==1)]=0  
tablalabelf3$color=rep("firebrick4",length(tablalabelf3$DISTRITO))
tablalabelf3$color[which(tablalabelf3$eficiencia==1)]=rep("slateblue4",3) #n�mero de unidades eficientes
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
                    plot.title = element_text(hjust = 0.5),
                    # para fondo blanco
                    panel.grid=element_blank(),
                    panel.background = element_blank(),
                    axis.line = element_line(colour = "black")
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

# Guardar .png en directorio actual
ggsave("frontera2.png",fronteraTD,dpi = 700, bg= "white")




