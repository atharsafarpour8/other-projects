library(neuralnet)
data <- read.csv(file.choose(), header = TRUE)

normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}
data_norm <- as.data.frame(lapply(data, normalize))
set.seed(42)
nn <- neuralnet(lmr ~ Day,
                data = data_norm,
                hidden = c(5),   # Two hidden layers: 5 and 3 neurons
                linear.output = TRUE,
                threshold = 0.01,
                stepmax = 1e6)

pred <- compute(nn, data.frame(Day = data_norm$Day))
predicted <- pred$net.result

(mse <- mean((data_norm$lmr - predicted)^2))
plot(data_norm[,1],data_norm[,2])
par(new=TRUE)

plot(data_norm[,1],predicted,col=2)

plot(nn)

#............This part of the code is to use MARS to determine the knots.........
#.........................................
#................MARS Fitting.............
#.........................................

library(earth)

par(new=TRUE)
fitmars<-earth(data$Day,data$lmr,nk=40,minspan=1)#try minspan-2

plot(data$Day,predict(fitmars,data$Day),col=4)

fittedvalues<-predict(fitmars) 
plot(y,(fittedvalues) )
abline(a = 0, b = 1, col = "red", lwd = 2)  # y = x