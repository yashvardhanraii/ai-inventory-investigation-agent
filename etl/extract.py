import pandas as pd
from config import RAW_DATA


def extract():

    data = {}

    for file in RAW_DATA.glob("*.csv"):
        table_name = file.stem
        data[table_name] = pd.read_csv(file)

        print(
            f"Loaded {table_name}: "
            f"{len(data[table_name])} rows"
        )

    return data