#!/usr/bin/env python2.7
# coding:utf-8

from urllib2 import Request, urlopen, URLError, HTTPError
import base64
import json
import sys

token = sys.argv[1]
instance = sys.argv[2]
project = sys.argv[3]
query_id = sys.argv[4]

urlQuery = 'https://' + instance + '.visualstudio.com/DefaultCollection/' + project + '/_apis/wit/queries/' +  query_id;
workItemsQuery = 'https://' + instance + '.visualstudio.com/DefaultCollection/_apis/wit/workitems?ids='
encodedToken = base64.b64encode(bytes(':' + token))
headers = {'Authorization': 'Basic ' + encodedToken}

req = Request(url=urlQuery, headers=headers)

try:
    response = urlopen(req)
except HTTPError as e:
    data['error'] = 'The server couldn\'t fulfill the request.'
except URLError as e:
    data['error'] = 'We failed to reach a server.'
else:
    queryData = json.load(response)
    data = {'name': '', 'items': [], 'error': ''}
    data['name'] = queryData['name'];
    reqWiql = Request(url=queryData['_links']['wiql']['href'], headers=headers)

    try:
        responseWiql = urlopen(reqWiql)
    except HTTPError as e:
        data['error'] = 'The server couldn\'t fulfill the request.'
    except URLError as e:
        data['error'] = 'We failed to reach a server.'
    else:
        wiqlData = json.load(responseWiql)
        ids = [li['id'] for li in wiqlData['workItems']]
        workItemsQuery = workItemsQuery + ','.join(map(str, ids))
        
        reqWorkItems = Request(url=workItemsQuery, headers=headers)
        try:
            responseWorkItems = urlopen(reqWorkItems)
        except HTTPError as e:
            data['error'] = 'The server couldn\'t fulfill the request.'
        except URLError as e:
            data['error'] = 'We failed to reach a server.'
        else:
            workItemsData = json.load(responseWorkItems)
            data['items'] = workItemsData['value']
            print json.dumps(data)