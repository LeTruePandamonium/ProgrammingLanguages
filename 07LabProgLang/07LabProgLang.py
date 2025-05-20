# 07 Laboratory Exercise 
# Submitted by Kurt Allen Alfonso
# Instruction: Choose two tasks based on a control structure
# Tasks chosen are tasks: Tasks B and Task D


# Task B


print("Please enter a number: ")
number = int(input())

if (number > 0) :
    print(f"{number} is positive")
elif (number < 0):
    print(f"{number} is negative")
else :
    print(f"{number} is zero")


# Task D

correctpass = "admin123"

for i in range(3):
    upass = input("Please enter the password: ")
    
    if upass == correctpass:
        print("Login Successful")
        break;
    
else:
    print("Access Denied")