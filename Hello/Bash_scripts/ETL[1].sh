1.

#!/bin/bash

CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
EXTRACT_FOLDER="raw"
TRANSFORMED_FOLDER="Transformed"
LOAD_FOLDER="Gold"

EXTRACT_FILE="${EXTRACT_FOLDER}/annual-enterprise-survey-2023-financial-year-provisional.csv"
TRANSFORMED_FILE="${TRANSFORMED_FOLDER}/2023_year_finance.csv"
LOAD_FILE="${LOAD_FOLDER}/2023_year_finance.csv"

mkdir -p $EXTRACT_FOLDER

curl -o "$EXTRACT_FILE" "$CSV_URL"

if [ -f "$EXTRACT_FILE" ]; then
    echo "CSV file successfully downloaded and saved to ${EXTRACT_FOLDER}."
else
    echo "Failed to download the CSV file."
    exit 1
fi


mkdir -p "$TRANSFORMED_FOLDER"

awk -F, 'NR==1 {
            for (i=1; i<=NF; i++) {
                if ($i == "Variable_code") $i="variable_code";
            }
            print "year,Value,Units,variable_code"
         }
         NR>1 { print $1", "$9", "$5", "$6 }' "$EXTRACT_FILE" > "$TRANSFORMED_FILE"


if [ -f "$TRANSFORMED_FILE" ]; then
    echo "Data transformation is successful, and has been saved to $TRANSFORMED_FOLDER}."
else
    echo "Failed to transform the data."
    exit 1
fi


mkdir -p "${LOAD_FOLDER}"
cp "$TRANSFORMED_FILE" "$LOAD_FILE"

if [ -f "$LOAD_FILE" ]; then
        echo "Transformed data has been successfully loaded to the ${LOAD_FOLDER} directory."
else
        echo "Failed to load transformed data"
        exit 1
fi


echo "ETL Process completed successfully."



2.
#!/bin/bash
crontab -e
0 0 * * * C:/Users/MUHYIDEEN PAYVANTAGE/Desktop/Raw/ETL.sh


3.

#!/bin/bash

# Defining source and destination folder
SOURCE_FOLDER="source_folder"
DESTINATION_FOLDER="json_and_CSV"

# Used to create the destination folder 
mkdir -p "$DESTINATION_FOLDER"

# Used to move all CSV and JSON files from the source folder to the destination folder
mv "$SOURCE_FOLDER"/*.csv "$SOURCE_FOLDER"/*.json "$DESTINATION_FOLDER"

# Used to check if the move was successful
if [ $? -eq 0 ]; then
    echo "Files moved successfully to $DESTINATION_FOLDER."
else
    echo "Failed to move files."
    exit 1
fi

4.
#Creating the DB 'posey'
createdb posey


#Used to download the csv file from the link to my local PC
CSV_URL="https://we.tl/t-2xYLL816Yt"
EXTRACT_FOLDER="Parch-and_posey"

EXTRACT_FILE="${EXTRACT_FOLDER}/Parch_and_posey.csv"


mkdir -p $EXTRACT_FOLDER

curl -o "$EXTRACT_FILE" "$CSV_URL"

if [ -f "$EXTRACT_FILE" ]; then
    echo "CSV file successfully downloaded and saved to ${EXTRACT_FOLDER}."
else
    echo "Failed to download the CSV file."
    exit 1
fi


#Used to iterates over and copies each of the CSV files into a PostgreSQL database (name the database posey).


# Path to the CSV file
CSV_FILE="${EXTRACT_FOLDER}/Parch_and_posey.csv"
# PostgreSQL database
DB_NAME="posey"
# PostgreSQL user 
DB_USER="your_username"

# Extract the base name of the file (without extension)
TABLE_NAME=$(basename "$CSV_FILE" .csv)

echo "Importing $CSV_FILE into table $TABLE_NAME"

# Create table in PostgreSQL (replace with your own table structure)
psql -U "$DB_USER" -d "$DB_NAME" -c "
  DROP TABLE IF EXISTS $TABLE_NAME;
  CREATE TABLE $TABLE_NAME (
    -- Define your table structure here
    id SERIAL PRIMARY KEY,
    column1 TEXT,
    column2 INTEGER
  );
"

# Import the CSV file into PostgreSQL
psql -U "$DB_USER" -d "$DB_NAME" -c "\copy $TABLE_NAME FROM '$CSV_FILE' CSV HEADER;"

echo "Imported $CSV_FILE into $TABLE_NAME"

echo "Import complete."


