use strict;
use warnings;
use DBI;
use File::HomeDir;

# Database setup
my $db_file = File::HomeDir->my_home . "/todo_list.db";
my $dbh = DBI->connect("dbi:SQLite:dbname=$db_file","","",{ RaiseError => 1, AutoCommit => 1 });

# Create table if not exists
$dbh->do("CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, task TEXT, done INTEGER, due_date TEXT)");

sub show_menu {
    print "\n=== To-Do List ===\n";
    print "1. Add Task\n";
    print "2. List Tasks\n";
    print "3. Mark Task as Done (Auto-Delete)\n";
    print "4. Export Calendar (.ics)\n";
    print "5. Exit\n";
    print "Select an option: ";
}

sub add_task {
    print "Enter task description: ";
    chomp(my $task = <STDIN>);
    return if $task eq '';

    print "Enter due date (YYYY/MM/DD, or press enter to skip): ";
    chomp(my $due_date = <STDIN>);
    
    # Validate input format
    if ($due_date && $due_date !~ /^\d{4}\/\d{2}\/\d{2}$/) {
        print "Invalid date format! Please use YYYY/MM/DD.\n";
        return;
    }

    $due_date ||= "2025/03/21";  # Default date if empty

    $dbh->do("INSERT INTO tasks (task, done, due_date) VALUES (?, 0, ?)", undef, $task, $due_date);
    print "Task added!\n";
}

sub list_tasks {
    my $sth = $dbh->prepare("SELECT id, task, done, due_date FROM tasks ORDER BY done ASC, id ASC");
    $sth->execute();

    print "\n ID  | Status | Task                          | Due Date\n";
    print "-----------------------------------------------------------\n";
    while (my ($id, $task, $done, $due_date) = $sth->fetchrow_array) {
        my $status = $done ? "[✓]" : "[ ]";
        $due_date = $due_date ? $due_date : "No Due Date";  # Handle empty date case
        printf(" %-4s | %-6s | %-30s | %s\n", $id, $status, $task, $due_date);
    }
}

sub mark_done {
    print "Enter Task ID to mark as done (will be deleted): ";
    chomp(my $id = <STDIN>);

    # Delete task after marking as done
    my $rows_deleted = $dbh->do("DELETE FROM tasks WHERE id = ?", undef, $id);
    
    if ($rows_deleted) {
        print "Task marked as done and deleted!\n";
    } else {
        print "Task ID not found.\n";
    }
}

sub generate_ics {
    my $ics_path = File::HomeDir->my_home . "/tasks.ics";
    open(my $fh, ">", $ics_path) or die "Could not create ICS file: $!";

    print $fh "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//ToDoApp//EN\n";

    my $sth = $dbh->prepare("SELECT task, due_date FROM tasks WHERE done = 0");
    $sth->execute();

    while (my ($task, $due_date) = $sth->fetchrow_array) {
        # Convert YYYY/MM/DD to YYYYMMDD for ICS format
        my $ics_date = $due_date;
        $ics_date =~ s/\///g;  # Remove slashes
        print $fh "BEGIN:VEVENT\n";
        print $fh "SUMMARY:$task\n";
        print $fh "DTSTART:${ics_date}T000000Z\n";
        print $fh "END:VEVENT\n";
    }

    print $fh "END:VCALENDAR\n";
    close($fh);

    print "Calendar exported! File saved at: $ics_path\n";
}

# Main Loop
while (1) {
    show_menu();
    chomp(my $choice = <STDIN>);
    if    ($choice == 1) { add_task(); }
    elsif ($choice == 2) { list_tasks(); }
    elsif ($choice == 3) { mark_done(); }
    elsif ($choice == 4) { generate_ics(); }
    elsif ($choice == 5) { last; }
    else  { print "Invalid option, try again.\n"; }
}
