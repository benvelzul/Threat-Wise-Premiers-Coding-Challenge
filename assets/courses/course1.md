# Fundamentals of VoIP/SIP systems and UDP vs TCP protocols.

### Section 1: What is VoIP?
VoIP stands for Voice over Internet Protocol (or Voice over IP) meaning that instead of using old copper phone lines to deliver voice calls you can use the internet to deliver them instead. VoIP systems are very common in today's standard and they vary depending on the service you would like to receive. VoIP systems are commonly found in businesses/enterprises for quality and efficient voice communication. 
### Section 2: Transport Protocols (UDP vs. TCP)
VoIP systems are transported usually with UDP (User Datagram Protocols) via SIP connectivity over a LAN (Local Area Network) or a WAN (Wide Area Network). VoIP calls are usually transferred via SIP by using UDP however using TCP (Transmission Control Protocol) can also be done. UDP Packets are used in times where speed is a priority over accuracy. Meaning that UDP packets are very fast but are not very reliable in terms of whether the destination endpoint will receive it. TCP packets are more reliable in terms of the packet making it to its destination endpoint but its speed is not as good compared to UDP. 
### Section 3: Audio Codecs
VoIP calls also have specific audio codecs for different transmission types over a network. The most common audio codec is G.711 (also known as u-law) with it being the universal standard for VoIP calls across traditional IP telephone systems. G.729 (also known as A-Law) is also another common audio codec which is usually used for it being highly compressed, saving bandwidth when being used across a network. While these audio codecs may be the most common they do not deliver the best audio quality unlike G.722 (also known as HD Voice). This audio codec is the best of the best for VoIP calls and is traditionally used on many VoIP phones today (such as Yealink, Polycom, Grandstream, Cisco, etc) due to its outstanding sound.

### Section 4: System Providers and Call Types
VoIP systems can be offered by a provider for example Microsoft Teams, 3CX, 8x8, RingCentral, etc and these VoIP systems are usually paid on a subscription with an annual renewal most of the time costing a certain amount of money per user depending on the plan you get. VoIP systems also have the ability to allow internal and external calls. Internal calls happen only on your VoIP system within your network and can operate from one endpoint to another very flawlessly on the same LAN. External calls are used when you want to have communication with someone outside of your network or at another site. These calls usually happen over a WAN and most of the time also requires a PSTN (Public Switched Telephone Network) to operate. A PSTN allows companies to make these external calls with their own phone number that can be provided from large telecoms such as Telstra, Vodaphone, Optus etc. Having these PSTN allows these external calls to work very efficiently with customers outside of your network or offsite. 
### Section 5: Self-Hosting and Media Capabilities
Some companies even let you host your own free VoIP system for your own network for example Sangoma, 3CX, RingCentral, etc which can be very useful for those wanting to experiment with it. VoIP systems don't only allow voice calls but also allow video calls with it, however this isn't as common due to most providers having this option marked at a higher price.

### Section 6: Advanced VoIP Features and IP PA Integration

These VoIP systems also allow many other features such as paging, intercom, provisioning, auto attendant, call recording, ring groups etc and having these features allow calls to be handled differently in comparison to a traditional copper line system. Looking at the features of intercom this allows a user to deliver messages to multiple phones at once or to have it broadcasted over speakers in different zones like a traditional PA System. Having an IP PA system is very efficient in terms that you can make a PA message at any time and even have the ability to dial different zones in a building or site and even have it play pre-recording announcements at times or play bells when scheduled. There are many companies that allow you to integrate your existing VoIP system into a PA system such as the Jacques IP PA System, Algo, TOA, Hikvision etc. Having these IP PA Systems is very efficient in places such as large sites or schools to be able to deliver messages at once without a worry. These IP PA systems even allow you to at some times be able to play music over sets of speakers making it useful for places like festivals or shopping centers. These IP PA systems are also very efficient at delivering emergency signals in the event of one.

**Written By:** Matthew Sutherland. 

## Questions

### Question 1
What does the acronym VoIP stand for?

**Difficulty:** easy
**Points:** 10

- [] Voice over Internal Protocol

- [x] Voice over Internet Protocol

- [] Virtual Online IP Phone

- [] Variable Output Interface Protocol

### Question 2
Why is UDP (User Datagram Protocol) usually preferred over TCP for VoIP calls?

**Difficulty:** medium
**Points:** 10

- [] UDP guarantees every packet arrives without loss

- [] UDP is cheaper to implement across a LAN

- [x] Speed is prioritized over accuracy in real-time voice calls

- [] UDP encrypts the audio content automatically

### Question 3
What is the primary advantage of TCP compared to UDP?

**Difficulty:** medium
**Points:** 10

- [] It delivers faster transmission speeds

- [] It reduces overall network bandwidth consumption

- [x] It is more reliable in ensuring packets reach their destination

- [] It is required for high-definition voice codecs

### Question 4
Which audio codec is recognized as the universal standard for traditional IP telephone systems?

**Difficulty:** easy
**Points:** 10

- [x] G.711 (u-law)

- [] G.729 (A-Law)

- [] G.722 (HD Voice)

- [] AAC-LD

### Question 5
What is the main benefit of using the G.729 (A-Law) audio codec?

**Difficulty:** medium
**Points:** 10

- [] It offers the highest fidelity and audio clarity

- [x] It is highly compressed, which saves network bandwidth

- [] It operates without using IP packets

- [] It allows video and audio to sync automatically

### Question 6
Which audio codec provides the best sound quality ("HD Voice") on modern IP phones?

**Difficulty:** easy
**Points:** 10

- [] G.711

- [] G.729

- [x] G.722

- [] UDP-Audio

### Question 7
How do internal VoIP calls differ from external VoIP calls?

**Difficulty:** medium
**Points:** 10

- [] Internal calls require a PSTN connection, while external calls do not

- [x] Internal calls take place within the same LAN; external calls connect offsite over a WAN

- [] Internal calls use TCP, while external calls must use UDP

- [] Internal calls only support video, while external calls only support audio

### Question 8
What service is required to enable external VoIP calling to phone numbers outside your network?

**Difficulty:** medium
**Points:** 10

- [] Local Area Network (LAN)

- [x] Public Switched Telephone Network (PSTN)

- [] Self-hosted DNS Server

- [] G.722 Codec License

### Question 9
Which of the following features is provided by VoIP systems but NOT typically found on traditional copper line systems?

**Difficulty:** easy
**Points:** 10

- [] Analog signaling

- [x] Auto attendant, ring groups, and intercom paging

- [] Mandatory PSTN subscription for local extensions

- [] Physical copper wiring between all internal extensions

### Question 10
How can an integrated IP PA system benefit a large site or school during daily operations or emergencies?

**Difficulty:** easy
**Points:** 10

- [] It converts all voice traffic from UDP to TCP automatically

- [] It replaces the need for a WAN or PSTN connection

- [x] It allows live announcements by zone, scheduled bells, and immediate emergency signals

- [] It eliminates the need for audio codecs on the network