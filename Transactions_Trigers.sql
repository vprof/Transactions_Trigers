/*2*/
CREATE DATABASE MyFunkDB;
USE MyFunkDB;

/*3*/
CREATE TABLE Employees (
  EmployeeID INT PRIMARY KEY,
  FName VARCHAR(50) NOT NULL,
  LName VARCHAR(50) NOT NULL,
  Phone VARCHAR(12) NOT NULL
);

CREATE TABLE Salary (
  EmployeeID INT PRIMARY KEY,
  Position VARCHAR(50) NOT NULL,
  Salary DECIMAL(10, 2) NOT NULL
);

CREATE TABLE PersonalInfo (
  EmployeeID INT PRIMARY KEY,
  DateOfBirth DATE NOT NULL,
  MaritalStatus VARCHAR(20) NOT NULL,
  Address VARCHAR(100) NOT NULL
);

/*4*/

DELIMITER //

CREATE PROCEDURE insert_employee(
  IN emp_id INT, 
  IN fname VARCHAR(50), 
  IN lname VARCHAR(50), 
  IN phone VARCHAR(12), 
  IN position VARCHAR(50), 
  IN salary DECIMAL(10, 2), 
  IN dob DATE, 
  IN marital_status VARCHAR(20), 
  IN address VARCHAR(100)
)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      ROLLBACK;
    END;
  
  START TRANSACTION;
  
  SELECT COUNT(*) INTO @emp_count FROM Employees WHERE EmployeeID = emp_id;
  
  IF (@emp_count = 0) THEN
    INSERT INTO Employees (EmployeeID, FName, LName, Phone) VALUES (emp_id, fname, lname, phone);
    INSERT INTO Salary (EmployeeID, Position, Salary) VALUES (emp_id, position, salary);
    INSERT INTO PersonalInfo (EmployeeID, DateOfBirth, MaritalStatus, Address) VALUES (emp_id, dob, marital_status, address);
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee already exists.';
  END IF;
  
  COMMIT;
END;

/*5*/

CREATE TRIGGER delete_employee_data
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
  DELETE FROM Salary WHERE EmployeeID = OLD.EmployeeID;
  DELETE FROM PersonalInfo WHERE EmployeeID = OLD.EmployeeID;
END;

/*6*/
/*Щоб видалити таблицю Customers, потрібно виконати наступний запит:*/
DROP TABLE IF EXISTS customers;

/*Щоб створити таблицю Customers без первинного ключа, потрібно видалити рядок PRIMARY KEY (CustomerNo) із опису таблиці:*/
CREATE TABLE `customers` (
  `CustomerNo` int NOT NULL AUTO_INCREMENT,
  `FName` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LName` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MName` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Address1` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Address2` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `City` char(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Phone` char(12) NOT NULL,
  `DateInSystem` date DEFAULT NULL,
  KEY `idx_customer_no` (`CustomerNo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Потім можна додати інші індекси за допомогою команди ALTER TABLE. Наприклад, щоб додати індекс на поле Phone, можна виконати наступний запит:*/
ALTER TABLE `customers` ADD INDEX `idx_phone` (`Phone`);

/*Щоб проаналізувати вибірку даних з таблиці Customers, можна виконати запит на вибірку всіх записів:*/
SELECT * FROM customers;

/*Або вибірку записів з індексом на полі Phone:*/
SELECT * FROM customers WHERE Phone = '1234567890';