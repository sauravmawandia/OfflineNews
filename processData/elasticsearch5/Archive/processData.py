from __future__ import print_function

from urllib.request import urlopen
from bs4 import BeautifulSoup
from elasticsearch import Elasticsearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth
import json

domain = 'http://newspaper-demo.herokuapp.com/articles/show?url_to_clean='

awsauth = AWS4Auth('AKIAJ7MOAPONTA2ZOATA', 'dUlpg6WQusmxIOUGEnSNxoDFOG/BZYPWxQDmF5EO', 'us-east-2', 'es')

es = Elasticsearch(hosts=['https://search-parth-nerd-lisjfiqb2bfks3b766ezrygf7e.us-east-2.es.amazonaws.com/'],
                   http_auth=awsauth,
                   use_ssl=True,
                   verify_certs=True,
                   connection_class=RequestsHttpConnection)

def nlp(url):
    news = {}

    page = urlopen(domain + url).read()
    soup = BeautifulSoup(page, "html5lib")
    table = soup.find('table', {'class': 'table'})

    for row in table.find_all("tr"):
        element = row.get_text().strip().split("\n", 1)
        id = element[0].strip()

        if id == "Text":
            news["Text"] = element[1].strip()
        elif id == "Keywords (NLP)":
            news["Nlp"] = element[1].strip()
        else:
            continue
    return news


def lambda_handler(event, context):
    record = event['Records'][0]['Sns']['Message']
    news_json = json.loads(record)
    print("From SNS: " + record)

    id = news_json.get('id', None)
    url = news_json.get('url', None)
    publishedAt = news_json.get('publishedAt', None)
    author = news_json.get('author', None)
    imageUrl = news_json.get('urlToImage', None)
    description = news_json.get('description', None)
    title = news_json.get('title', None)
    news = nlp(url)
    news["id"] = id
    news["title"] = title
    news["publishedAt"] = publishedAt
    news["author"] = author
    news["imageURL"] = imageUrl
    news["description"] = description
    print(news)
    print("----------------------")
    es.index(index="cnn", doc_type="news", body=news)