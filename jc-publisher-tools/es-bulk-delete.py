#!/bin/env python3

from elasticsearch5 import Elasticsearch
from elasticsearch5.helpers import bulk, scan

host = 'http://10.34.30.31:9200'
index_name = 'catalog-write'
search_body = {
    "query": {
        "bool": {
            "must": [
                {
                    "term": {
                        "storeId": "747"
                    }
                }
            ],
        }
    },
    "size": 10,
    "sort": [ ],
    "aggs": { }
}

BATCH_SIZE = 100000
i = 0
ES_DOC='offers'

client = Elasticsearch( host )

bulk_deletes = []
for result in scan(client,
                   query=search_body,
                   index=index_name,
                   doc_type=ES_DOC,
                   _source=False,
                   track_scores=False,
                   scroll='5m'):
    print(result)

    if i == BATCH_SIZE:
        bulk(client, bulk_deletes)
        bulk_deletes = []
        i = 0

    result['_op_type'] = 'delete'
    bulk_deletes.append(result)

    i += 1

bulk(client, bulk_deletes)