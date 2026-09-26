-- ==========================================
-- ১. ডাটাবেজ তৈরি ও সিলেক্ট
-- ==========================================
DROP DATABASE IF EXISTS university_management_system;
CREATE DATABASE University_Management_System;
USE University_Management_System;

-- ==========================================
-- ২. টেবিল স্ট্রাকচার (DDL)
-- ==========================================

-- ১. Department 
CREATE TABLE Department (
    Dept VARCHAR(20) PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL UNIQUE,
    Building ENUM('New', 'Old') NOT NULL
);

-- ২. Student 
CREATE TABLE Student (
    Student_ID VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(30),
    DOB DATE,
    Batch VARCHAR(20) NOT NULL,
    Dept VARCHAR(20),
    FOREIGN KEY (Dept) REFERENCES Department (Dept) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ৩. Teacher 
CREATE TABLE Teacher (
    Teacher_Initial VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Designation VARCHAR(50) NOT NULL,
    Dept VARCHAR(20),
    FOREIGN KEY (Dept) REFERENCES Department (Dept) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ৪. Course 
CREATE TABLE Course (
    Course_Code VARCHAR(15) PRIMARY KEY,
    Course_Title VARCHAR(100) NOT NULL,
    Credits DECIMAL(3,1) CHECK (Credits > 0),
    Dept VARCHAR(20),
    FOREIGN KEY (Dept) REFERENCES Department (Dept) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ৫. Section 
CREATE TABLE Section (
    Section INT PRIMARY KEY,
    Course_Code VARCHAR(15) NOT NULL,
    Teacher_Initial VARCHAR(10),
    Semester VARCHAR(20) NOT NULL,
    Year INT NOT NULL,
    Room_No VARCHAR(20),
    Capacity INT DEFAULT 40,
    FOREIGN KEY (Course_Code) REFERENCES Course (Course_Code) ON DELETE CASCADE,
    FOREIGN KEY (Teacher_Initial) REFERENCES Teacher (Teacher_Initial) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ৬. Class Schedule 
CREATE TABLE Class_Schedule (
    Schedule_ID INT AUTO_INCREMENT PRIMARY KEY,
    Section INT NOT NULL,
    Day_of_Week ENUM('Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') NOT NULL,
    Start_Time TIME NOT NULL,
    End_Time TIME NOT NULL,
    Room_No VARCHAR(20),
    Batch_Type ENUM('Regular', 'Weekend_Diploma') DEFAULT 'Regular',
    FOREIGN KEY (Section) REFERENCES Section (Section) ON DELETE CASCADE
);

-- ৭. Grading System 
CREATE TABLE Grading_System (
    Grade VARCHAR(2) PRIMARY KEY,
    Min_Marks DECIMAL(5,2) NOT NULL,
    Max_Marks DECIMAL(5,2) NOT NULL,
    Grade_Point DECIMAL(3,2) NOT NULL
);

-- ৮. Enrollment 
CREATE TABLE Enrollment (
    Enrollment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID VARCHAR(20) NOT NULL,
    Section INT NOT NULL,
    Marks DECIMAL(5,2) CHECK (Marks BETWEEN 0 AND 100),
    Grade VARCHAR(2),
    Enroll_Date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (Student_ID) REFERENCES Student (Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Section) REFERENCES Section (Section) ON DELETE CASCADE,
    FOREIGN KEY (Grade) REFERENCES Grading_System (Grade) ON DELETE SET NULL,
    UNIQUE (Student_ID, Section)
);

-- ৯. Attendance 
CREATE TABLE Attendance (
    Attendance_ID INT AUTO_INCREMENT PRIMARY KEY,
    Enrollment_ID INT NOT NULL,
    Class_Date DATE NOT NULL,
    Status ENUM('Present', 'Absent', 'Late') NOT NULL,
    FOREIGN KEY (Enrollment_ID) REFERENCES Enrollment (Enrollment_ID) ON DELETE CASCADE
);

-- ১০. Advising (Preregistration)
CREATE TABLE Advising (
    Advising_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID VARCHAR(20) NOT NULL,
    Section INT NOT NULL,
    Semester VARCHAR(20) NOT NULL,
    Year INT NOT NULL,
    Status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (Student_ID) REFERENCES Student (Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Section) REFERENCES Section (Section) ON DELETE CASCADE
);

-- ১১. Payment 
CREATE TABLE Payment (
    Payment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID VARCHAR(20) NOT NULL,
    Amount DECIMAL(10,2) CHECK (Amount > 0),
    Payment_Date DATE DEFAULT (CURRENT_DATE),
    Status ENUM('Paid', 'Pending', 'Failed') DEFAULT 'Paid',
    FOREIGN KEY (Student_ID) REFERENCES Student (Student_ID) ON DELETE CASCADE
);

-- ১২. Student Ledger 
CREATE TABLE Student_Ledger (
    Ledger_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID VARCHAR(20) NOT NULL,
    Transaction_Date DATE DEFAULT (CURRENT_DATE),
    Description VARCHAR(255) NOT NULL,
    Debit DECIMAL(10,2) DEFAULT 0.00,
    Credit DECIMAL(10,2) DEFAULT 0.00,
    Balance DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Student_ID) REFERENCES Student (Student_ID) ON DELETE CASCADE
);

-- ১৩. Admit Card 
CREATE TABLE Admit_Card (
    Admit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID VARCHAR(20) NOT NULL,
    Exam_Type ENUM('Mid Term', 'Final Examination') NOT NULL,
    Semester VARCHAR(20) NOT NULL,
    Year INT NOT NULL,
    Clearance_Status ENUM('Cleared', 'Blocked_Due_To_Dues') DEFAULT 'Cleared',
    FOREIGN KEY (Student_ID) REFERENCES Student (Student_ID) ON DELETE CASCADE
);

-- ১৪. Academic Calendar 
CREATE TABLE Academic_Calendar (
    Event_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(150) NOT NULL,
    Event_Type ENUM('Exam', 'Holiday', 'Advising', 'Class', 'Event') NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Semester VARCHAR(20) NOT NULL,
    Year INT NOT NULL
);

-- ১৫. Online Application
CREATE TABLE Online_Application (
    App_ID INT AUTO_INCREMENT PRIMARY KEY,
    Student_ID VARCHAR(20) NOT NULL,
    App_Type ENUM(
        'Application for Readmission', 
        'Course Drop Application', 
        'Semester Drop Application', 
        'Application for Course Waiver', 
        'Application for Testimonial', 
        'Application for Incomplete Transcript', 
        'Application for Certificate & Final Transcript', 
        'Application for Original Certificate', 
        'Application for Transfer Academic Program', 
        'Application for Cancel Studentship', 
        'Application for Convocation'
    ) NOT NULL,
    Course_Code VARCHAR(15), 
    Reason TEXT NOT NULL,
    App_Date DATE DEFAULT (CURRENT_DATE),
    Status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (Student_ID) REFERENCES Student (Student_ID) ON DELETE CASCADE,
    FOREIGN KEY (Course_Code) REFERENCES Course (Course_Code) ON DELETE SET NULL
);

-- ==========================================
-- ৩. ডাটা ইনসার্ট (DML)
-- ==========================================

-- Department
INSERT INTO Department VALUES
('CSE', 'Computer Science & Engineering', 'New'),
('ETE', 'Electronics & Telecommunication Engineering', 'Old');

-- Grading System
INSERT INTO Grading_System VALUES
('A+', 80.00, 100.00, 4.00),
('A',  75.00, 79.99,  3.75),
('A-', 70.00, 74.99,  3.50),
('B+', 65.00, 69.99,  3.25),
('B',  60.00, 64.99,  3.00),
('B-', 55.00, 59.99,  2.75),
('C+', 50.00, 54.99,  2.50),
('C',  45.00, 49.99,  2.25),
('D',  40.00, 44.99,  2.00),
('F',   0.00, 39.99,  0.00);

-- Teacher 
INSERT INTO Teacher VALUES
('MHZ', 'Md. Zahid Hossain', 'hossain.zahid@seu.edu.bd', 'Lecturer', 'CSE'),
('SHSH', 'Shoeb Mohammad Shahriar', 'shoeb.shahriar@seu.edu.bd', 'Lecturer', 'CSE'),
('KMU', 'Khandaker Mohammad Mohi Uddin', 'mohiuddin.kh@seu.edu.bd', 'Assistant Professor', 'CSE'),
('BIPA', 'Bidyarthi Paul', 'bidyarthi.paul@seu.edu.bd', 'Lecturer', 'ETE');

-- Course 
INSERT INTO Course VALUES
('CSE363', 'Microprocessor Design & Assembly Language Programming', 3.0, 'CSE'),
('CSE384', 'Database Design Lab', 1.0, 'CSE'),
('CSE365', 'Artificial Intelligence', 3.0, 'CSE'),
('CSE364', 'Microprocessor Design & Assembly Language Programming Lab', 1.0, 'CSE'),
('ETE282', 'Communication Lab', 1.0, 'ETE');

-- Section 
INSERT INTO Section VALUES
(4, 'CSE363', 'MHZ', 'Fall', 2026, '401', 40), 
(12, 'CSE384', 'SHSH', 'Fall', 2026, '402', 40), 
(6, 'CSE365', 'KMU', 'Fall', 2026, '403', 40), 
(5, 'CSE364', 'MHZ', 'Fall', 2026, '404', 40),
(16, 'ETE282', 'BIPA', 'Fall', 2026, '405', 40); 

-- Class Schedule 
INSERT INTO Class_Schedule (Section, Day_of_Week, Start_Time, End_Time, Room_No, Batch_Type) VALUES
-- 🟢 Weekend / Diploma Batch
(4,  'Friday',   '09:00:00', '11:00:00', '401', 'Weekend_Diploma'),
(5,  'Friday',   '11:00:00', '13:00:00', '404', 'Weekend_Diploma'),
(12, 'Friday',   '14:00:00', '16:00:00', '402', 'Weekend_Diploma'),
(6,  'Saturday', '09:00:00', '11:30:00', '403', 'Weekend_Diploma'),
(16, 'Saturday', '14:00:00', '16:00:00', '405', 'Weekend_Diploma'),

-- 🔵 Regular Batch 
(4,  'Sunday',    '10:00:00', '11:30:00', '401', 'Regular'),
(12, 'Monday',    '14:00:00', '16:00:00', '402', 'Regular'),
(6,  'Tuesday',   '11:30:00', '13:00:00', '403', 'Regular'),
(5,  'Wednesday', '09:00:00', '11:00:00', '404', 'Regular'),
(16, 'Thursday',  '11:00:00', '13:00:00', '405', 'Regular');

-- Student 
INSERT INTO Student VALUES
('2024000010006', 'Md Minhaz Uddin', '2024000010006@seu.edu.bd', '+880 1625-043206', '2000-01-01', '19st', 'CSE'),
('2024000010031', 'Hubert Amor Soren', '2024000010031@seu.edu.bd', '+880 1741-257098', '2001-02-02', '19st', 'CSE'),
('2024000010038', 'Md. Gihadul Islam sagor', '2024000010038@seu.edu.bd', '+880 1581-515170', '2001-03-03', '19st', 'CSE');

-- Enrollment
INSERT INTO Enrollment (Student_ID, Section, Marks, Grade) VALUES
('2024000010006', 4, 88.00, 'A+'),
('2024000010006', 12, 85.50, 'A+'),
('2024000010006', 6, 90.00, 'A+'),
('2024000010006', 5, 82.00, 'A+'), 
('2024000010006', 16, 87.00, 'A+'),
('2024000010031', 4, 80.00, 'A+'),
('2024000010031', 12, 84.00, 'A+'),
('2024000010031', 6, 78.00, 'A'),
('2024000010031', 5, 85.00, 'A+'),
('2024000010031', 16, 80.00, 'A+'),
('2024000010038', 4, 85.00, 'A+'),
('2024000010038', 12, 82.00, 'A+'), 
('2024000010038', 6, 86.00, 'A+'),
('2024000010038', 5, 80.00, 'A+'),
('2024000010038', 16, 88.00, 'A+');

-- Payment 
INSERT INTO Payment (Student_ID, Amount, Payment_Date, Status) VALUES
('2024000010006', 45000.00, CURRENT_DATE, 'Paid'),
('2024000010031', 15000.00, CURRENT_DATE, 'Pending'),
('2024000010038', 10000.00, CURRENT_DATE, 'Failed');

-- অন্যান্য মডিউলের ডেটা
INSERT INTO Attendance (Enrollment_ID, Class_Date, Status) VALUES (1, '2026-09-01', 'Present'), (1, '2026-09-03', 'Absent');
INSERT INTO Advising (Student_ID, Section, Semester, Year, Status) VALUES ('2024000010006', 4, 'Fall', 2026, 'Approved');
INSERT INTO Admit_Card (Student_ID, Exam_Type, Semester, Year, Clearance_Status) VALUES ('2024000010006', 'Mid Term', 'Fall', 2026, 'Cleared');
INSERT INTO Student_Ledger (Student_ID, Description, Debit, Credit, Balance) VALUES ('2024000010006', 'Tuition Fee', 45000, 45000, 0);
INSERT INTO Academic_Calendar (Title, Event_Type, Start_Date, End_Date, Semester, Year) VALUES ('Mid Term 2026', 'Exam', '2026-10-10', '2026-10-20', 'Fall', 2026);
INSERT INTO Online_Application (Student_ID, App_Type, Course_Code, Reason, Status) VALUES ('2024000010038', 'Course Drop Application', 'ETE282', 'Time clash with job', 'Pending');

-- ==========================================
-- ৪. মডিউল ভিত্তিক সম্পূর্ণ ৩৫টি কুয়েরি
-- ==========================================

-- 📌 ১. টিচারের আন্ডারে মোট কোর্স ও মোট স্টুডেন্ট সংখ্যা
SELECT 
    t.Name AS Teacher_Name,
    COUNT(DISTINCT s.Course_Code) AS Total_Courses,
    COUNT(DISTINCT e.Student_ID) AS Total_Students
FROM Teacher t
JOIN Section s ON t.Teacher_Initial = s.Teacher_Initial
LEFT JOIN Enrollment e ON s.Section = e.Section
WHERE t.Name = 'Md. Zahid Hossain'
GROUP BY t.Teacher_Initial, t.Name;

-- 📌 ২. স্টুডেন্ট আইডি দিয়ে সে কোন কোন কোর্সে এনরোল করেছে এবং কোর্স টিচার কে তা দেখা
SELECT 
    st.Student_ID,
    st.Name AS Student_Name,
    c.Course_Code,
    c.Course_Title,
    sec.Section,
    t.Name AS Teacher_Name
FROM Student st
JOIN Enrollment e ON st.Student_ID = e.Student_ID
JOIN Section sec ON e.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
LEFT JOIN Teacher t ON sec.Teacher_Initial = t.Teacher_Initial
WHERE st.Student_ID = '2024000010006';

-- 📌 ৩. পেমেন্ট হিস্ট্রি দেখা
SELECT Student_ID, Amount, Payment_Date, Status FROM Payment WHERE Student_ID = '2024000010031';

-- 📌 ৪. ডিপার্টমেন্ট কোড (CSE) দিয়ে মোট স্টুডেন্ট সংখ্যা দেখা
SELECT Dept, COUNT(Student_ID) AS Total_Students FROM Student WHERE Dept = 'CSE' GROUP BY Dept;

-- 📌 ৫. স্টুডেন্টের নির্দিষ্ট ব্যাচ অনুযায়ী ক্লাস রুটিন (যেমন: Weekend_Diploma)
SELECT 
    c.Course_Code, 
    c.Course_Title, 
    cs.Day_of_Week, 
    cs.Start_Time, 
    cs.End_Time, 
    cs.Room_No,
    cs.Batch_Type
FROM Class_Schedule cs
JOIN Section sec ON cs.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
JOIN Enrollment e ON sec.Section = e.Section
WHERE e.Student_ID = '2024000010006' AND cs.Batch_Type = 'Weekend_Diploma'
ORDER BY FIELD(cs.Day_of_Week, 'Friday', 'Saturday');

-- 📌 ৬. স্টুডেন্টের প্রাপ্ত মার্কস, গ্রেড এবং পয়েন্ট
SELECT 
    c.Course_Code,
    c.Credits,
    e.Marks,
    e.Grade,
    gs.Grade_Point
FROM Enrollment e
JOIN Section sec ON e.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
LEFT JOIN Grading_System gs ON e.Grade = gs.Grade
WHERE e.Student_ID = '2024000010038';

-- 📌 ৭. এডমিট কার্ড ক্লিয়ারেন্স স্ট্যাটাস
SELECT Exam_Type, Semester, Year, Clearance_Status FROM Admit_Card WHERE Student_ID = '2024000010006';

-- 📌 ৮. স্টুডেন্ট লেজার (আর্থিক হিসাব)
SELECT Transaction_Date, Description, Debit, Credit, Balance FROM Student_Ledger WHERE Student_ID = '2024000010006';

-- 📌 ৯. অনলাইন অ্যাপ্লিকেশন স্ট্যাটাস
SELECT App_Type, Course_Code, Reason, Status, App_Date FROM Online_Application WHERE Student_ID = '2024000010038';

-- 📌 ১০. অ্যাকাডেমিক ক্যালেন্ডার
SELECT Title, Event_Type, Start_Date, End_Date FROM Academic_Calendar WHERE Semester = 'Fall' AND Year = 2026;

-- 📌 ১১. স্টুডেন্টের CGPA / GPA হিসাব করা (Weighted Average Formula)
SELECT 
    st.Student_ID,
    st.Name AS Student_Name,
    SUM(c.Credits) AS Total_Credits,
    ROUND(SUM(c.Credits * gs.Grade_Point) / SUM(c.Credits), 2) AS CGPA
FROM Student st
JOIN Enrollment e ON st.Student_ID = e.Student_ID
JOIN Section sec ON e.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
JOIN Grading_System gs ON e.Grade = gs.Grade
WHERE st.Student_ID = '2024000010006'
GROUP BY st.Student_ID, st.Name;

-- 📌 ১২. নির্দিষ্ট কোনো কোর্সে (যেমন: CSE363) সর্বোচ্চ নম্বর পাওয়া স্টুডেন্ট (Top Scorer)
SELECT 
    c.Course_Code,
    c.Course_Title,
    st.Student_ID,
    st.Name AS Student_Name,
    e.Marks,
    e.Grade
FROM Enrollment e
JOIN Section sec ON e.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
JOIN Student st ON e.Student_ID = st.Student_ID
WHERE c.Course_Code = 'CSE363'
ORDER BY e.Marks DESC
LIMIT 1;

-- 📌 ১৩. স্টুডেন্টের কোর্সভিত্তিক উপস্থিতির শতকরা হার (Attendance Percentage %)
SELECT 
    st.Student_ID,
    c.Course_Code,
    COUNT(att.Attendance_ID) AS Total_Classes,
    SUM(CASE WHEN att.Status = 'Present' THEN 1 ELSE 0 END) AS Present_Count,
    ROUND((SUM(CASE WHEN att.Status = 'Present' THEN 1 ELSE 0 END) / COUNT(att.Attendance_ID)) * 100, 2) AS Attendance_Percentage
FROM Student st
JOIN Enrollment e ON st.Student_ID = e.Student_ID
JOIN Section sec ON e.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
JOIN Attendance att ON e.Enrollment_ID = att.Enrollment_ID
WHERE st.Student_ID = '2024000010006'
GROUP BY st.Student_ID, c.Course_Code;

-- 📌 ১৪. প্রতিটি শিক্ষক চলতি সেমিস্টারে মোট কত ক্রেডিট পড়াচ্ছেন (Faculty Workload)
SELECT 
    t.Teacher_Initial,
    t.Name AS Teacher_Name,
    COUNT(s.Section) AS Total_Sections,
    SUM(c.Credits) AS Total_Credits_Taught
FROM Teacher t
JOIN Section s ON t.Teacher_Initial = s.Teacher_Initial
JOIN Course c ON s.Course_Code = c.Course_Code
WHERE s.Semester = 'Fall' AND s.Year = 2026
GROUP BY t.Teacher_Initial, t.Name;

-- 📌 ১৫. যাদের পেমেন্ট বকেয়া বা ব্যর্থ (Pending / Failed) তাদের তালিকা (Accounts Audit)
SELECT 
    st.Student_ID,
    st.Name AS Student_Name,
    st.Phone,
    p.Amount,
    p.Status AS Payment_Status
FROM Student st
JOIN Payment p ON st.Student_ID = p.Student_ID
WHERE p.Status IN ('Pending', 'Failed');

-- 📌 ১৬. প্রতিটি কোর্সের গড় মার্কস ও সর্বোচ্চ-সর্বনিম্ন মার্কস (Course Performance Report)
SELECT 
    c.Course_Code,
    c.Course_Title,
    ROUND(AVG(e.Marks), 2) AS Average_Marks,
    MAX(e.Marks) AS Highest_Marks,
    MIN(e.Marks) AS Lowest_Marks
FROM Course c
JOIN Section s ON c.Course_Code = s.Course_Code
JOIN Enrollment e ON s.Section = e.Section
GROUP BY c.Course_Code, c.Course_Title;

-- 📌 ১৭. শুধু ডিপ্লোমা / উইকেন্ড (শুক্রবার ও শনিবার) ব্যাচের রুটিন
SELECT 
    cs.Day_of_Week,
    c.Course_Code,
    c.Course_Title,
    sec.Section,
    cs.Start_Time,
    cs.End_Time,
    cs.Room_No,
    t.Name AS Teacher_Name
FROM Class_Schedule cs
JOIN Section sec ON cs.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
LEFT JOIN Teacher t ON sec.Teacher_Initial = t.Teacher_Initial
WHERE cs.Batch_Type = 'Weekend_Diploma'
ORDER BY FIELD(cs.Day_of_Week, 'Friday', 'Saturday');

-- 📌 ১৮. অ্যাডমিন প্যানেলের জন্য ঝুলন্ত আবেদনের তালিকা (Pending Applications Audit)
SELECT 
    oa.App_ID,
    st.Student_ID,
    st.Name AS Student_Name,
    oa.App_Type,
    oa.Reason,
    oa.App_Date
FROM Online_Application oa
JOIN Student st ON oa.Student_ID = st.Student_ID
WHERE oa.Status = 'Pending';

-- 📌 ১৯. সেকশন ভিত্তিক স্টুডেন্ট সংখ্যা এবং ফাঁকা সিটের হিসাব (Section Capacity vs Enrollment)
SELECT 
    sec.Section,
    sec.Course_Code,
    sec.Capacity AS Total_Capacity,
    COUNT(e.Student_ID) AS Enrolled_Students,
    (sec.Capacity - COUNT(e.Student_ID)) AS Available_Seats
FROM Section sec
LEFT JOIN Enrollment e ON sec.Section = e.Section
GROUP BY sec.Section, sec.Course_Code, sec.Capacity;

-- 📌 ২০. সকল কোর্সে A+ (৪.০০ পয়েন্ট) পাওয়া ট্যালেন্ট স্টুডেন্টদের তালিকা
SELECT DISTINCT
    st.Student_ID,
    st.Name AS Student_Name,
    st.Batch
FROM Student st
JOIN Enrollment e ON st.Student_ID = e.Student_ID
WHERE e.Grade = 'A+';

-- 📌 ২১. নির্দিষ্ট একজন শিক্ষকের (যেমন: MHZ) সপ্তাহের সম্পূর্ণ ক্লাস রুটিন
SELECT 
    t.Name AS Teacher_Name,
    cs.Day_of_Week,
    c.Course_Code,
    c.Course_Title,
    sec.Section,
    cs.Start_Time,
    cs.End_Time,
    cs.Room_No,
    cs.Batch_Type
FROM Teacher t
JOIN Section sec ON t.Teacher_Initial = sec.Teacher_Initial
JOIN Course c ON sec.Course_Code = c.Course_Code
JOIN Class_Schedule cs ON sec.Section = cs.Section
WHERE t.Teacher_Initial = 'MHZ'
ORDER BY FIELD(cs.Day_of_Week, 'Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'), cs.Start_Time;

-- 📌 ২২. নির্দিষ্ট রুমের (যেমন: Room 401) সপ্তাহের সম্পূর্ণ শিডিউল (Room Schedule Report)
SELECT 
    cs.Room_No,
    cs.Day_of_Week,
    cs.Start_Time,
    cs.End_Time,
    c.Course_Code,
    c.Course_Title,
    t.Name AS Teacher_Name,
    cs.Batch_Type
FROM Class_Schedule cs
JOIN Section sec ON cs.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
LEFT JOIN Teacher t ON sec.Teacher_Initial = t.Teacher_Initial
WHERE cs.Room_No = '401'
ORDER BY FIELD(cs.Day_of_Week, 'Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'), cs.Start_Time;

-- 📌 ২৩. যেসব স্টুডেন্টের উপস্থিতি ৭৫% এর কম (পরীক্ষায় বসার অযোগ্য / Shortage of Attendance List)
SELECT 
    st.Student_ID,
    st.Name AS Student_Name,
    c.Course_Code,
    c.Course_Title,
    COUNT(att.Attendance_ID) AS Total_Classes,
    SUM(CASE WHEN att.Status = 'Present' THEN 1 ELSE 0 END) AS Attended_Classes,
    ROUND((SUM(CASE WHEN att.Status = 'Present' THEN 1 ELSE 0 END) / COUNT(att.Attendance_ID)) * 100, 2) AS Attendance_Percentage
FROM Student st
JOIN Enrollment e ON st.Student_ID = e.Student_ID
JOIN Section sec ON e.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
JOIN Attendance att ON e.Enrollment_ID = att.Enrollment_ID
GROUP BY st.Student_ID, st.Name, c.Course_Code, c.Course_Title
HAVING Attendance_Percentage < 75.00;

-- 📌 ২৪. অ্যাডভাইজিং (Pre-registration) এখনও অনুমোদন পায়নি (Pending) এমন স্টুডেন্টদের তালিকা
SELECT 
    adv.Advising_ID,
    st.Student_ID,
    st.Name AS Student_Name,
    c.Course_Code,
    sec.Section,
    adv.Semester,
    adv.Year,
    adv.Status
FROM Advising adv
JOIN Student st ON adv.Student_ID = st.Student_ID
JOIN Section sec ON adv.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
WHERE adv.Status = 'Pending';

-- 📌 ২৫. শুধুমাত্র রেগুলার ব্যাচের (রবিবার-বৃহস্পতিবার) সেকশনভিত্তিক পূর্ণাঙ্গ রুটিন
SELECT 
    cs.Day_of_Week,
    cs.Start_Time,
    cs.End_Time,
    c.Course_Code,
    c.Course_Title,
    sec.Section,
    cs.Room_No,
    t.Name AS Teacher_Name
FROM Class_Schedule cs
JOIN Section sec ON cs.Section = sec.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
LEFT JOIN Teacher t ON sec.Teacher_Initial = t.Teacher_Initial
WHERE cs.Batch_Type = 'Regular'
ORDER BY FIELD(cs.Day_of_Week, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'), cs.Start_Time;

-- 📌 ২৬. কোর্স ড্রপ করার আবেদন করেছে এমন স্টুডেন্টদের তালিকা ও কারণ (Course Drop Application List)
SELECT 
    st.Student_ID,
    st.Name AS Student_Name,
    st.Phone,
    oa.Course_Code,
    c.Course_Title,
    oa.Reason,
    oa.App_Date,
    oa.Status
FROM Online_Application oa
JOIN Student st ON oa.Student_ID = st.Student_ID
LEFT JOIN Course c ON oa.Course_Code = c.Course_Code
WHERE oa.App_Type = 'Course Drop Application';

-- 📌 ২৭. কোন কোর্সে কতজন স্টুডেন্ট ফেল করেছে (F Grade)
SELECT 
    c.Course_Code,
    c.Course_Title,
    COUNT(e.Student_ID) AS Total_Failed_Students
FROM Course c
JOIN Section sec ON c.Course_Code = sec.Course_Code
JOIN Enrollment e ON sec.Section = e.Section
WHERE e.Grade = 'F'
GROUP BY c.Course_Code, c.Course_Title;

-- 📌 ২৮. ডিপার্টমেন্ট অনুযায়ী সকল ফ্যাকাল্টি মেম্বারদের তালিকা ও পদবী
SELECT 
    t.Dept,
    t.Teacher_Initial,
    t.Name AS Teacher_Name,
    t.Designation,
    t.Email
FROM Teacher t
ORDER BY t.Dept, FIELD(t.Designation, 'Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer');

-- 📌 ২৯. সবচেয়ে বেশি বকেয়া টাকা থাকা স্টুডেন্টদের তালিকা (Student Ledger Balance Audit)
SELECT 
    sl.Student_ID,
    st.Name AS Student_Name,
    st.Phone,
    sl.Debit AS Total_Fee,
    sl.Credit AS Paid_Amount,
    sl.Balance AS Outstanding_Balance
FROM Student_Ledger sl
JOIN Student st ON sl.Student_ID = st.Student_ID
WHERE sl.Balance > 0
ORDER BY sl.Balance DESC;

-- 📌 ৩০. বকেয়ার কারণে যাদের এডমিট কার্ড ব্লক হয়ে আছে (Blocked Admit Card List)
SELECT 
    ac.Student_ID,
    st.Name AS Student_Name,
    st.Phone,
    ac.Exam_Type,
    ac.Semester,
    ac.Year,
    ac.Clearance_Status
FROM Admit_Card ac
JOIN Student st ON ac.Student_ID = st.Student_ID
WHERE ac.Clearance_Status = 'Blocked_Due_To_Dues';

-- 📌 ৩১. নির্দিষ্ট একটি কোর্সের (যেমন: CSE363) গ্রেড বন্টন (Grade Distribution Breakdown)
SELECT 
    e.Grade,
    COUNT(e.Student_ID) AS Total_Students
FROM Enrollment e
JOIN Section sec ON e.Section = sec.Section
WHERE sec.Course_Code = 'CSE363'
GROUP BY e.Grade
ORDER BY FIELD(e.Grade, 'A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'D', 'F');

-- 📌 ৩২. যেসব সেকশনে এখনও কোনো শিক্ষক অ্যাসাইন করা হয়নি (Unassigned Teacher Check)
SELECT 
    sec.Section,
    sec.Course_Code,
    c.Course_Title,
    sec.Semester,
    sec.Year,
    sec.Room_No
FROM Section sec
JOIN Course c ON sec.Course_Code = c.Course_Code
WHERE sec.Teacher_Initial IS NULL;

-- 📌 ৩৩. ব্যাচ ভিত্তিক মোট স্টুডেন্ট সংখ্যা
SELECT 
    Batch,
    COUNT(Student_ID) AS Total_Students
FROM Student
GROUP BY Batch;

-- 📌 ৩৪. কোনো নির্দিষ্ট স্টুডেন্টের নির্দিষ্ট দিনের (যেমন: শুক্রবার) ক্লাস শিডিউল
SELECT 
    st.Student_ID,
    st.Name AS Student_Name,
    cs.Day_of_Week,
    cs.Start_Time,
    cs.End_Time,
    c.Course_Code,
    c.Course_Title,
    cs.Room_No,
    t.Name AS Teacher_Name
FROM Student st
JOIN Enrollment e ON st.Student_ID = e.Student_ID
JOIN Section sec ON e.Section = sec.Section
JOIN Class_Schedule cs ON sec.Section = cs.Section
JOIN Course c ON sec.Course_Code = c.Course_Code
LEFT JOIN Teacher t ON sec.Teacher_Initial = t.Teacher_Initial
WHERE st.Student_ID = '2024000010006' AND cs.Day_of_Week = 'Friday'
ORDER BY cs.Start_Time;

-- 📌 ৩৫. অনলাইন আবেদনের ধরন অনুযায়ী মোট আবেদন ও তাদের বর্তমান স্ট্যাটাস
SELECT 
    App_Type,
    Status,
    COUNT(App_ID) AS Total_Applications
FROM Online_Application
GROUP BY App_Type, Status
ORDER BY App_Type;