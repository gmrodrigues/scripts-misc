#!/usr/bin/env python3

import csv
import sys

if len(sys.argv) < 4:
    print("Usage: cassandra-generate-deletes-from-csv.py [-o <output_file>] <csv_file> <table_name> <key1> <key2> ...")
    sys.exit(1)

# get the command line arguments
# get -o <output_file> if it exists
if sys.argv[1] == "-o":
    output_file = sys.argv[2]
    csv_file = sys.argv[3]
    table_name = sys.argv[4]
    keys = sys.argv[5:]
else:
    output_file = None
    csv_file = sys.argv[1]
    table_name = sys.argv[2]
    keys = sys.argv[3:]

# open the CSV file
with open(csv_file, 'r') as file:
    reader = csv.reader(file)
    headers = next(reader) # skip the header row
    
    # loop through each row in the CSV file
    for row in reader:
        conditions = []
        for key in keys:
            if key in headers:
                index = headers.index(key)
                conditions.append(f"{key} = '{row[index]}'")
            else:
                print(f"Key '{key}' not found in headers")
                sys.exit(1)
        conditions_str = " AND ".join(conditions)
        
        # print the delete command for each row
        print(f"DELETE FROM {table_name} WHERE {conditions_str};")


