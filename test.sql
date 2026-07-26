SELECT
    DB_NAME() AS CurrentDatabase,
    GETDATE() AS CurrentDateTime,
    @@VERSION AS SQLServerVersion;