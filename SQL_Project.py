import pymysql

print("Program Started")

try:
    conn = pymysql.connect(
        host="localhost",
        user="root",
        password="22222222",
        database="student_performance"
    )

    print("Connected successfully!")

    cursor = conn.cursor()

    while True:
        print("\n===== MENU =====")
        print("1. Top 5 Students")
        print("2. Low Attendance Students")
        print("3. View All Students")
        print("4. Export Data to CSV")
        print("5. Top Performing Student")
        print("6. Students Above Average Marks")
        print("7. Attendance Report")
        print("8. Exit")

        choice = input("Enter your choice: ")

        if choice == '1':
            cursor.execute("""
            SELECT s.name, m.marks
            FROM Students s
            JOIN Marks m ON s.student_id = m.student_id
            ORDER BY m.marks DESC
            LIMIT 5;
            """)
            for row in cursor.fetchall():
                print("Name:", row[0], "| Marks:", row[1])

        elif choice == '2':
            cursor.execute("""
            SELECT s.name, a.attendance_percentage
            FROM Students s
            JOIN Attendance a ON s.student_id = a.student_id
            WHERE a.attendance_percentage < 75;
            """)
            for row in cursor.fetchall():
                print("Name:", row[0], "| Attendance:", row[1])

        elif choice == '3':
            cursor.execute("SELECT * FROM Students;")
            for row in cursor.fetchall():
                print(row)

        elif choice == '4':
            import csv

            cursor.execute("""
            SELECT s.name, m.marks, a.attendance_percentage
            FROM Students s
            JOIN Marks m ON s.student_id = m.student_id
            JOIN Attendance a ON s.student_id = a.student_id;
            """)

            data = cursor.fetchall()

            with open("student_report.csv", "w", newline="") as file:
                writer = csv.writer(file)
                writer.writerow(["Name", "Marks", "Attendance"])
                writer.writerows(data)

            print("CSV file created successfully!")

        elif choice == '5':
            cursor.execute("""
            SELECT s.name, m.marks
            FROM Students s
            JOIN Marks m ON s.student_id = m.student_id
            ORDER BY m.marks DESC
            LIMIT 1;
            """)
            for row in cursor.fetchall():
                print("Top Student:", row[0], "| Marks:", row[1])

        elif choice == '6':
            cursor.execute("""
            SELECT s.name, m.marks
            FROM Students s
            JOIN Marks m ON s.student_id = m.student_id
            WHERE m.marks > (SELECT AVG(marks) FROM Marks);
            """)
            for row in cursor.fetchall():
                print("Name:", row[0], "| Marks:", row[1])

        elif choice == '7':
            cursor.execute("""
            SELECT s.name,
            CASE 
                WHEN a.attendance_percentage >= 75 THEN 'Good'
                ELSE 'Low'
            END AS status
            FROM Students s
            JOIN Attendance a ON s.student_id = a.student_id;
            """)
            for row in cursor.fetchall():
                print("Name:", row[0], "| Status:", row[1])

        elif choice == '8':
            print("Exiting program...")
            break

        else:
            print("Invalid choice!")

except Exception as e:
    print("Error:", e)

finally:
    if 'conn' in locals():
        conn.close()
        print("\nConnection Closed")

print("Program Finished")