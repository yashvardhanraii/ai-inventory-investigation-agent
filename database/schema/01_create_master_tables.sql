-- Product categories

CREATE TABLE ProductCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(100) UNIQUE NOT NULL,
    DepartmentName VARCHAR(100),
    IsActive BIT DEFAULT 1
);


-- Stores

CREATE TABLE Stores (
    StoreID INT IDENTITY(1,1) PRIMARY KEY,
    StoreCode VARCHAR(20) UNIQUE NOT NULL,
    StoreName VARCHAR(150) NOT NULL,
    City VARCHAR(100) NOT NULL,
    StateCode CHAR(3) NOT NULL,
    Postcode VARCHAR(10),
    StoreType VARCHAR(50),
    IsActive BIT DEFAULT 1,

    CHECK (
        StateCode IN (
            'QLD',
            'NSW',
            'VIC',
            'SA',
            'WA',
            'TAS',
            'ACT',
            'NT'
        )
    )
);


-- Products

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    SKU VARCHAR(40) UNIQUE NOT NULL,
    ProductName VARCHAR(200) NOT NULL,
    CategoryID INT NOT NULL,
    BrandName VARCHAR(100),
    UnitOfMeasure VARCHAR(20) NOT NULL,
    UnitCost DECIMAL(10,2) NOT NULL,
    RetailPrice DECIMAL(10,2) NOT NULL,
    ShelfLifeDays INT,
    IsActive BIT DEFAULT 1,

    FOREIGN KEY (CategoryID)
        REFERENCES ProductCategories(CategoryID),

    CHECK (UnitCost >= 0),
    CHECK (RetailPrice >= 0),
    CHECK (ShelfLifeDays > 0 OR ShelfLifeDays IS NULL)
);


-- Suppliers

CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierCode VARCHAR(20) UNIQUE NOT NULL,
    SupplierName VARCHAR(150) NOT NULL,
    ContactName VARCHAR(120),
    ContactEmail VARCHAR(200),
    ContactPhone VARCHAR(30),
    LeadTimeDays INT NOT NULL,
    MinimumOrderValue DECIMAL(10,2),
    IsActive BIT DEFAULT 1,

    CHECK (LeadTimeDays >= 0),
    CHECK (
        MinimumOrderValue >= 0
        OR MinimumOrderValue IS NULL
    )
);


-- Connects products with suppliers

CREATE TABLE ProductSuppliers (
    ProductSupplierID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    SupplierID INT NOT NULL,
    SupplierProductCode VARCHAR(50),
    SupplierUnitCost DECIMAL(10,2) NOT NULL,
    MinimumOrderQuantity INT DEFAULT 1,
    IsPreferredSupplier BIT DEFAULT 0,
    IsActive BIT DEFAULT 1,

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),

    FOREIGN KEY (SupplierID)
        REFERENCES Suppliers(SupplierID),

    UNIQUE (ProductID, SupplierID),

    CHECK (SupplierUnitCost >= 0),
    CHECK (MinimumOrderQuantity > 0)
);
