#!/bin/bash
#
# This script rolls a pair of dice with a specified number of sides and displays the rolls and summary.

# Task 1:
# Put the number of sides in a variable which is used as the range for the random number
sides=6
# Put the bias, or minimum value for the generated number in another variable
bias=1
# Roll the dice using the variables for the range and bias i.e. RANDOM % range + bias
die1=$(( RANDOM % sides + bias ))
die2=$(( RANDOM % sides + bias ))

# Task 2:
# Generate the sum of the dice
sum=$(( die1 + die2 ))
# Generate the average of the dice
average=$(( (die1 + die2) / 2 ))

# Display the results and summary
echo "Rolling..."
echo "Rolled $die1, $die2"
echo "Sum: $sum"
echo "Average: $average"
