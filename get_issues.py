import argparse
import json
from suds.client import Client

parser = argparse.ArgumentParser()
parser.add_argument('--token', help='token')
parser.add_argument('--username', help='username')
parser.add_argument('--release', help='release')
parser.add_argument('--wsdl', help='wsdl location')
args = parser.parse_args()

client = Client(args.wsdl)
issues = client.service.getIssuesFromJqlSearch(args.token, 'assignee = \'{}\' AND fixVersion = {}'.format(args.username, args.release), 100)

print issues