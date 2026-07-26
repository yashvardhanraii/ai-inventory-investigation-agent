-- Purchase order header

CREATE TABLE PurchaseOrders (
    PurchaseOrderID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseOrderNumber VARCHAR(30) UNIQUE NOT NULL,
    SupplierID INT NOT NULL,
    StoreID INT NOT NULL,
    OrderDate DATE NOT NULL,
    ExpectedDeliveryDate DATE NOT NULL,
    PurchaseOrderStatus VARCHAR(20) NOT NULL,
    TotalOrderValue DECIMAL(12,2),

    FOREIGN KEY (SupplierID)
        REFERENCES Suppliers(SupplierID),

    FOREIGN KEY (StoreID)
        REFERENCES Stores(StoreID),

    CHECK (
        PurchaseOrderStatus IN (
            'Draft',
            'Ordered',
            'Partially Received',
            'Received',
            'Cancelled'
        )
    ),

    CHECK (ExpectedDeliveryDate >= OrderDate),

    CHECK (
        TotalOrderValue >= 0
        OR TotalOrderValue IS NULL
    )
);


-- Products included in each purchase order

CREATE TABLE PurchaseOrderLines (
    PurchaseOrderLineID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    OrderedQuantity INT NOT NULL,
    UnitCost DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (PurchaseOrderID)
        REFERENCES PurchaseOrders(PurchaseOrderID),

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),

    UNIQUE (PurchaseOrderID, ProductID),

    CHECK (OrderedQuantity > 0),
    CHECK (UnitCost >= 0)
);


-- Goods receipt header

CREATE TABLE GoodsReceipts (
    GoodsReceiptID INT IDENTITY(1,1) PRIMARY KEY,
    ReceiptNumber VARCHAR(30) UNIQUE NOT NULL,
    PurchaseOrderID INT NOT NULL,
    StoreID INT NOT NULL,
    ReceiptDate DATETIME NOT NULL DEFAULT GETDATE(),
    ReceiptStatus VARCHAR(20) NOT NULL,

    FOREIGN KEY (PurchaseOrderID)
        REFERENCES PurchaseOrders(PurchaseOrderID),

    FOREIGN KEY (StoreID)
        REFERENCES Stores(StoreID),

    CHECK (
        ReceiptStatus IN (
            'Received',
            'Partial',
            'Rejected'
        )
    )
);


-- Products received against each receipt

CREATE TABLE GoodsReceiptLines (
    GoodsReceiptLineID INT IDENTITY(1,1) PRIMARY KEY,
    GoodsReceiptID INT NOT NULL,
    PurchaseOrderLineID INT NOT NULL,
    QuantityReceived INT NOT NULL,
    QuantityRejected INT DEFAULT 0,

    FOREIGN KEY (GoodsReceiptID)
        REFERENCES GoodsReceipts(GoodsReceiptID),

    FOREIGN KEY (PurchaseOrderLineID)
        REFERENCES PurchaseOrderLines(PurchaseOrderLineID),

    UNIQUE (GoodsReceiptID, PurchaseOrderLineID),

    CHECK (QuantityReceived >= 0),
    CHECK (QuantityRejected >= 0),
    CHECK (QuantityReceived + QuantityRejected > 0)
);
