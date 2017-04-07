Subnetting Math Notes:
================================================================

* Data found @: http://www.digipro.com/Papers/IP_Subnetting.shtml



On IP Subnetting and Subnet Masks
This page covers octal and decimal math with respect to IP subnetting, subnet masks, broadcast addresses and the like. It's meant to de-mystify the simple math of IP networking for the novice LAN administrator. A sound understanding of these concepts is critical for security and general network stability. However, even university-level textbooks seem to gloss over this topic.


Subnet Masks and Subnets:


```
notation	resulting subnet
netmask	shorthand	number of addresses
255.255.255.0	/24 [8-bit]	28 =	256	= 254 hosts + 1 bcast + 1 net base
255.255.255.128	/25 [7-bit]	27 =	128	= 126 hosts + 1 bcast + 1 net base
255.255.255.192	/26 [6-bit]	26 =	64	= 62 hosts + 1 bcast + 1 net base
255.255.255.224	/27 [5-bit]	25 =	32	= 30 hosts + 1 bcast + 1 net base
255.255.255.240	/28 [4-bit]	24 =	16	= 14 hosts + 1 bcast + 1 net base
255.255.255.248	/29 [3-bit]	23 =	8	= 6 hosts + 1 bcast + 1 net base
255.255.255.252	/30 [2-bit]	22 =	4	= 2 hosts + 1 bcast + 1 net base
255.255.255.254	/31 [1-bit]	21 =	-	invalid (no possible hosts)
255.255.255.255	/32 [0-bit]	20 =	1	a host route (odd duck case)
```

Some Quick Notes: 
An IP number has four 8-bit octets. Since each binary bit has two possible values, either on or off (0 or 1), each octet can represent 28 = 256 decimal numbers (0..255). If we count up all 32 bits (4x8=32), we have an Internet of 256x256x256x256 = 232 = 4,294,967,296 possible addresses. That's too many for any one network; this number is segmented into more manageable chunks, or subnets, via routing. The network base address and subnet mask determines what portion of the 32-bit Internet belongs to a given subnet.

A network interface (NIC) should not waste its processing power looking at any and all IP traffic. We want each NIC to ignore anything not meant for itself. A subnet mask provides a way to quickly and efficiently filter out anything not meant for our subnet. NICs on hosts, routers, etc., use a combination of network "base" address and "mask" to determine what to ignore and what to listen to.

The netmask shorthand notation (the /##'s) just specifies how many 1's to _keep_ to determine the _network_ address of an interface. Each octet has eight 1's. With no masking, that's "11111111.11111111.11111111.11111111". The netmask would be 0.0.0.0 or just /0, meaning look at all the ones in all the octets -- the entire Internet. Again, we generally do not want a NIC to listen for the entire Internet.

The netmask is called a "mask" because it also tells how many 1's on the left-hand side to mask-out when figuring out a specific _host_ address.

For a "Class C" or "8-bit" subnet (32-24=8), the network interfaces only care about the last octet. So we use 255.255.255.0, or its shorthand equivalent, /24.

For a Class B or "16-bit" subnet (32-16=16), we need the details of the last two octets. So we use 255.255.0.0, or /16.

A Question to See if You're Awake: 
Question: How many 9-bit subnets can fit into a 13-bit subnet?

Answer:

213
-- = 
29	213 - 9 =	24 = 16
A Non "8-bit" Example: 
207.199.153.192/27 is a "5-bit" subnet (32-27=5). There are 32 IP's in the subnet. The "base" address or first IP of the range is simply 207.199.153.192, and is unusable as a host address. The 30 Usable IPs are 207.199.153.193..207.199.153.223. The last one, 207.199.153.224, is the broadcast address for the subnet. Similar to the network base address, the broadcast address is not usable as a host address.

General Network Architecture: 
The internal subnetting uses the private "Class B" network, 172.16.0.0/16, divvied up as follows:

```
network/mask	usable IP address range	bcast address	location
172.16.1.0/24	172.16.1.1..172.16.1.254	172.16.1.255	Chantilly
172.16.2.0/25	172.16.2.1..172.16.2.126	172.16.2.127	Leesburg
172.16.3.0/25	172.16.3.1..172.16.3.126	172.16.3.127	Alexandria
172.16.4.0/24	172.16.4.1..172.16.4.254	172.16.4.255	Winchester
172.16.5.0/24	172.16.5.1..172.16.5.254	172.16.5.255	Arlington
172.16.6.0/24	172.16.6.1..172.16.6.254	172.16.6.255	Washington
```

With a Class B of 65+ thousand host addresses (256x256) to burn up, efficiency isn't often much of an issue for a "private" subnet. However, note that the 7-bit (32-25=7) subnets 172.16.2.128/25 and 172.16.3.128/25 are going unused. Sticking to "plain jane" 8-bit ("Class C") subnetting would simplify life. On the private network, we'd have 254 possible 8-bit subnets.

Network Base Address and Broadcast Address: 
The network base address is the first IP address in a given subnet; the broadcast address is the last. There's nothing "special" about these first and last numbers in the math; it's just the engineering specification that defines them to these functions. All NICs have to listen for traffic directed at their specific IP address(es) and the broadcast address for their subnet. The base network address is all 0's for the hostid and refers to the subnet itself; the broadcast address is all 1's and refers to all hosts on the subnet.

32-bit Octal to Dotted Quad Decimal Conversion: 
Computers love octal math because they're essentially binary in nature (they like a switch to be either OFF/0 or ON/1) the same way humans like base ten (because we count on our fingers). Our base ten tendencies cause our eyes to glaze over when presented with octal numbers. Still, some understanding of the octal number system helps us comprehend IP networking a bit more clearly.

The eight "places" in 11111111 equate to 128 64 32 16 8 4 2 1.

So, the following numbers are equivalent:

```
10000000.00001010.00000010.00011110	32-bit Octal
128.10.2.30	Dotted Quad Decimal
Octal	Decimal (128.10.2.30)
-	128	64	32	16	8	4	2	1	ttl
10000000	128 +	0 +	0 +	0 +	0 +	0 +	0 +	0 =	128
00001010	0 +	0 +	0 +	0 +	8 +	0 +	2 +	0 =	10
00000010	0 +	0 +	0 +	0 +	0 +	0 +	2 +	0 =	2
00011110	0 +	0 +	0 +	16 +	8 +	4 +	2 +	0 =	30

```

The reverse is a little bit like long division. For each octet, just keep grabbing the biggest power of two in whatever's left till we get to 0.

```
11001111.11000111.10011001.11000010	32-bit Octal
207.199.153.194	Dotted Quad Decimal
Decimal (207.199.153.194)	Octal
-	128	64	32	16	8	4	2	1	-
207 =	128 +	64 +	0 +	0 +	8 +	4 +	2 +	1	11001111
199 =	128 +	64 +	0 +	0 +	0 +	4 +	2 +	1	11000111
153 =	128 +	0 +	0 +	16 +	8 +	0 +	0 +	1	10011001
194 =	128 +	64 +	0 +	0 +	0 +	0 +	2 +	0	11000010
```




