# Fundamentals of Networking
### Section 1: IP Address Basics
Networking all starts with IP addresses. An IP Address is a unique number that identifies a network interface/address on a Local Area Network (LAN). Think of it like a phone number for your computer. An IP address has a unique set of numbers and is divided up into 4 groups separated by periods (such as 192.168.1.1). IP addresses have many different ranges and meanings behind them, for example the IP 10.0.0.1 is different from 134.49.12.87.

### Section 2: Public vs. Private IP Addresses
The reason these are different is because they are private and public IP addresses. A private IP address is only used on a network that cannot reach the outside internet without a gateway (such as a LAN). However, public IP addresses are mostly used to be assigned to modems to be able to communicate from a LAN to the global internet (WAN), though any network device can receive a public IP address. Private IP addresses are only assigned to devices inside a LAN that already has a gateway in its network.

### Section 3: IP Assignment (DHCP vs. Static)
IP Addresses can be assigned automatically or done manually. The way that IP Addresses are assigned automatically is through a service called DHCP. DHCP stands for Dynamic Host Configuration Protocol and is used to automatically assign a device on its network with a new IP address if the device is not recognized. Manually configured IP Addresses are called Static IP Addresses that do not change unless an administrator changes them. This is commonly used on devices that are always on the same network and do not leave (for example Servers, Access Points, Routers, etc). Having a static IP Address is good for devices that have to stay online or in the same place so you know its IP at all times. Having a DHCP IP Address is good for when you are constantly disconnecting and reconnecting from the network and you don’t need it to stay on the same IP.

### Section 4: Private IP Address Ranges & Subnetting
Private IP Addresses have specific ranges that can only be used on a Private LAN. An example IP Address would be 192.168.0.1; this IP Address is only available on a private network and will not be discovered on the internet. The IP subnet 192.168.0.0/24 means that any IP within that range stays on a LAN.

But what does the /24 at the end do? The /24 at the end of 192.168.0.0 specifies how many IP Addresses that subnet can provide. With the IP Subnet of 192.168.0.0/24, this means that its range is 192.168.0.1 - 192.168.0.255. The /24 at the end provides 255 IP addresses on the LAN.

But 192.168.0.0/24 is not the only private IP subnet you can use. You can use an IP address that starts with 192.168.X.X on any LAN as this IP range is reserved for Private LANs, as well as 10.X.X.X and 172.16.X.X - 172.31.X.X:

192.168.0.0/16: The IP range can go from 192.168.0.1 - 192.168.255.255 and can have over 65 thousand IP Addresses. Designed for homes and small businesses.

172.16.0.0/12: The IP range can go from 172.16.0.1 - 172.31.255.255, which is over 1 million IP Addresses. Meant for medium-sized businesses and organizations.

10.0.0.0/8: For the subnet 10.0.0.0/8, you can have an IP between 10.0.0.1 all the way up to 10.255.255.255. That's over 16 million IP Addresses! Designed for large enterprise networks with multiple sites.

All these private IP Address ranges are designed for different purposes, but it doesn't matter what setting you're in most of the time—just as long as you follow these ranges in your private network to ensure security.

### Section 5: Domain Name System (DNS)
Instead of using IP Addresses, you can use something called DNS. DNS stands for Domain Name System, which basically turns IP Addresses into domain names or the other way around. Think of it as instead of typing in a phone number to contact someone, you can just type in words to reach them. Take Google's IP for example: Google's IP is 142.250.195.142, but instead, you just type in google.com and it works. DNS has been designed to take domain names and transform them into IP Addresses for easier communication between devices.

### Section 6: Wired Infrastructure and Ethernet Cabling
Another amazing thing about networking is how data gets sent between devices. There are 2 main types: Wired and Wireless. Using a wired connection involves things such as Ethernet cables, fiber optic cables, phone lines, and even coaxial cables depending on your connection. Using ethernet cables is the most standard type of connection for communication, specifically due to its ease of use.

Ethernet cables are usually terminated on their ends with an RJ45 connector, which consists of 8 pins on top for each of the 8 wires in a specific order. The ethernet cable is made up of 4 twisted pairs that are color-coded with green, orange, blue, and brown so you can easily distinguish which needs to go where. The common standard for ethernet cable wiring is type T568B, which has been used around the world for many years. However, there is another standard called type T568A, which is similar to T568B, but its colors have been swapped around. Nonetheless, the colors of the connection don’t matter; it's about how fast the connection can be delivered.

Ethernet cables come in different types ranging from CAT1 all the way to CAT8. While having a CAT1 cable can still technically work, it is not recommended for daily use. Ethernet cables go in the following order: CAT1, CAT2, CAT3, CAT4, CAT5, CAT5e, CAT6, CAT6A, CAT7, and CAT8. The "CAT" stands for Category, with each cable having different speed ranges and efficiency. The most common ethernet cable that gets used to this day is CAT5e because of its efficiency and range—its speeds go up to a gigabit and it can run up to 100 meters. While buying a CAT8 cable sounds like the best option for speed, it is definitely not the best option for price. While a box of CAT5e cable can cost around $100 for 300 meters, a box of CAT8 cable can cost over a grand. This is why CAT5e is still widely used.

### Section 7: Wireless Networking (Wi-Fi)
Having a wireless connection can also be very efficient due to the fact that there are no cables required, it works with a lot of wireless devices, and overall it is great for general use where extreme speed isn't a strict requirement. Wireless connections are done by using invisible radio frequencies that go through the air and reach your device's receiver.

Wireless connections are most commonly used through either the 2.4 Gigahertz (2.4GHz) band or the 5 Gigahertz (5GHz) band. The main difference between these two is speed and range:

2.4 GHz: Supports long-range devices, but its speed is not as fast or efficient as 5GHz.

5 GHz: Very efficient and fast, but does not have as much range compared to 2.4GHz.

Most performance factors depend on what channel the frequency is set to, the channel bandwidth, any environmental interference, and whether the client device is capable of receiving it.

**Written By:** Matthew Sutherland

---

# Quiz
### Question 1
What is the primary function of an IP address on a network?

**Difficulty:** easy
**Points:** 10

- [ ] To measure network bandwidth speed

- [x] To uniquely identify a network interface on a Local Area Network (LAN)

- [ ] To convert domain names into words

- [ ] To encrypt wireless radio signals

### Question 2
What is the main difference between a Public IP address and a Private IP address?

**Difficulty:** medium
**Points:** 10

- [ ] Public IPs are assigned manually; Private IPs are always assigned automatically

- [ ] Private IPs are used on the global internet; Public IPs are only used on internal LANs

- [x] Private IPs are restricted to local networks; Public IPs are used to communicate across the global internet (WAN)

- [ ] Public IPs only work over wireless connections

### Question 3
Which protocol automatically assigns IP addresses to devices when they join a network?

**Difficulty:** easy
**Points:** 10

- [ ] DNS

- [x] DHCP

- [ ] PSTN

- [ ] TCP

### Question 4
Why would a network administrator configure a Static IP address instead of using DHCP?

**Difficulty:** medium
**Points:** 10

- [ ] To increase the wireless radio frequency range

- [ ] To allow the device to automatically change IPs whenever it reboots

- [x] To ensure permanent infrastructure (like servers and routers) keeps the same address continuously

- [ ] To bypass the need for a gateway router

### Question 5
How many usable IP addresses are typically provided by a /24 subnet mask (such as 192.168.0.0/24)?

**Difficulty:** medium
**Points:** 10

- [ ] 8

- [ ] 16

- [x] 255

- [ ] Over 16 million

### Question 6
Which private IP address range is specifically designed for massive enterprise networks requiring millions of IP addresses?

**Difficulty:** medium
**Points:** 10

- [ ] 192.168.0.0/16

- [ ] 172.16.0.0/12

- [x] 10.0.0.0/8

- [ ] 127.0.0.1/32

### Question 7
What is the primary purpose of DNS (Domain Name System)?

**Difficulty:** easy
**Points:** 10

- [ ] Assigning IP addresses to new network interface cards

- [x] Translating human-readable domain names (like google.com) into numerical IP addresses

- [ ] Terminating Ethernet cables into RJ45 connectors

- [ ] Switching connection frequencies between 2.4GHz and 5GHz

### Question 8
What type of connector is standard on the end of a typical Ethernet cable?

**Difficulty:** easy
**Points:** 10

- [ ] Coaxial

- [x] RJ45

- [ ] Fiber SC

- [ ] PSTN

### Question 9
Why is CAT5e still one of the most widely used Ethernet cables today?

**Difficulty:** medium
**Points:** 10

- [ ] It is the newest standard and fastest cable available

- [ ] It is the only category that supports 8-pin RJ45 connectors

- [x] It provides gigabit speeds up to 100 meters at a cost-effective price point

- [ ] It runs over radio frequencies without requiring physical wire pairs

### Question 10
Compared to the 5 GHz wireless frequency band, what is a key feature of the 2.4 GHz band?

**Difficulty:** easy
**Points:** 10

- [ ] Higher peak data speeds

- [x] Better physical range and distance coverage

- [ ] Lower resistance to physical obstacles

- [ ] Requirement for RJ45 termination