from __future__ import print_function

import requests
import json
import boto3

lambda_client = boto3.client('lambda',
                             aws_access_key_id="*** Your AWS Access ID ***",
                             aws_secret_access_key="*** Your AWS Secret Access Key***",
                             region_name="*** Region ***")

sqs = boto3.resource('sqs',
                     aws_access_key_id="*** Your AWS Access ID ***",
                     aws_secret_access_key="*** Your AWS Secret Access Key***",
                     region_name="*** Region *** ")

queue = sqs.get_queue_by_name(QueueName="*** Your Queue Name ***")

Url = 'https://newsapi.org/v1/articles?source=cnn&sortBy=latest&apiKey=' + '*** API Key from news API ***'


def lambda_handler(event, context):
    lambda_client.invoke(FunctionName='insertDataDB', InvocationType='Event')
    print("Insert DynamoDB Lambda Invoked")
    response = requests.get(Url)
    data = response.json()
    articles = data.get('articles', None)

    for article in articles:
        url = article.get('url', None)
        title = article.get('title', None)
        print(title)
        timestamp = article.get('publishedAt', None)

        if url is not None and title is not None:
            index = str(timestamp) + "/" + str(title)
            index = index.replace(" ", "")
            article['id'] = index
            print(index)
            print("--------------------------------")
            response = queue.send_message(MessageBody=json.dumps(article))
