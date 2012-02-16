## About

A silly little project that sets up a custom node.js server to poll Jira for you. Once configured, it will poll your Jira via soap for a list of available releases which you can then search for issues assigned to you.

## Run

First:

    npm install
    
to resolve node.js dependencies, from then on just cd into the directory and punch in:
  
    node server.js

## Why

Jira is ugly and a pain to use. And searching for issues is cumbersome. This beautiful little app takes the pain out of the process. I frequently found myself having to do a manual Jira search for the current release's issues.

## What

You need node.js and python (check the python files for required dependencies). I discovered that all available node.js SOAP libraries pretty much suck, can't deal with multiRefs. Suds handles all of this beautifully. So there's a new project:  a node.js SOAP lib that doesn't suck.