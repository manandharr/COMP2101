#!/bin/bash
# This script produces a dynamic welcome message.
# It should look like: "Welcome to planet hostname, title name!"

# Task 1: Use the variable $USER instead of the myname variable to get your name
name="$USER"

# Task 2: Dynamically generate the value for your hostname variable using the hostname command
hostName="$(hostname)"

# Task 3: Add the time and day of the week to the welcome message
currentTime="$(date +"%I:%M %p")"
currentDay="$(date +"%A")"
welcomeMessage="It is $currentDay at $currentTime."

# Task 4: Set the title using the day of the week
case "$currentDay" in
  Monday)
    title="Master of the Week"
    ;;
  Tuesday)
    title="Captain of Fortune"
    ;;
  Wednesday)
    title="Sultan of Serendipity"
    ;;
  Thursday)
    title="Emperor of Enthusiasm"
    ;;
  Friday)
    title="Guru of Good Vibes"
    ;;
  Saturday)
    title="Champion of Cheerfulness"
    ;;
  Sunday)
    title="Ruler of Relaxation"
    ;;
  *)
    title="Visitor of the Unknown"
    ;;
esac

# Store the welcome message with the dynamic values in a variable
welcomeMessage="Welcome to planet $hostName, $title $name!\n$welcomeMessage"

# Display the welcome message using cowsay
echo -e "$welcomeMessage" | cowsay
