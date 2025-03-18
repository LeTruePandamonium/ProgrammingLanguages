first_name = "Kurt Allen"
age = 20

quiz_score = 20  # Initial integer value
MAX_SCORE = 30
PASSING_SCORE = 22.5

#Boolean to determine if user passed or not
quiz_passed = True
quiz_failed = False
quiz_not_taken = None

#Rebinded integer value to a float value because the 75% of MAX_SCORE (30) = 22.5
#quiz_score = 22.5  
#quiz_score = 20
quiz_score = None

#Checks if quiz_score is None, if its less than the passing score or if its equal or greater than the passing score
if quiz_score is None:  
    quiz_status = quiz_not_taken
    quiz_result = "not taken"
elif quiz_score < PASSING_SCORE:
    quiz_status = quiz_failed
    quiz_result = "failed"
else:
    quiz_status = quiz_passed
    quiz_result = "passed"

# Display student info
print("Student Name:", first_name)
print("Age:", age)
print("Quiz Status:", quiz_result)
