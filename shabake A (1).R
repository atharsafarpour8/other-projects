
library(neuralnet)


data <- read.csv(file.choose(), header = TRUE, sep = ",", dec = ".")
normalize <- function(x) (x - min(x)) / (max(x) - min(x))
data_norm <- as.data.frame(lapply(data, normalize))


set.seed(42)
nn <- neuralnet(y ~ x, data = data_norm, hidden = c(20,10),
                linear.output = TRUE, threshold = 0.01, stepmax = 1e6)

pred <- compute(nn, data.frame(x = data_norm$x))
predicted <- pred$net.result * (max(data$y) - min(data$y)) + min(data$y)

mse <- mean((data$y - predicted)^2)
r2  <- cor(data$y, predicted)^2

cat("لایه مخفی:  نورون\n")
cat("MSE =", round(mse, 6), "\n")
cat("R²  =", round(r2, 4), "\n")

# نمودار
plot(data$x, data$y, col = "blue", pch = 16, xlab = "x", ylab = "y")
points(data$x, predicted, col = "red", pch = 16)
plot(nn)