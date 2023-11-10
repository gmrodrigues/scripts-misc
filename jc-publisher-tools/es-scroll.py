#!/bin/env python3

from elasticsearch5 import Elasticsearch, helpers, exceptions
import json

host = 'http://10.34.30.31:9200'
index_name = 'catalog'
search_body = {
    "query": {
        "bool": {
            "must": [
                {
                    "term": {
                        "storeId": "733"
                    }
                }
            ],
        }
    },
    "size": 10,
    "sort": [ ],
    "aggs": { }
}

client = Elasticsearch( host )

resp = helpers.scan(
        client,
        scroll = '3m',
        size = 100,
        index = index_name,
        query = search_body,
    )

for num, doc in enumerate(resp):
    #print ('\n', num, '', doc)
    print (doc)