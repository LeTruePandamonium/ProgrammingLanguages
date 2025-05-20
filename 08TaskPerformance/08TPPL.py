# 08 Task Performance
# Submitted by: kurt Allen Alfonso

def session_counter():
    counter = 0  # Initialize local counter
    counter += 1
    print(f"Visits: {counter}")

def kiosk_usage():
    if not hasattr(kiosk_usage, 'total_users'):
        kiosk_usage.total_users = 0
    kiosk_usage.total_users += 1
    print(f"Total uses: {kiosk_usage.total_users}")
    
print(" <=== Kiosk Simulation ===> ")
print("======================")

for customer in range(3):
    print(f"\nCustomer {customer} session:")
    
    print("Session Counter:")
    for _ in range(5):
        session_counter()
        
    print("\nKiosk usage tracker:")
    kiosk_usage()
    
print("\n=== End of Simulation ===")