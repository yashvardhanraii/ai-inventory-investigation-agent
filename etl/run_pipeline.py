from extract import extract
from transform import transform


def main():

    print("\nStarting ETL Pipeline...\n")

    data = extract()

    print(f"\nLoaded {len(data)} datasets successfully.")

    cleaned_data = transform(data)

    print("\nTransformation complete.")


if __name__ == "__main__":
    main()