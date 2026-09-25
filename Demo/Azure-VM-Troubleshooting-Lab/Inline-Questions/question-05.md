## MetaData
Question Type : Single Choice

## Question
5. In Lab 1, `ss -tlnp` on appvm showed nginx listening on `127.0.0.1:80`. What does that bind address mean for clients?

## Options

Option 1 : Clients in the same VNet can connect, but traffic from any other network is refused

Option 2 : Any client can connect, but nginx only answers requests that carry 127.0.0.1 in the HTTP Host header

Option 3 : Only processes on appvm itself can connect, because loopback is not reachable from the network

Option 4 : Clients can connect over IPv4 only, and IPv6 connections are refused until a second listen line is added

## Answers
Option 3 : 1

## Number of Retries
1
