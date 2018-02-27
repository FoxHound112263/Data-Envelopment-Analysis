####################################
## AN�LISIS DE ENVOLTURA DE DATOS ##
####################################

library(readxl)
##########################
######### DATOS ##########
##########################

juzgcirc <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-C�lculo_DEA.xlsx",sheet = 1)
juzgdist <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-C�lculo_DEA.xlsx",sheet = 4)
tribdist <- read_excel("C:/Users/CamiloAndr�s/Desktop/DNP/Proyectos/Distribuci�n de la oferta judicial/DEA en R/Repo/Data-Envelopment-Analysis/Bases_de_Rama_Judicial-C�lculo_DEA.xlsx",sheet = 6)

# lista de entradas y salidas
listainputs  <- list(juzgcirc[5],juzgdist[5],tribdist[5])
listaoutputs <- list(juzgcirc[3],juzgdist[3],tribdist[3])

# creaci�n entradas autom�tico
dataflist <- lapply(listainputs, data.frame)
nam <- "input_"
val <- c(1:length(dataflist))
for(i in 1:length(val)){
  assign(
    paste(nam, val, sep = "")[i], dataflist[[i]]
  ) }

# creaci�n salidas autom�tico
dataflist2 <- lapply(listaoutputs, data.frame)
nam2 <- "output_"
val2 <- c(1:length(dataflist2))
for(i in 1:length(val2)){
  assign(
    paste(nam2, val2, sep = "")[i], dataflist2[[i]]
  ) }

detach(package:Benchmarking)
library(rDEA)
# eficiencia t�cnica

eftjcirc <- dea(XREF=input_1,YREF=output_1,input_1,output_1,RTS = "variable",model = "output")
eftjdist <- dea(XREF=input_2,YREF=output_2,input_2,output_2,RTS = "variable",model = "output")
efttdist <- dea(XREF=input_3,YREF=output_3,input_3,output_3,RTS = "variable",model = "output")

ef_juzg_circ <- data.frame(Circuito=juzgcirc$CIRCUITO,Eficiencia_t�cnica=eftjcirc$thetaOpt)
ef_juzg_dist <- data.frame(Distrito=juzgdist$DISTRITO,Eficiencia_t�cnica=eftjdist$thetaOpt)
ef_trib_dist <- data.frame(Distrito=tribdist$DISTRITO,Eficiencia_t�cnica=efttdist$thetaOpt)

detach(package:rDEA)
library(Benchmarking)
library(ggrepel)
library(ggplot2)
# GR�FICO frontera de producci�n (1 input y 1 output)


# Gr�fico para juzgados por circuito

###########
input_1 <- as.matrix(input_1)
output_1 <- as.matrix(output_1)
plotef <- dea.plot.frontier(input_1,output_1,RTS = "vrs")
###########

tablaf1 <- data.frame(juzgcirc,eficiencia=eftjcirc$thetaOpt)
myColors <- c("firebrick4", "slateblue4")
tablalabelf1 <- data.frame(juzgcirc,eficiencia=eftjcirc$thetaOpt)
tablalabelf1$eficiencia[-which(tablalabelf1$eficiencia==1)]=0  
tablalabelf1$color=rep("firebrick4",length(tablalabelf1$CIRCUITO))
tablalabelf1$color[which(tablalabelf1$eficiencia==1)]=rep("slateblue4",4)
tablalabelf1$eficiencia = as.factor(tablalabelf1$eficiencia)

tablaff1 <- tablaf1[which(tablaf1$eficiencia==1),] 


fronteraJC <- ggplot(data=tablalabelf1,
                     aes(x=Jueces,
                         y=Egresos,
                         label=CIRCUITO)
                     )+
              geom_line(data=tablaff1,
                        aes(x=Jueces,
                            y=Egresos),
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
              
              ggtitle("Eficiencia t�cnica proceso reparaci�n directa por circuito (juzgados)"
                      )+
              labs(x="N�mero de jueces",
                   y="N�mero de casos resueltos"
                   )+
              geom_label_repel(aes(label=CIRCUITO,
                                   color=eficiencia),
                               force=8,
                               arrow = arrow(length = unit(0.5, 'picas'))
                              )
fronteraJC


# Gr�fico para juzgados por distrito

###########
input_2 <- as.matrix(input_2)
output_2 <- as.matrix(output_2)
plotef2 <- dea.plot.frontier(input_2,output_2,RTS = "vrs")
###########

tablaf2 <- data.frame(juzgdist,eficiencia=eftjdist$thetaOpt)
tablalabelf2 <- data.frame(juzgdist,eficiencia=eftjdist$thetaOpt)
tablalabelf2$eficiencia[-which(tablalabelf2$eficiencia==1)]=0  
tablalabelf2$color=rep("firebrick4",length(tablalabelf2$DISTRITO))
tablalabelf2$color[which(tablalabelf2$eficiencia==1)]=rep("slateblue4",3)
tablalabelf2$eficiencia = as.factor(tablalabelf2$eficiencia)

tablaff2 <- tablaf2[which(tablaf2$eficiencia==1),] 


fronteraJD <- ggplot(data=tablalabelf2,
                    aes(x=Jueces,
                        y=Egresos,
                        label=DISTRITO)
                    )+
              geom_line(data=tablaff2,
                        aes(x=Jueces,
                            y=Egresos),
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
              ggtitle("Eficiencia t�cnica proceso reparaci�n directa por distrito (juzgados)"
                      )+
              labs(x="N�mero de jueces",
                   y="N�mero de casos resueltos"
                   )+
              geom_label_repel(aes(label=DISTRITO,
                                   color=eficiencia),
                               force=8,
                               arrow = arrow(length = unit(0.5, 'picas'))
                              )
fronteraJD



# Gr�fico pra tribunales por distrito

###########
input_3 <- as.matrix(input_3)
output_3 <- as.matrix(output_3)
plotef3 <- dea.plot.frontier(input_3,output_3,RTS = "vrs")
###########

tablaf3 <- data.frame(tribdist,eficiencia=efttdist$thetaOpt)
tablalabelf3 <- data.frame(tribdist,eficiencia=efttdist$thetaOpt)
tablalabelf3$eficiencia[-which(tablalabelf3$eficiencia==1)]=0  
tablalabelf3$color=rep("firebrick4",length(tablalabelf3$DISTRITO))
tablalabelf3$color[which(tablalabelf3$eficiencia==1)]=rep("slateblue4",2)
tablalabelf3$eficiencia = as.factor(tablalabelf3$eficiencia)

tablaff3 <- tablaf3[which(tablaf3$eficiencia==1),] 


fronteraTD <- ggplot(data=tablalabelf3,
                     aes(x=Jueces,
                         y=Egresos,
                         label=DISTRITO)
                    )+
              geom_line(data=tablaff3,
                        aes(x=Jueces,
                            y=Egresos),
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
              ggtitle("Eficiencia t�cnica proceso reparaci�n directa por distrito (tribunales)"
                      )+
              labs(x="N�mero de jueces",
                  y="N�mero de casos resueltos"
                  )+
              geom_label_repel(aes(label=DISTRITO,
                                   color=eficiencia),
                               force=8,
                               arrow = arrow(length = unit(0.5, 'picas'))
                              )
fronteraTD

