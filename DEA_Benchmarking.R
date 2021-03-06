# DEA rama judicial paquete Benchmarking

library(Benchmarking)
library(readxl)
library(plotrix)
library(plotly)
library(ggplot2)
library(ggrepel)

# NUEVAS EFICIENCIAS

# Eficiencia de Escala
library(rDEA)
e_vrs <- dea(XREF = input,YREF = output,input,output,model = "output",RTS = "variable")
e_crs <- dea(XREF = input,YREF = output,input,output,model = "output",RTS = "constant")
efescala <- e_crs$thetaOpt/e_vrs$thetaOpt
efescala

tablaescala <- data.frame(Departamento=data$dmu,EficienciaEscala=efescala)
tablaescala


# Eficiencia de asignaci�n 
# Para esta es necesario tener costos/precios
# Para el caso de los jueces podr�a servir su salario


# Super eficiencia

superef <- sdea(input,output,RTS = "vrs",ORIENTATION = "out")
superef$eff
tablasuperef <- data.frame(Departamento=data$dmu, superef$eff)
tablasuperef
# Arauca no tiene soluci�n factible para super eficiencia
# esto puesto que presenta rendimientos crecientes a escala
# Arauca puede reducir su output de manera proporcional preservando su eficiencia
# La eficiencia de Arauca es estable ante cambios proporcionales de los datos

# Variables no discrecionarias
# Variables fijas, sobre las que las unidades a evaluar no tienen control
# pero que de alguna manera afectan su eficiencia



# Holguras
# La maximizaci�n de la segunda etapa puede verse como
# detectar la mejor unidad de referencia

# El DEA en 2 etapas tiene la desventaja de que los resultados var�an con la unidades de medici�n
 # peeero eso se corrije con la funci�n que contiene el no arquimediano
library(Benchmarking)
dosestapas <- dea(input,output,RTS="vrs",ORIENTATION = "out",SLACK = TRUE)
dosestapas$slack
dosestapas$sx
dosestapas$sy


# Desde el punto de vista de la teor�a de la dualidad
# DEA hace la mejor comparaci�n posible entre DMUs

# OUTLIERS

boxplot(data$sali_civil)
boxplot(data$jueces_civil)


scatterplot3d(data$sali_civil, data$jueces_civil)

atipico <- outlier.ap(input,output,NDEL=5)

outlier.ap.plot(atipico$ratio)


# Detecci�n de datos at�picos con nube de datos

x <- with(data, cbind(data$jueces_civil))
y <- with(data, cbind(data$sali_civil))
xy <- cbind(x,y)
D <- det(t(xy)%*%xy)
i <- c(29) # firma o firmas a quitarse
xyi = xy[-i,]
Di <- det( t(xyi) %*% xyi )
Ri <- Di/D
Ri


# La firma 5 (Bogot�) evidencia ser un dato at�pico al tener

# AN�LISIS ESTAD�STICO











