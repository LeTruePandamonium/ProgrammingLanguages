# 08 Laboratory Exercise 1
# Submitted by: Kurt Allen Alfonso

# Function 1

def add_to_stock(stock_list):
    stock_list.append(75)
    print("Inside function (stock):", stock_list);

inventory = [100, 200, 150]
add_to_stock(inventory)
print("Outside function (stock):", inventory)

print()

# Function 2

def update_price(price):
    new_price = price + (price * 0.10)
    print("Inside function(price):", new_price)

base_price = 250.0
update_price(base_price)
print("Outside function(price):", base_price)