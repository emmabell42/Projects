library(viridis)
numbers <- read_csv(file = "Documents/numbers.csv", col_names = TRUE)
number.cols <- plasma(n = 100)
numbers <- add_column(.data = numbers, Colours = number.cols)
numbers <- numbers[order(numbers$String),]
xlab <- "Alphabetic Order!"
ylab <- "Numeric Order!"
main <- "Numbers! Order! Numbers!"
plot(x = 1:100, y = numbers$Numeric, col = numbers$Colours, pch = 19, xlab = xlab, ylab = ylab, main = main)
m.text <- expression(paste("Spearman's ", rho, " = -0.34, P = 0.0006"))
mtext(text = m.text, side = 3, line = 0.2, at = 50)
