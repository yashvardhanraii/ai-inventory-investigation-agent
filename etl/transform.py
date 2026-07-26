import pandas as pd


def transform(data):

    cleaned_data = {}

    for name, df in data.items():

        print(f"\nCleaning {name}...")

        original_rows = len(df)

        # Remove duplicate rows
        df = df.drop_duplicates()

        duplicates_removed = original_rows - len(df)

        # Remove completely empty rows
        df = df.dropna(how="all")

        print(f"Rows: {len(df)}")
        print(f"Duplicates removed: {duplicates_removed}")

        cleaned_data[name] = df

    return cleaned_data