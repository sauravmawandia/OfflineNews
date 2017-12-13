from __future__ import print_function

import boto3
import json
from botocore.exceptions import ClientError

sqs = boto3.resource('sqs',
                     aws_access_key_id="*** Your AWS Access ID ***",
                     aws_secret_access_key="*** Your AWS Secret Access Key***",
                     region_name="*** Region *** ")

queue = sqs.get_queue_by_name(QueueName="*** Your Queue Name ***")

dynamodb = boto3.resource('dynamodb',
                          aws_access_key_id="*** Your AWS Access ID ***",
                          aws_secret_access_key="*** Your AWS Secret Access Key***",
                          region_name="*** Region *** ")

table = dynamodb.Table('News')

sns = boto3.client('sns',
                   aws_access_key_id="*** Your AWS Access ID ***",
                   aws_secret_access_key="*** Your AWS Secret Access Key***",
                   region_name="*** Region *** ")

print("Insert Dynamo DB running")


def lambda_handler(event, context):
    while True:
        messages_to_delete = []
        for message in queue.receive_messages(MaxNumberOfMessages=10):
            news = json.loads(message.body)

            try:
                table.put_item(
                    Item=news,
                    ConditionExpression='attribute_not_exists(id)')
                print("Insert Successful!")
                response = sns.publish(
                    TopicArn="*** Topic ARN *** ",
                    Message=json.dumps(news),
                    Subject='New News Added')
                print(response)

            except ClientError as e:
                if e.response["Error"]["Code"] == "ConditionalCheckFailedException":
                    pass
                else:
                    raise e

            messages_to_delete.append({
                'Id': message.message_id,
                'ReceiptHandle': message.receipt_handle
            })

            if len(messages_to_delete) == 0:
                break
            else:
                delete_response = queue.delete_messages(Entries=messages_to_delete)
                print(delete_response)
