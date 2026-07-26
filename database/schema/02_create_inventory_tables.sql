-- Current inventory at each store

CREATE TABLE CurrentInventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    ProductID INT NOT NULL,
    QuantityOnHand INT NOT NULL,
    LastStocktakeDate DATE,
    LastUpdated DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (StoreID)
        REFERENCES Stores(StoreID),

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),

    UNIQUE (StoreID, ProductID),

    CHECK (QuantityOnHand >= 0)
);


-- Inventory settings for each store and product

CREATE TABLE ProductStoreSettings (
    ProductStoreSettingID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    ProductID INT NOT NULL,
    ReorderPoint INT NOT NULL,
    ReorderQuantity INT NOT NULL,
    MaximumStockLevel INT,

    FOREIGN KEY (StoreID)
        REFERENCES Stores(StoreID),

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),

    UNIQUE (StoreID, ProductID),

    CHECK (ReorderPoint >= 0),
    CHECK (ReorderQuantity > 0),
    CHECK (
        MaximumStockLevel IS NULL
        OR MaximumStockLevel >= ReorderPoint
    )
);


-- Every inventory movement

CREATE TABLE InventoryMovements (
    MovementID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    ProductID INT NOT NULL,
    MovementType VARCHAR(30) NOT NULL,
    Quantity INT NOT NULL,
    MovementDate DATETIME NOT NULL,
    ReferenceNumber VARCHAR(50),
    Notes VARCHAR(255),

    FOREIGN KEY (StoreID)
        REFERENCES Stores(StoreID),

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),

    CHECK (
        MovementType IN (
            'Purchase',
            'Sale',
            'Transfer In',
            'Transfer Out',
            'Waste',
            'Theft',
            'Adjustment'
        )
    ),

    CHECK (Quantity > 0)
);

