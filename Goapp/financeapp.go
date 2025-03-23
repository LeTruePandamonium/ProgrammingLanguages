package main

import (
	"fmt"
	"log"
	"time"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

// Expense represents an expense record
type Expense struct {
	ID       uint      `gorm:"primaryKey"`
	Amount   float64   `gorm:"not null"`
	Category string    `gorm:"not null"`
	Date     time.Time `gorm:"not null"`
	Note     string
}

// Initialize Database
func InitDB() *gorm.DB {
	db, err := gorm.Open(sqlite.Open("expenses.db"), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to the database:", err)
	}
	db.AutoMigrate(&Expense{})
	return db
}

// CompareExpenses generates a bar chart comparing total expenses by category
func CompareExpenses(db *gorm.DB) {
	var results []struct {
		Category string
		Total    float64
	}

	// Sum expenses per category
	db.Model(&Expense{}).
		Select("category, SUM(amount) as total").
		Group("category").
		Scan(&results)

	if len(results) == 0 {
		fmt.Println("No expenses recorded.")
		return
	}

	// Find the max expense to normalize bar lengths
	maxExpense := 0.0
	for _, result := range results {
		if result.Total > maxExpense {
			maxExpense = result.Total
		}
	}

	// Print bar chart
	fmt.Println("\nExpense Comparison by Category:")
	for _, result := range results {
		barLength := int((result.Total / maxExpense) * 30) // Scale bars (max width 30)
		fmt.Printf("%-12s | %s (%.2f)\n", result.Category, stringRepeat("#", barLength), result.Total)
	}
}

// Utility function to repeat a character
func stringRepeat(char string, count int) string {
	result := ""
	for i := 0; i < count; i++ {
		result += char
	}
	return result
}

func main() {
	db := InitDB()

	for {
		var choice int
		fmt.Println("\nExpense Manager:")
		fmt.Println("1. Add Expense")
		fmt.Println("2. View All Expenses")
		fmt.Println("3. Compare Expenses (Bar Chart)")
		fmt.Println("4. Exit")
		fmt.Print("Enter choice: ")
		fmt.Scanln(&choice)

		switch choice {
		case 1:
			var amount float64
			var category, note string
			fmt.Print("Enter amount: ")
			fmt.Scanln(&amount)
			fmt.Print("Enter category: ")
			fmt.Scanln(&category)
			fmt.Print("Enter a note (optional): ")
			fmt.Scanln(&note)
			db.Create(&Expense{Amount: amount, Category: category, Date: time.Now(), Note: note})
			fmt.Println("Expense added successfully!")
		case 2:
			var expenses []Expense
			db.Order("date DESC").Find(&expenses)
			fmt.Println("\nExpenses List:")
			for _, e := range expenses {
				fmt.Printf("ID: %d | Amount: %.2f | Category: %s | Date: %s | Note: %s\n",
					e.ID, e.Amount, e.Category, e.Date.Format("2006-01-02"), e.Note)
			}
		case 3:
			CompareExpenses(db)
		case 4:
			fmt.Println("Exiting program...")
			return
		default:
			fmt.Println("Invalid choice. Try again.")
		}
	}
}
