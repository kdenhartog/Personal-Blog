---
layout: thought
title: "Decentralizing Trust: X.509 PKI vs Decentralized Identity PKI"
date: 2021-07-11
excerpt: "Decentralized Trust on the internet is about enabling users to decide who to trust and that doesn't take bleeding edge tech to achieve."
tags: [Trust, Decentralized Identity, Identity, X509, Certificate Authorities]
comments: true
---

Decentralized trust doesn't need Decentralized Identifiers or Verifiable Credentials. It can be achieved today using plain old X.509 certificates, Certificate Chains, and user experiences that enable users to choose their own root certificate authorities. There I said it. As an advocate for decentralized identity technologies and an engineer who's spent the last 5 years evaluating identity systems, I've come to conclude that the key to enabling self sovereign identity technologies is less about new technologies and new standards and more about how we choose to think about the problems. To a certain degree as well, it's about choosing to put our time and efforts into enable new capablities. Let me expain how I've concluded this.

Today, one of the core concepts of decentralized identity is the ability to enable users to manage their own cryptographic keys. Which also happens to be the core problem that X.509 is faced with as well. Because as the saying goes "not your keys, not your __bitcoin__ identity".

