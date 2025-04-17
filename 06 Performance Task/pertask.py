print("<==========================>")
print("06 Performance Task")
print("<==========================>")
print(" ")

totalCost = float(0.00)
predefBudget = float(150000)
try:
    venueCost = float(input("Estimated cost of Venue: "))
    caterCost = float(input("Estimated cost of Catering: "))
    decorCost = float(input("Estimated cost of Decorations: "))
    entCost = float(input("Estimated cost of Entertainment: "))
    miscCost = float(input("Estimated cost of Miscellaneous: "))
except ValueError:
    print("Invalid input, please make sure to enter a number")
    exit()
print(f"\nEstimated cost of:\n Venue: ₱{venueCost:.2f}\n Catering: ₱{caterCost:.2f}\n Decorations: ₱{decorCost:.2f}\n Entertainment: ₱{entCost:.2f}\n Miscellaneous: ₱{miscCost:.2f}")
totalCost = venueCost + caterCost + decorCost + entCost + miscCost
print(f"\nTotal Estimated Cost: ₱{totalCost:.2f}")
print(f"Predefined Budget: ₱{predefBudget:.2f}")

if (totalCost <= predefBudget):
    print("Total Estimated Cost is within the predefined budget.")
else:
    print("Total Estimated Cost surpasses the predefined budget, please reconsider your budgeting.")