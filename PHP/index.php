<?php
// Connect to SQLite database
$db = new SQLite3('expenses.db');

// Create table if not exists
$db->exec("CREATE TABLE IF NOT EXISTS expenses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    amount REAL,
    category TEXT,
    description TEXT,
    date TEXT
)");

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $amount = $_POST['amount'];
    $category = $_POST['category'];
    $description = $_POST['description'];
    $date = $_POST['date'];
    
    $stmt = $db->prepare("INSERT INTO expenses (amount, category, description, date) VALUES (?, ?, ?, ?)");
    $stmt->bindValue(1, $amount, SQLITE3_FLOAT);
    $stmt->bindValue(2, $category, SQLITE3_TEXT);
    $stmt->bindValue(3, $description, SQLITE3_TEXT);
    $stmt->bindValue(4, $date, SQLITE3_TEXT);
    $stmt->execute();
    header("Location: ". $_SERVER['PHP_SELF']);
    exit;
}

// Fetch all expenses
$result = $db->query("SELECT * FROM expenses ORDER BY date DESC");
$expenses = [];
while ($row = $result->fetchArray(SQLITE3_ASSOC)) {
    $expenses[] = $row;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Manager</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; gap: 20px; }
        .container { display: flex; width: 100%; }
        .left, .right { width: 50%; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid black; padding: 8px; text-align: left; }
        .hidden { display: none; }
    </style>
</head>
<body>
    <div class="container">
        <div class="left">
            <h2>Add Expense</h2>
            <form method="POST">
                <label>Amount:</label>
                <input type="number" step="0.01" name="amount" required><br>
                <label>Category:</label>
                <input type="text" name="category" required><br>
                <label>Description:</label>
                <input type="text" name="description"><br>
                <label>Date:</label>
                <input type="date" name="date" required><br>
                <button type="submit">Save Expense</button>
            </form>
        </div>
        <div class="right">
            <h2>Expense List</h2>
            <table>
                <thead>
                    <tr>
                        <th>Amount</th>
                        <th>Category</th>
                        <th>Description</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody id="expenseTable">
                    <?php foreach ($expenses as $expense): ?>
                        <tr>
                            <td>₱<?= number_format($expense['amount'], 2) ?></td>
                            <td><?= $expense['category'] ?></td>
                            <td><?= $expense['description'] ?></td>
                            <td><?= $expense['date'] ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>

            <h2>Compare Expenses</h2>
            <label>Filter by:</label>
            <select id="filter">
                <option value="date">Date</option>
                <option value="category">Category</option>
                <option value="amount">Amount</option>
            </select>

            <div id="dateFilters" class="hidden">
                <label>Year:</label>
                <input type="number" id="yearFilter" min="2000" max="2100" placeholder="YYYY">
                <label>Month:</label>
                <select id="monthFilter">
                    <option value="">All</option>
                    <option value="01">January</option>
                    <option value="02">February</option>
                    <option value="03">March</option>
                    <option value="04">April</option>
                    <option value="05">May</option>
                    <option value="06">June</option>
                    <option value="07">July</option>
                    <option value="08">August</option>
                    <option value="09">September</option>
                    <option value="10">October</option>
                    <option value="11">November</option>
                    <option value="12">December</option>
                </select>
            </div>

            <table id="comparisonTable">
                <thead>
                    <tr>
                        <th>Filter Type</th>
                        <th>Amount</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <script>
        const expenses = <?php echo json_encode($expenses); ?>;

        document.getElementById("filter").addEventListener("change", function() {
            const filterType = this.value;
            const dateFilters = document.getElementById("dateFilters");

            if (filterType === "date") {
                dateFilters.classList.remove("hidden");
            } else {
                dateFilters.classList.add("hidden");
            }

            filterExpenses();
        });

        document.getElementById("yearFilter").addEventListener("input", filterExpenses);
        document.getElementById("monthFilter").addEventListener("change", filterExpenses);

        function filterExpenses() {
            const filterType = document.getElementById("filter").value;
            const filteredData = {};
            
            const year = document.getElementById("yearFilter").value;
            const month = document.getElementById("monthFilter").value;

            expenses.forEach(exp => {
                let key;

                if (filterType === "date") {
                    let [expYear, expMonth] = exp.date.split("-").slice(0, 2);
                    
                    if (year && expYear !== year) return;
                    if (month && expMonth !== month) return;

                    key = year && month ? `${year}-${month}` :
                          year ? year : 
                          month ? month : exp.date;
                } else {
                    key = exp[filterType];
                }

                if (!filteredData[key]) filteredData[key] = 0;
                filteredData[key] += parseFloat(exp.amount);
            });

            updateComparisonTable(filteredData);
        }

        function updateComparisonTable(data) {
            const tbody = document.querySelector("#comparisonTable tbody");
            tbody.innerHTML = "";
            
            for (const key in data) {
                let row = `<tr><td>${key}</td><td>₱${data[key].toFixed(2)}</td></tr>`;
                tbody.innerHTML += row;
            }
        }
    </script>
</body>
</html>
