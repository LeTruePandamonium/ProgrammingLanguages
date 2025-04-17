print("<==========================>")
print("05 Laboratory Exercise 1")
print("<==========================>")
print(" ")

startLoc = input("What is your starting location: ")
targetDest = input("What is your target destination: ")
transMode = input("What is your mode of transport: ")
distance = float(input("Total distance of your travel(km): "))
speed = float(input("Speed of travel(km/h): "))
travTime = float(0.00)

travTime = distance / speed
recRest = travTime > 5

print(f"Travel Time: {travTime:.2f} hours")

if recRest:
    print("The trip is gonna take more than 5 hours, stopping on a rest stop is highly recommended")
else:
    print("No stop needed, have a safe trip and go pedal to the metal")
