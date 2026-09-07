# Day 14 – Networking Fundamentals & Hands-on Checks

## 📘 Overview
This day focuses on building comfort with core networking concepts and practicing the actual commands you’ll use in troubleshooting.  
You’ll map the OSI vs TCP/IP models, run connectivity checks, and capture a mini diagnostic for a target host/service.

---

## 🔑 Quick Concepts
# OSI vs TCP/IP Models

## 🔑 OSI vs TCP/IP Overview

### OSI Model (7 Layers)
- **Layer 7 – Application**: User-facing services (HTTP, FTP, SMTP, DNS).
- **Layer 6 – Presentation**: Data formatting, encryption, compression (TLS/SSL).
- **Layer 5 – Session**: Session control, dialog management (NetBIOS, RPC).
- **Layer 4 – Transport**: End-to-end delivery, reliability (TCP, UDP).
- **Layer 3 – Network**: Logical addressing, routing (IP, ICMP, OSPF).
- **Layer 2 – Data Link**: Local delivery, MAC addressing, error detection (Ethernet, Wi-Fi).
- **Layer 1 – Physical**: Transmission of raw bits (cables, fiber, radio).

### TCP/IP Model (4–5 Layers)
- **Application Layer**: Combines OSI’s Application, Presentation, and Session (HTTP, DNS, SMTP).
- **Transport Layer**: End-to-end communication (TCP, UDP).
- **Internet Layer**: Routing and addressing (IP, ICMP, ARP).
- **Network Interface Layer**: Physical + Data Link combined (Ethernet, Wi-Fi).

## Where Things Sit in the Stack

- **IP → Internet layer**  
  Handles addressing and routing.

- **TCP/UDP → Transport layer**  
  Handles communication reliability and ports.

- **HTTP/HTTPS → Application layer**  
  Actual web communication.

- **DNS → Application layer**  
  Translates names to IP addresses.

---


## # Where Things Sit in the Stack

- **IP → Internet layer**  
  Handles addressing and routing.

- **TCP/UDP → Transport layer**  
  Handles communication reliability and ports.

- **HTTP/HTTPS → Application layer**  
  Actual web communication.

- **DNS → Application layer**  
  Translates names to IP addresses.

---

## Hands-on Checklist
* Identity: hostname -I
Observation-  EC2 instance private IP is 172.31.28.128
## Terminal Session

```bash
Last login: Mon Sep  7 17:48:49 2026 from 106.215.183.85
ubuntu@ip-172-31-28-128:~$ hostname -I
172.31.28.128
ubuntu@ip-172-31-28-128:~$
```

* * Reachability: ping <target>

* ✅ Connectivity to google.com was successful.

📊 0% packet loss indicates a stable connection.
## Terminal Session – Ping Test

```bash
64 bytes from pd-in-f100.1e100.net (142.251.179.100): icmp_seq=61 ttl=106 time=1.69 ms
64 bytes from pd-in-f100.1e100.net (142.251.179.100): icmp_seq=62 ttl=106 time=1.68 ms
64 bytes from pd-in-f100.1e100.net (142.251.179.100): icmp_seq=63 ttl=106 time=1.77 ms
64 bytes from pd-in-f100.1e100.net (142.251.179.100): icmp_seq=66 ttl=106 time=1.67 ms
64 bytes from pd-in-f100.1e100.net (142.251.179.100): icmp_seq=67 ttl=106 time=1.68 ms
64 bytes from pd-in-f100.1e100.net (142.251.179.100): icmp_seq=68 ttl=106 time=1.80 ms
64 bytes from pd-in-f100.1e100.net (142.251.179.100): icmp_seq=69 ttl=106 time=1.70 ms
^C
--- google.com ping statistics ---
69 packets transmitted, 69 received, 0% packet loss, time 68120ms
rtt min/avg/max/mdev = 1.667/1.881/2.737/0.176 ms
ubuntu@ip-172-31-28-128:~$
```
* *  Ports: ss -tulpn

* Observation:This command lists all listening TCP/UDP sockets along with their ports and processes.

## Terminal Session – Port Check

```bash
ubuntu@ip-172-31-28-128:~$ sh -tulpn
sh: 0: Illegal option -t
ubuntu@ip-172-31-28-128:~$ ss -tulpn
Netid   State   Recv-Q Send-Q Local Address:Port        Peer Address:Port   Process
udp     UNCONN  0      0      127.0.0.1:323             0.0.0.0:*
udp     UNCONN  0      0      127.0.0.54:53             0.0.0.0:*
udp     UNCONN  0      0      127.0.0.53%lo:53          0.0.0.0:*
udp     UNCONN  0      0      172.31.28.128%ens5:68     0.0.0.0:*
udp     UNCONN  0      0      [::1]:323                 [::]:*
tcp     LISTEN  0      4096   127.0.0.54:53             0.0.0.0:*
tcp     LISTEN  0      4096   0.0.0.0:22                0.0.0.0:*
tcp     LISTEN  0      4096   127.0.0.53%lo:53          0.0.0.0:*
tcp     LISTEN  0      4096   [::]:22                   [::]:*
ubuntu@ip-172-31-28-128:~$
```
* * Name resolution: dig <domain> or nslookup <domain> — record the resolved IP.

 * Oberservation :
✅ The query resolved successfully (status: NOERROR).

🌍 Multiple IP addresses were returned for google.com (load balancing across servers).

⚡ Query time was very low (2 ms), showing fast DNS resolution

## Terminal Session – DNS Lookup

```bash
ubuntu@ip-172-31-28-128:~$ dig google.com

; <<>> DiG 9.20.18-1ubuntu2.1-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 23215
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             99      IN      A       142.251.111.102
google.com.             99      IN      A       142.251.111.113
google.com.             99      IN      A       142.251.111.101
google.com.             99      IN      A       142.251.111.139
google.com.             99      IN      A       142.251.111.100
google.com.             99      IN      A       142.251.111.138

;; Query time: 2 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Mon Sep 07 18:47:12 UTC 2026
;; MSG SIZE  rcvd: 135

ubuntu@ip-172-31-28-128:~$


```
# HTTP check: curl -I <http/https-url>

* Observation – HTTP Response

- ✅ The server responded with **HTTP/2 200**, meaning the request was successful.  
- 🖥️ The server is **gws** (Google Web Server).  
- 🔒 Security headers are present (**x-frame-options**, **content-security-policy**, **x-xss-protection**).  
- 🍪 Several cookies were set (**__Secure-STRP**, **AEC**, **NID**).  
- 📅 Response timestamp: **Mon, 07 Sep 2026 18:54:30 GMT**.  

## Terminal Session – HTTP Check

```bash
ubuntu@ip-172-31-28-128:~$ curl -I https://www.google.com
HTTP/2 200
content-type: text/html; charset=ISO-8859-1
content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-iI-tU8_0KN7i9yaNEGYaDQ' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
accept-ch: Sec-CH-Prefers-Color-Scheme
p3p: CP="This is not a P3P policy! See g.co/p3phelp for more info."
date: Mon, 07 Sep 2026 18:54:30 GMT
server: gws
x-xss-protection: 0
x-frame-options: SAMEORIGIN
expires: Mon, 07 Sep 2026 18:54:30 GMT
cache-control: private
set-cookie: __Secure-STRP=ANmZwa0BZDUcPqkLAljyyGuL3ii2pNjlmeHOB8W0_ic5HHELkjId3n_xIgEA0TRDtaEe-d1AwEbxudBsrkVHMvhXEED3Xcr1RPfg; expires=Mon, 07-Sep-2026 18:59:30 GMT; path=/; domain=.google.com; Secure; SameSite=strict
set-cookie: AEC=AdJVEat2dciYwbv4fjJ21LnaA5fDjl0LfGQPBU9QaliFiVQ9tnikdx27BWY; expires=Sat, 06-Mar-2027 18:54:30 GMT; path=/; domain=.google.com; Secure; HttpOnly; SameSite=lax
set-cookie: NID=534=Djf9wUawwqyoo6-3YzH2rdRfwZ4jamfNEQYUn9v86Mi4YuMW51zzjCv4TvZ8aivEEK5QR8g1UbfY2-au3Mp4G4TIdfKZcKsxw-6weg2odXGKQf4fiC5qHzMxBs9KY5FV3U7-yXxzlAGQE02jfSNP2BtfOsalXcpzYslRYYVaQdFWTvQnC1n8U2DGMeVah516RnblS8UeqXLWH3U_hy4Ogg; expires=Tue, 09-Mar-2027 18:54:30 GMT; path=/; domain=.google.com; HttpOnly
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

# Connections snapshot: netstat -an | head 

* Observation:Port 22 (SSH) is open and actively listening on IPv4 and IPv6.

📡 There are ESTABLISHED SSH connections from 106.215.183.85.

🌍 A connection to 54.167.165.180:80 (likely HTTP) is in TIME_WAIT state.

## Terminal Session – Active Connections

```bash
ubuntu@ip-172-31-28-128:~$ netstat -an | head
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address          Foreign Address        State
tcp        0      0 127.0.0.54:53          0.0.0.0:*              LISTEN
tcp        0      0 0.0.0.0:22             0.0.0.0:*              LISTEN
tcp        0      0 127.0.0.53:53          0.0.0.0:*              LISTEN
tcp        0      0 172.31.28.128:22       106.215.183.85:9336    ESTABLISHED
tcp        0      0 172.31.28.128:49162    54.167.165.180:80      TIME_WAIT
tcp      320      0 172.31.28.128:22       106.215.183.85:16182   ESTABLISHED
tcp6       0      0 :::22                  :::*                   LISTEN
udp        0      0 127.0.0.1:323          0.0.0.0:*              LISTEN
```

## Reflection 

* Which command gives you the fastest signal when something is broken? ping
* What layer (OSI/TCP-IP) would you inspect next if DNS fails? If HTTP 500 shows up?

### 🔎 If DNS fails
- **OSI Model**: Move down from the **Application layer** (DNS) to the **Network layer**.  
- **TCP/IP Model**: DNS is at the **Application layer**, so the next inspection point is the **Internet layer** (IP addressing and routing).  

**Checks you’d run:**
- Verify IP connectivity (`ping 8.8.8.8` bypasses DNS).  
- Check routing (`traceroute` or `ip route`).  
- Inspect firewall or resolver configuration.  

👉 In short: if DNS fails, drop down to **IP-level connectivity**.

---

### 🔎 If HTTP 500 shows up
- **OSI Model**: The error is at the **Application layer** (HTTP protocol).  
- **TCP/IP Model**: Same — it’s an **Application layer** issue.  

**Checks you’d run:**
- Look at the **server-side application logs** (web server, app framework).  
- Verify backend services (databases, APIs) are healthy.  
- Ensure configuration files and permissions are correct.  

👉 In short: an HTTP 500 means the network stack is fine — the failure is inside the **application itself**.














