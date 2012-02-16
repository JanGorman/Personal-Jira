import argparse
import json
from suds.client import Client

parser = argparse.ArgumentParser()
parser.add_argument('--token', help='token')
parser.add_argument('--project', help='project')
parser.add_argument('--wsdl', help='wsdl location')
args = parser.parse_args()

client = Client(args.wsdl)
releases = client.service.getVersions(args.token, args.project)

release_names = []

for release in releases:
    release_names.append(release.name)

print json.dumps(release_names)