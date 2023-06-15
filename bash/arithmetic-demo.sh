#!/bin/bash
#
# This script demonstrates doing arithmetic.

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read statements instead.
read -p "Enter the first number: " firstNumber
read -p "Enter the second number: " secondNumber
read -p "Enter the third number: " thirdNumber

# Task 2: Change the output to only show the sum and product of the numbers with labels.
sum=$((firstNumber + secondNumber + thirdNumber))
product=$((firstNumber * secondNumber * thirdNumber))

cat <<EOF
Sum: $sum
Product: $product
EOF
