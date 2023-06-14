from elasticsearch import Elasticsearch
from dotenv import dotenv_values
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Load environment variables from the .env file
env_vars = dotenv_values(".env")

# Set up the connection to Elasticsearch
es = Elasticsearch(
    hosts=env_vars["ELASTIC_NODE"].split(","),
    http_auth=(env_vars["ELASTIC_USER"], env_vars["ELASTIC_PASSWORD"]),
    verify_certs=False,
)

# Get all the index names
indices = es.indices.get(index="new-btg-sends-*")

# Filter out the aliases
filtered_indices = [index_name for index_name, index_info in indices.items() if not index_info.get("aliases")]


# Get the date of the most recent record for each index
print("index;transid;most_recent_date")
for index in filtered_indices:
    # Execute the query
    result = es.search(index=index, size=1, query={"match_all": {}}, sort=[{"@timestamp": "desc"}])

    # Extract the date of the most recent record
    hits = result["hits"]["hits"]
    if hits:
        date = hits[0]["_source"]["@timestamp"]  # Update with the appropriate field for the record date
        transid = index.split('-')[-1]
        print(f"{index};{transid};{date}")
    else:
        print(f"Index: {index}, No records found.")
