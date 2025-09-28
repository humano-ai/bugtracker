Title: Dillo fails to connect to PHP internal http webserver / PHP webserver instantly resets TCP connection
Author: ghost
Created: Sat, 15 Feb 2025 14:11:55 +0000
State: closed

**1. Start PHP internal webserver by running:** 

`php -S localhost:80 -t /path/to/html-directory/`

(you can choos to use an port above 1024 if you do not have enough privileges)

**2. Try to connect to the URL (http://localhost:80, for example)**

 - Dillo displays error message: "Could not establish connection"


**4. Looking at Wireshark log the following TCP package sequence can be seen**

Dillo Requests connection
PHP resets connection
Dillo Requests connection
PHP resets conntection 


**Packet capture details of the first 2 packets**

Dillo request: 

```
Transmission Control Protocol, Src Port: 43556, Dst Port: 80, Seq: 0, Len: 0
    Source Port: 43556
    Destination Port: 80
    [Stream index: 0]
    [Conversation completeness: Incomplete (37)]
    [TCP Segment Len: 0]
    Sequence Number: 0    (relative sequence number)
    Sequence Number (raw): 211095531
    [Next Sequence Number: 1    (relative sequence number)]
    Acknowledgment Number: 0
    Acknowledgment number (raw): 0
    1010 .... = Header Length: 40 bytes (10)
    Flags: 0x002 (SYN)
        000. .... .... = Reserved: Not set
        ...0 .... .... = Accurate ECN: Not set
        .... 0... .... = Congestion Window Reduced: Not set
        .... .0.. .... = ECN-Echo: Not set
        .... ..0. .... = Urgent: Not set
        .... ...0 .... = Acknowledgment: Not set
        .... .... 0... = Push: Not set
        .... .... .0.. = Reset: Not set
        .... .... ..1. = Syn: Set
            [Expert Info (Chat/Sequence): Connection establish request (SYN): server port 80]
                [Connection establish request (SYN): server port 80]
                [Severity level: Chat]
                [Group: Sequence]
        .... .... ...0 = Fin: Not set
        [TCP Flags: ··········S·]
    Window: 65495
    [Calculated window size: 65495]
    Checksum: 0xf5ad [unverified]
    [Checksum Status: Unverified]
    Urgent Pointer: 0
    Options: (20 bytes), Maximum segment size, SACK permitted, Timestamps, No-Operation (NOP), Window scale
        TCP Option - Maximum segment size: 65495 bytes
            Kind: Maximum Segment Size (2)
            Length: 4
            MSS Value: 65495
        TCP Option - SACK permitted
            Kind: SACK Permitted (4)
            Length: 2
        TCP Option - Timestamps: TSval 423197222, TSecr 0
            Kind: Time Stamp Option (8)
            Length: 10
            Timestamp value: 423197222
            Timestamp echo reply: 0
        TCP Option - No-Operation (NOP)
            Kind: No-Operation (1)
        TCP Option - Window scale: 7 (multiply by 128)
            Kind: Window Scale (3)
            Length: 3
            Shift count: 7
            [Multiplier: 128]
    [Timestamps]
        [Time since first frame in this TCP stream: 0.000000000 seconds]
        [Time since previous frame in this TCP stream: 0.000000000 seconds]
```


PHP response: 
```

Transmission Control Protocol, Src Port: 80, Dst Port: 43556, Seq: 1, Ack: 1, Len: 0
    Source Port: 80
    Destination Port: 43556
    [Stream index: 0]
    [Conversation completeness: Incomplete (37)]
    [TCP Segment Len: 0]
    Sequence Number: 1    (relative sequence number)
    Sequence Number (raw): 0
    [Next Sequence Number: 1    (relative sequence number)]
    Acknowledgment Number: 1    (relative ack number)
    Acknowledgment number (raw): 211095532
    0101 .... = Header Length: 20 bytes (5)
    Flags: 0x014 (RST, ACK)
        000. .... .... = Reserved: Not set
        ...0 .... .... = Accurate ECN: Not set
        .... 0... .... = Congestion Window Reduced: Not set
        .... .0.. .... = ECN-Echo: Not set
        .... ..0. .... = Urgent: Not set
        .... ...1 .... = Acknowledgment: Set
        .... .... 0... = Push: Not set
        .... .... .1.. = Reset: Set
            [Expert Info (Warning/Sequence): Connection reset (RST)]
                [Connection reset (RST)]
                [Severity level: Warning]
                [Group: Sequence]
        .... .... ..0. = Syn: Not set
        .... .... ...0 = Fin: Not set
        [TCP Flags: ·······A·R··]
    Window: 0
    [Calculated window size: 0]
    [Window size scaling factor: -1 (unknown)]
    Checksum: 0xead8 [unverified]
    [Checksum Status: Unverified]
    Urgent Pointer: 0
    [Timestamps]
        [Time since first frame in this TCP stream: 0.000044930 seconds]
        [Time since previous frame in this TCP stream: 0.000044930 seconds]
    [SEQ/ACK analysis]
        [This is an ACK to the segment in frame: 438]
        [The RTT to ACK the segment was: 0.000044930 seconds]
        [iRTT: 0.000044930 seconds]
```




--%--
From: rodarima
Date: Sat, 15 Feb 2025 14:37:45 +0000

What does “curl -v http://localhost” says?


--%--
From: ghost
Date: Sat, 15 Feb 2025 15:00:09 +0000

Interesting, seems to be IP version related, haven't thought about that. 

curl -v http://localhost:12888/index.html
*   Trying 127.0.0.1:12888...
* connect to 127.0.0.1 port 12888 failed: Connection rejected
*   Trying [::1]:12888...
* Connected to localhost (::1) port 12888 (#0)
> GET /index.html HTTP/1.1
> Host: localhost:12888
> User-Agent: curl/7.88.1
> Accept: */*
> 
< HTTP/1.1 200 OK
< Host: localhost:12888
< Date: Sat, 15 Feb 2025 14:57:44 GMT
< Connection: close
< Content-Type: text/html; charset=UTF-8
< Content-Length: 49935



--%--
From: rodarima
Date: Sat, 15 Feb 2025 15:08:38 +0000

Try building dillo with --enable-ipv6, it looks you are listening on IPv6 only.

--%--
From: ghost
Date: Sat, 15 Feb 2025 15:15:48 +0000

Yeah, that was an example of RTFM and works fine now  🙈👍 