# Types of Delay

## **Transmission Delay**

The time required to **push** all bits of a packet into the transmission medium.

#### **Formula**

`Transmission Delay = Packet Size (bits) / Bandwidth (bps)`

{% hint style="info" %}
* **Packet size** – Larger packets take more time to be transmitted.
* **Bandwidth** – Higher bandwidth reduces transmission delay.
{% endhint %}

#### **Example**

* Sending a **1 MB (8 million bits)** file over a **100 Mbps** network:&#x20;

Transmission Delay = 8,000,000 bits / 100,000,000 bps = 0.08 seconds(80ms)

## Retransmission Delay



## **Propagation Delay**

The time taken for a data packet to **physically travel** from sender to receiver through the transmission medium.

#### **Formula**

`Propagation Delay = Distance / Propagation Speed`

{% hint style="info" %}
* **Distance between sender and receiver** – Longer distances lead to higher delays.
* **Propagation speed of the medium** – Speed varies for fiber optics, copper cables, and wireless.
{% endhint %}

#### **Example**

* If a signal travels **3000 km (3,000,000 meters)** through a fiber optic cable (**200,000 km/s**): Propagation Delay = 3,000,000 m / 200,000,000 m/s = 0.015 seconds(15ms)

#### **Typical Propagation Speeds**

| Medium         | Speed (m/s) |
| -------------- | ----------- |
| Fiber Optic    | 2 × 10^8    |
| Copper Cable   | 1.5 × 10^8  |
| Wireless (Air) | 3 × 10^8    |

## **Processing Delay**

The time taken by routers, switches, or end devices to **process** an incoming packet before forwarding it.

{% hint style="info" %}
* **Router/switch performance** – More powerful devices process packets faster.
* **Packet header complexity** – Encrypted or large headers require more processing.
* **Network congestion** – Overloaded devices slow down processing.
{% endhint %}

#### **Example**

* A firewall **inspecting** a packet’s content might introduce **5 ms** of processing delay.

#### **How to Reduce Processing Delay?**

* Use **faster routers and network devices**.
* Optimize **routing tables** to reduce lookup time.
* Use **stateless packet filtering** instead of deep inspection when security allows.

## **Queuing Delay**

The time a packet spends **waiting in a buffer** before it gets transmitted due to network congestion.

#### **Formula**

`Queuing Delay = (Number of Packets in Queue×Packet Size ) / Bandwidth`

{% hint style="info" %}
* **Network congestion** – High traffic causes longer wait times.
* **Queue size** – Limited buffer space can drop packets.
* **Traffic prioritization** – QoS settings can favor important packets.
{% endhint %}

#### **Example**

* A **VoIP call packet** waiting **10 ms** in a queue due to high network traffic.

#### **How to Reduce Queuing Delay?**

* Use **Quality of Service (QoS)** to prioritize real-time traffic.
* Increase **network bandwidth**.
* Use **Load Balancers** to distribute traffic across multiple paths.

Serialization Delay



Deserialization Delay



Acknowledgment Delay (ACK Delay)



Buffering Delay



Software Processing Delay



Congestion Delay

Handoff Delay (in Wireless Networks)

DNS Resolution Delay







## **Example**

### Web Page Load Time

Assume a web page request travels **4000 km** via fiber optic cable, passing through **3 routers**, with a **1 MB** page size on a **100 Mbps** connection.

<table><thead><tr><th width="462">Delay Type</th><th>Value</th></tr></thead><tbody><tr><td>Transmission Delay</td><td><strong>80 ms</strong></td></tr><tr><td>Propagation Delay</td><td><strong>20 ms</strong></td></tr><tr><td>Processing Delay</td><td><strong>5 ms × 3 routers = 15 ms</strong></td></tr><tr><td>Queuing Delay</td><td><strong>10 ms</strong></td></tr><tr><td><strong>Total Latency</strong></td><td><strong>125 ms</strong></td></tr></tbody></table>
