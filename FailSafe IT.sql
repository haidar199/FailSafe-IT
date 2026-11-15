-- Reset and create database
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'FailSafeIT')
BEGIN
    ALTER DATABASE FailSafeIT SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FailSafeIT;
END
GO

CREATE DATABASE FailSafeIT;
GO

USE FailSafeIT;
GO

-- create tables
CREATE TABLE Customers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    OrganizationNumber VARCHAR(11) UNIQUE NOT NULL,
    CompanyName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL
);
GO

CREATE TABLE Consultants (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PersonalIdentityNumber VARCHAR(13) UNIQUE NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    HourlyRate DECIMAL(10,2) NOT NULL ,
    Specialty NVARCHAR(100) NOT NULL
);

GO

CREATE TABLE Assignments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL,
    ConsultantId INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    RoleDescription NVARCHAR(200) NOT NULL,

    CONSTRAINT FK_Assignments_Customers
        FOREIGN KEY (CustomerId) REFERENCES Customers(Id),

    CONSTRAINT FK_Assignments_Consultants
        FOREIGN KEY (ConsultantId) REFERENCES Consultants(Id)
);
GO

-- Insert test data.
INSERT INTO Customers
    (OrganizationNumber, CompanyName, Email, PhoneNumber)
VALUES
    ('090001-0001', N'Apple',
     N'contact@apple.example', '0900000001'),

    ('090002-0002', N'Microsoft',
     N'contact@microsoft.example', '0900000002'),

    ('090003-0003', N'NVIDIA',
     N'contact@nvidia.example', '0900000003');
GO

-- Check the customer data
SELECT * FROM Customers;
GO

INSERT INTO Consultants
    (PersonalIdentityNumber, Name, HourlyRate, Specialty)
VALUES
    ('09000101-0001', N'John Johansson', 1500.00, N'Cybersecurity'),
    ('09000202-0002', N'Ali Hassan', 1300.00, N'DevOps'),
    ('09000303-0003', N'Martin Lutherking', 1100.00, N'C# Developer');
GO

-- Check the consultant data
SELECT * FROM Consultants;
GO

INSERT INTO Assignments
    (CustomerId, ConsultantId, StartDate, EndDate, RoleDescription)
VALUES
    (1, 1, '2026-09-14', '2026-12-18', N'API security review'),
    (1, 2, '2026-10-05', '2027-02-12', N'Deployment automation'),
    (1, 3, '2026-11-09', '2027-04-23', N'C# application development'),
    (2, 1, '2026-08-24', '2026-11-27', N'Cloud security assessment'),
    (2, 2, '2026-10-19', '2027-03-05', N'CI/CD pipeline setup');
GO

-- Check the assignment data
SELECT * FROM Assignments;
GO


-- Query A: Consultants charging more than 1200 SEK per hour
SELECT Name, HourlyRate
FROM Consultants
WHERE HourlyRate > 1200
ORDER BY HourlyRate DESC;
GO

-- Query B: List all assignments with customer and consultant names
SELECT c.CompanyName, co.Name AS ConsultantName,
       a.StartDate, a.EndDate
FROM Assignments a
INNER JOIN Customers c ON a.CustomerId = c.Id
INNER JOIN Consultants co ON a.ConsultantId = co.Id;
GO

-- Query C. Count active assignments per customer on 2026-11-15
SELECT c.CompanyName, COUNT(a.Id) AS ActiveAssignments
FROM Customers c
LEFT JOIN Assignments a ON c.Id = a.CustomerId
    AND a.StartDate <= '2026-11-15'
    AND a.EndDate >= '2026-11-15'
GROUP BY c.Id, c.CompanyName
ORDER BY c.CompanyName;
GO

-- Query D: Update John Johansson's hourly rate
UPDATE Consultants
SET HourlyRate = 1600.00
WHERE Id = 1;
GO

-- Check the updated hourly rate
SELECT Id, Name, HourlyRate
FROM Consultants
WHERE Id = 1;
GO

-- Query E: Delete NVIDIA only if it has no assignments
DELETE FROM Customers
WHERE Id = 3
    AND NOT EXISTS (
        SELECT 1
        FROM Assignments
        WHERE CustomerId = 3
    );
GO

-- Check the remaining customers
SELECT * FROM Customers;
GO