---
layout: thought
title: "The Case for Off-Chain Data Storage"
date: 2017-09-18
excerpt: " Lets use blockchain smart contracts to act as a trusted database administrator and log management system."
tags: [Cryptocurrencies, Blockchain, Data Management, Data Storage, Data]
comments: true
---

With the growing popularity of blockchains in 2017 we are seeing a huge increase in the capacity of data being stored and managed with this data structure. This is in large part due to the amount of data that is being stored on-chain as well as the number of people who have begun to use the blockchain networks. As such, these increases have been the main contributors to the growth of a blockchain network's total network data storage.

Along with this, as the blockchain grows the network capacity to store data grows multiplicatively. In other words, if there's 100 nodes and 1MB of data is added to the blockchain the network capacity grows by 100MB because all 100 nodes must remain in sync. This by design is horribly inefficient which is where I see the need for improvements as these blockchain networks gain wider adoption.

The main advantage that blockchain provides over traditional databases is that all users can be certain of all other users actions because all users register their actions in the ledger which is logged for everyone to see. This in turn provides a guarantee of the data stored in the blockchain because an immutable record of all actions is provided to all network participants. For many, this is an advantage that has lead to the surge of usage of this data structure.

For others, it has disadvantages such as privacy concerns as well as data capacity concerns. In terms of privacy, any data that is stored on-chain should be considered public which can be concerning to companies who are storing PII or proprietary information that they do not wish to be shared. This has lead to the emergence of private blockchains where only parties that are trusted to know all on-chain data can enter the network as a node. However, these private blockchains do not address the concern of network capacity growth, but do naturally circumvent the concerns because they're fewer nodes on private blockchain networks.

Other potential solutions to the privacy concerns is the use of fully homomorphic encryption (FHE) and Merkle trees. Both of these provide different advantages, but in turn both contribute to balance between privacy and trust. FHE intends to use zero knowledge proofs to operate and in time will certainly help alleviate concerns of data privacy. On the other hand, Merkle trees can be constructed in a way, to provide limited availability to unique identifiers of a person such as date of birth. In other words, there are a few approaches to the concern of privacy when it comes to data stored on public blockchain data structures.

That leaves us with the question of, how do we approach the growing size of blockchains in an efficient storage of data while maintaining the decentralized and immutability properties of blockchains. With this I believe a balance can be struck by using the blockchain to manage read and writability of a cloud structure of "centralized" databases. (Centralized meaning hosting a copy of the database is optional) When a person wants to be able to write or read a piece of data from the database they make a request to the blockchain that places certain limitations on the capabilities. (e.g. length of access time, data accessible, etc) In essence the blockchain uses smart contracts to act as a trusted database administrator to grant access and as a log management system that is lightweight for all nodes to keep in sync.

This leaves the question of how can one be certain that all participating nodes can properly filter malcious activity and can reach a consensus that the data stored in their database is the same as all other nodes. This is achieved by granting reputation tokens when they are within sync of the majority of nodes. (> 50% seems reasonable, but this could be raised if necessary) In return once a node has achieved a trusted status they can then make increasingly larger read accessibility of anonymous data stored on the network for the purposes of macro analysis. In other words, as a node becomes more trusted they can use the data to better understand trends.

In terms of privacy, this creates a balanced compromise between privacy of individual users while allowing for data aggregation with the added bonus of reducing the amount of data that has to be stored on-chain. The additional benefits of off-chain storage is that scalability of a blockchain is increased because the barrier of entry is reduced.

What's your thoughts on a concept like this or an idea similar in nature? Have you seen other people looking to build similar systems or do you see any obvious flaws? Let's start a discussion in the comments section below about how this idea should be improved and whether it's worth the effort to develop.
