CREATE DATABASE Holmes

CREATE TABLE products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(255),
    Price DECIMAL(10, 2),
    Category VARCHAR(50),
    StockQuantity INT,
    Description TEXT
);

CREATE TABLE customers (
CustomerID SERIAL PRIMARY KEY,
Prefix VARCHAR(10),
FirstName VARCHAR(60),
LastName VARCHAR(60),
BirthDate DATE,
MaritalStatus CHAR(1),
Gender CHAR(1),
EmailAddress VARCHAR(100),
AnnualIncome DECIMAL(15, 2),
TotalChildren INT,
EducationLevel VARCHAR(50),
Occupation VARCHAR(50),
HomeOwner Char(1)
);


CREATE TABLE Sales (
    SaleID SERIAL PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    SaleDate DATE,
    Quantity INT,
	SalePrice DECIMAL(10,2),
    Discount DECIMAL(10,2) DEFAULT 0.00,
    PaymentMethod VARCHAR(255),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);



