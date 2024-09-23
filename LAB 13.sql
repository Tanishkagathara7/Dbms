---------------------------- LAB 13 -----------------------------------------------------

--Advanced level Joins --



CREATE TABLE City (
    CityID INT PRIMARY KEY,
    Name VARCHAR(100) UNIQUE,
    Pincode INT NOT NULL,
    Remarks VARCHAR(255)
);

CREATE TABLE Village (
    VID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES City(CityID)
);

INSERT INTO City (CityID, Name, Pincode, Remarks) VALUES
(1, 'Rajkot', 360005, 'Good'),
(2, 'Surat', 335009, 'Very Good'),
(3, 'Baroda', 390001, 'Awesome'),
(4, 'Jamnagar', 361003, 'Smart'),
(5, 'Junagadh', 362229, 'Historic'),
(6, 'Morvi', 363641, 'Ceramic');

INSERT INTO Village (VID, Name, CityID) VALUES
(101, 'Raiya', 1),
(102, 'Madhapar', 1),
(103, 'Dodka', 3),
(104, 'Falla', 4),
(105, 'Bhesan', 5),
(106, 'Dhoraji', 5);

--1. Display all the villages of Rajkot city
select village.Name from Village join city on Village.CityID=City.CityID where city.CityID=1; 
--2. Display city along with their villages & pin code.
select village.Name as village,city.Name as city,city.Pincode from Village join city on Village.CityID=City.CityID; 
--3. Display the city having more than one village.
select city.Name,count(village.vid) from Village join city on Village.CityID=City.CityID group by city.Name having count(Village.VID)>1; 
--4. Display the city having no village.
select city.Name,count(village.vid) from city left outer join village on Village.CityID=City.CityID group by city.Name having count(Village.VID)=0;
--5. Count the total number of villages in each city.
select city.Name,count(village.vid) from city left outer join village on Village.CityID=City.CityID group by city.Name
--6. Count the number of cities having more than one village.
select count(city.CityID) from city  right outer join village on Village.CityID=City.CityID group by city.Name having count(village.CityID)>1;
--Create below table with following constraints
--1. Do not allow SPI more than 10
--2. Do not allow Bklog less than 0.
--3. Enter the default value as ‘General’ in branch to all new records IF no other value is specified.
CREATE TABLE STU_MASTER(
RNO INT  PRIMARY KEY,
NAME VARCHAR(50),
BRANCH VARCHAR(50) DEFAULT'GENERAL',
SPI DECIMAL(8,2) CHECK(SPI<=10),
BKLOG DECIMAL(8,2) CHECK(BKLOG>=0)
)
INSERT INTO STU_MASTER VALUES(101,'Raju' ,'CE' ,8.80,0)
INSERT INTO STU_MASTER VALUES(102, 'Amit', 'CE' ,2.20, 3)
INSERT INTO STU_MASTER VALUES(103, 'Sanjay' ,'ME' ,1.50, 6)
INSERT INTO STU_MASTER VALUES(104, 'Neha' ,'EC', 7.65, 0)
INSERT INTO STU_MASTER VALUES(105, 'Meera' ,'EE', 5.52, 2)
INSERT INTO STU_MASTER VALUES(106, 'Mahesh', DEFAULT,4.50, 3)
SELECT *FROM STU_MASTER
--4. Try to update SPI of Raju from 8.80 to 12.
UPDATE STU_MASTER SET SPI=12 WHERE NAME='RAJU' 
--5. Try to update Bklog of Neha from 0 to -1.
UPDATE STU_MASTER SET BKLOG=-1 WHERE NAME='NEHA' 
--Part – B: Create table as per following schema with proper validation and try to insert data which violate your
--validation.
--1. Emp_details(Eid, Ename, Did, Cid, Salary, Experience)
--Dept_details(Did, Dname)
--City_details(Cid, Cname)

-- Creating Dept_details table
CREATE TABLE Dept_details (
    Did INT PRIMARY KEY,
    Dname VARCHAR(50) NOT NULL
);

-- Creating City_details table
CREATE TABLE City_details (
    Cid INT PRIMARY KEY,
    Cname VARCHAR(50) NOT NULL
);

-- Creating Emp_details table
CREATE TABLE Emp_details (
    Eid INT PRIMARY KEY,
    Ename VARCHAR(50) NOT NULL,
    Did INT,
    Cid INT,
    Salary DECIMAL(10, 2) CHECK (Salary > 0), -- Salary should be greater than 0
    Experience INT CHECK (Experience >= 0), -- Experience should not be negative
    FOREIGN KEY (Did) REFERENCES Dept_details(Did),
    FOREIGN KEY (Cid) REFERENCES City_details(Cid)
);

-- Inserting valid data
INSERT INTO Dept_details (Did, Dname) VALUES (1, 'HR');
INSERT INTO Dept_details (Did, Dname) VALUES (2, 'IT');

INSERT INTO City_details (Cid, Cname) VALUES (101, 'New York');
INSERT INTO City_details (Cid, Cname) VALUES (102, 'Los Angeles');

-- Inserting valid employee record
INSERT INTO Emp_details (Eid, Ename, Did, Cid, Salary, Experience)
VALUES (1, 'John Doe', 1, 101, 50000, 5);

-- Inserting invalid employee record (negative salary, violating the salary check constraint)
INSERT INTO Emp_details (Eid, Ename, Did, Cid, Salary, Experience)
VALUES (2, 'Jane Smith', 2, 102, -45000, 4); -- This will violate the salary check constraint

-- Inserting invalid employee record (negative experience, violating the experience check constraint)
INSERT INTO Emp_details (Eid, Ename, Did, Cid, Salary, Experience)
VALUES (3, 'Bob Martin', 1, 101, 35000, -3); -- This will violate the experience check constraint

--Part – C: Create table as per following schema with proper validation and try to insert data which violate your
--validation.
--1. Emp_info(Eid, Ename, Did, Cid, Salary, Experience)
--Dept_info(Did, Dname)
--City_info(Cid, Cname, Did))
--District(Did, Dname, Sid)
--State(Sid, Sname, Cid)
--Country(Cid, Cname)
--2. Insert 5 records in each table.
--3. Display employeename, departmentname, Salary, Experience, City, District, State and country of all
--employees.
-- Table for Country with Cid as the primary key
CREATE TABLE Country (
    Cid INT PRIMARY KEY,
    Cname VARCHAR(50) NOT NULL
);

-- Table for State with Sid as the primary key, and foreign key reference to Country
CREATE TABLE State (
    Sid INT PRIMARY KEY,
    Sname VARCHAR(50) NOT NULL,
    Cid INT,
    FOREIGN KEY (Cid) REFERENCES Country(Cid)
);

-- Table for District with Did as the primary key, and foreign key reference to State
CREATE TABLE District (
    Did INT PRIMARY KEY,
    Dname VARCHAR(50) NOT NULL,
    Sid INT,
    FOREIGN KEY (Sid) REFERENCES State(Sid)
);

-- Table for City_info with Cid as the primary key, and foreign key reference to District
CREATE TABLE City_info (
    Cid INT PRIMARY KEY,
    Cname VARCHAR(50) NOT NULL,
    Did INT,
    FOREIGN KEY (Did) REFERENCES District(Did)
);

-- Table for Dept_info with Did as the primary key
CREATE TABLE Dept_info (
    Did INT PRIMARY KEY,
    Dname VARCHAR(50) NOT NULL
);

-- Table for Emp_info with Eid as the primary key, foreign key references to Dept_info and City_info
CREATE TABLE Emp_info (
    Eid INT PRIMARY KEY,
    Ename VARCHAR(50) NOT NULL,
    Did INT,
    Cid INT,
    Salary DECIMAL(10, 2) CHECK (Salary > 0),
    Experience INT CHECK (Experience >= 0),
    FOREIGN KEY (Did) REFERENCES Dept_info(Did),
    FOREIGN KEY (Cid) REFERENCES City_info(Cid)
);

-- Insert records into Country
INSERT INTO Country (Cid, Cname) VALUES (1, 'USA'), (2, 'India'), (3, 'Germany'), (4, 'Canada'), (5, 'Australia');

-- Insert records into State
INSERT INTO State (Sid, Sname, Cid) VALUES 
(1, 'California', 1), 
(2, 'Maharashtra', 2), 
(3, 'Bavaria', 3), 
(4, 'Ontario', 4), 
(5, 'New South Wales', 5);

-- Insert records into District
INSERT INTO District (Did, Dname, Sid) VALUES 
(1, 'Los Angeles', 1), 
(2, 'Mumbai', 2), 
(3, 'Munich', 3), 
(4, 'Toronto', 4), 
(5, 'Sydney', 5);

-- Insert records into City_info
INSERT INTO City_info (Cid, Cname, Did) VALUES 
(1, 'Los Angeles City', 1), 
(2, 'Mumbai City', 2), 
(3, 'Munich City', 3), 
(4, 'Toronto City', 4), 
(5, 'Sydney City', 5);

-- Insert records into Dept_info
INSERT INTO Dept_info (Did, Dname) VALUES 
(1, 'Engineering'), 
(2, 'HR'), 
(3, 'Marketing'), 
(4, 'Finance'), 
(5, 'IT');

-- Insert records into Emp_info
INSERT INTO Emp_info (Eid, Ename, Did, Cid, Salary, Experience) VALUES 
(101, 'John', 1, 1, 50000, 5), 
(102, 'Amit', 2, 2, 30000, 3), 
(103, 'Sophia', 3, 3, 70000, 7), 
(104, 'Ravi', 4, 4, 45000, 2), 
(105, 'Emily', 5, 5, 60000, 6);

SELECT 
    E.Ename AS EmployeeName, 
    D.Dname AS DepartmentName, 
    E.Salary, 
    E.Experience, 
    C.Cname AS City, 
    Di.Dname AS District, 
    S.Sname AS State, 
    Co.Cname AS Country
FROM 
    Emp_info E
JOIN 
    Dept_info D ON E.Did = D.Did
JOIN 
    City_info C ON E.Cid = C.Cid
JOIN 
    District Di ON C.Did = Di.Did
JOIN 
    State S ON Di.Sid = S.Sid
JOIN 
    Country Co ON S.Cid = Co.Cid;


