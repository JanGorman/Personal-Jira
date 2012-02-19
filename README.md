## About

A silly little project that sets up a custom node.js server to poll Jira for you. Once configured, it will poll your Jira via soap for a list of available releases which you can then search for issues assigned to you.

## Run

First:

    npm install
    
to resolve node.js dependencies. From then on just cd into the directory and punch in:

    node server.js

## Why

Jira is ugly and and searching for issues is pretty cumbersome. This pretty little app takes the pain out of the process. I frequently found myself having to do a manual Jira search for the current release's issues. Plus I had some spare time.

## Prerequisites

You need node.js. npm will take care of all the dependencies for your. The python part requires suds for the SOAP communication. Why python? I discovered that all available node.js SOAP libraries pretty much suck. Some don't work at all and the one used here (that is node-soap) can't deal with multiRefs. Suds handles all of this beautifully. So there's a new project:  a node.js SOAP lib that doesn't suck.

## Licence

See LICENCE