#!/bin/bash
# This script creates the reminder app and all the files needed to make it work.

# Request the uuser to enter their name and create a directory with the input name.
read -p "Enter your name: " name;
mkdir submission_reminder_$name;
cd submission_reminder_$name;

# Create the directories that will hold different files for the reminder app.
mkdir app modules assets config

# Create each file, with its correct path and put its respective contents into the created files.
cat > app/reminder.sh << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

cat > modules/functions.sh << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

cat > assets/submissions.txt << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Kelvin, Shell Navigation, submitted
Samuel, Git, not submitted
Aaron, Shell Navigation, not submitted
John, Shell Basics, not submitted
Daniel, Shell Navigation, not submitted
EOF

cat > config/config.env << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

cat > startup.sh << 'EOF'
#!/bin/bash
cd app/
./reminder.sh
EOF

# Make all your created files executable.
chmod +x app/reminder.sh modules/functions.sh assets/submissions.txt config/config.env startup.sh

# Display a message for a successful code execution.
echo "Environment successfully created."
