from __future__ import print_function

from elasticsearch import Elasticsearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth

awsauth = AWS4Auth('AKIAJ7MOAPONTA2ZOATA', 'dUlpg6WQusmxIOUGEnSNxoDFOG/BZYPWxQDmF5EO', 'us-east-2', 'es')
es = Elasticsearch(hosts=['https://search-test-news-3bsbyuznu7uxpfpuy7hbqxexry.us-east-2.es.amazonaws.com/'],
                   http_auth=awsauth, use_ssl=True,
                   verify_certs=True,
                   connection_class=RequestsHttpConnection)

def lambda_handler(event, context):
    message = event['Records'][0]['Sns']['Message']
    print("From SNS: " + message)

    es.index(index="cnn", doc_type="news", body=message)
    return message