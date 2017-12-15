from __future__ import print_function

import boto3

sns = boto3.client('sns',
                   aws_access_key_id="*** AWS Access Key ***",
                   aws_secret_access_key="*** AWS Secret Key ***",
                   region_name="*** AWS Region ***")
                   
arn = '*** Your Application ARN ***'

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
