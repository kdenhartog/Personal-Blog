---
layout: thought
title: "Quantifying Trust: Is it possible?"
date: 2017-08-20
excerpt: "If we can build a system that has guarantees of identity verifiability and immutability than how do we quantify trust?"
tags: [Blockchain, Trust, Identity]
comments: true
---

Yesterday, [@trbouma](https://twitter.com/trbouma), [@tristanhoy](https://twitter.com/tristanhoy), and I begun discussing the relationship of digital identity and trust. In this discussion both of them made interesting points that lead me to suggest some discussions that I've had with [@ThisGuyHarrison](https://twitter.com/ThisGuyHarrison). Through my discussions I've reached the conclusion that it is difficult to quantify trust with digital identities because digital identities are unverifiable and mutable. In this blog post, I'll make the supporting argument for quantifying trust.

Starting off, I think it is important to define trust. According to [Merriam-Webster](https://www.merriam-webster.com/dictionary/trust) trust can be defined in a few ways. The one I want to address is, **"assured reliance on the character, ability, strength, or truth of someone or something".**

With this definition of trust we see evidence to support the point made by Tim that, "Trust is not an inherent property of a #digitalidentity. #Trust is the decision of the relying party."

This can be seen by the usage of "assured reliance... " rather than "guaranteed reliance...". It's important to understand this distinction because "assured reliance" requires more due diligence than guaranteed reliance. Which leads into the next important point that Tristan made.

If we cannot guarantee trust, than it is not possible to "create" trust with crypto which is also true. However, trust is possible to quantify with crypto and blockchain data structures because it now provides a property that digital identities currently lack, immutability. With immutability we can now trust the history of an identity because the identity and it's inherent properties are kept in a blockchain structure.

We also need verifiable guarantees that an identity has not been manipulated with a sybil attack to quantify trust. This is important to address in order to prevent false records of interaction through sybil attacks. In other words, having a historical record of every interaction is not good enough to quantify trust, we also must have a way to verify that the records are real and representative of what actually occurred.

I am still trying to identify a way in which it is possible to create this verifiability in a decentralized structure. There's been some good progress made on this by [PoI tokens](http://proofofindividuality.online/), but I think there are some usability concerns that still need to be addressed. In particular, if a user is unable to attend the monthly hangout session, Is there identity not to be trusted for a month? Some other systems we've traditionally used to address this issue was "trusted" third parties such as governments. Their jobs were to create "trusted records" and to economically disincentivize faking records (E.g. Writing laws to punish those who create fake IDs/corruption laws). We've seen that even this model has flaws though because the "trusted" third party could go rogue or the "trusted" third party could be imitated.

So the question becomes, if we can build a system that has guarantees of identity verifiability and immutability than how do we quantify trust? We can create algorithms to traverse the records and create a numeric measurement of trust which can be reliably used to identify quickly if a person should be trusted. Some examples of algorithms that do this in similar ways would be Ebay's reputation system and Google's PageRank algorithms. Both of these have their drawbacks too as can be seen by the argument made by Christopher Allen [here](http://www.lifewithalacrity.com/2005/12/collective_choi.html). What these algorithms do suggest though is that it is possible to quantify trust which in turn can be used to increase the speed in which we can establish "trusted" relationships in both the physical and digital worlds.

After all, the only improvements we can make to trust is to increase the speed of which a person can be trusted. We cannot guarantee trust because we cannot guarantee another persons future actions or intentions. If we could that would make a large blow to the argument for free-will, but that's another point to be left for another day.
