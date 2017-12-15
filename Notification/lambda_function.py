from __future__ import print_function

import boto3

sns = boto3.client('sns',
                   aws_access_key_id="AKIAJDGSQ5JR3AOBERJA",
                   aws_secret_access_key="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",
                   region_name="us-east-1")
                   
arn = 'arn:aws:sns:us-east-1:908644437130:app/APNS_SANDBOX/iNews'

def lambda_handler(event, context):
    
    response = sns.list_endpoints_by_platform_application(PlatformApplicationArn='arn:aws:sns:us-east-1:908644437130:app/APNS_SANDBOX/iNews')
    for endpoint in response['Endpoints']:
        endpointARN = endpoint['EndpointArn']
        print(endpointARN)
        response = sns.publish(
                    TargetArn = endpointARN,
                    Message="Psssst... Download the latest news!",
                    Subject='Download New News Notification')
        print(response)
        print("---------------------------")