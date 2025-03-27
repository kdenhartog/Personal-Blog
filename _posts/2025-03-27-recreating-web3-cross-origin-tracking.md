---
layout: thought
title: "Web3 is Reintroducing Cross-Origin Tracking Accidentally"
date: 2025-03-27
excerpt: "We should expect that when the user shares their address that will act as implied consent for cross-origin tracking in the same way cookie notices act as a prompt for tracking."
tags: [Web3, Wallet Addresses]
comments: false
---

In the context of Web3 we're currently walking down a dangerous path accidentally, and it's not something being discussed enough. When a user connects to a site with Web3 capabilities enabled the site first requests the user to share a wallet address with them. This paradigm was set primarily by some choices that were made early on by Metamask as a means of protection for the user. At the time these were beneficial, but over time we've recognized some tradeoffs between UX and privacy because of it. Let's explore those further.

### The UX paradigm of sharing an account address is discrete

The permissions design of this started out as a low level paradigm where the DApp only needed the wallet address and could fetch state itself from the chain. This led to a thin client design where the site and the UX for different interactions are largely determined by the site. However, because the majority of the application logic is handled by the site itself it also means that the site has to operate in a more trusted context. Both in terms of security and privacy.

Additionally, as we've added more functionality to the wallet to try and improve the UX, such as EIP-4361 (Sign in With Ethereum) it's led to an antipattern in the UX. In order to create a "login" flow, the user first has to share the wallet address, then they have to approve a specifically structured transaction using EIP-191. Because of the order of operations of design and the focus on not conducting breaking changes to the Web3 platform APIs (e.g. what the wallet makes accessible to the site) we've now added a tiny bit of debt to the UX paradigm rather than combining these operations into a single design interface.

### The account address paradigm trust model doesn't align with the browsers

In the context of a modern browser, most sites are isolated into their own sandbox. This occurs both at the OS process level in order to prevent sites open in one tab from tampering with other sites in another tab either at a deeper memory level or at a more functional script injection level. It also happens at a storage layer through the partitioning of localStorage, cookies, IndexedDBs, etc. Essentially, sites are separated into what's called an "origin" in the browser and that origin identifier (such as https://example.com) becomes the boundary.

This is why "cross-origin" communication is considered an explicit exception. Examples of this would be using CORS for a site to approve the loading of a cross-origin script it trusts. This is ultimately rooted back in the security model (and more recently privacy model) of the browser. Over and over we've learned that trusting sites is a mistake because users aren't always able to identify when sites are doing things that aren't in their best interest, such as tracking them for dynamic pricing or crowding a page with personalized ads. So what sort of problems should we expect to come in Web3 because our Web3 platform API is too trusting of the site?

### My prediction for problems to occur in Web3

We should expect that when the user shares their address that will act as implied consent for cross-origin tracking in the same way cookie notices act as a prompt for tracking. The problem here is that as wallets share wallet addresses across different sites, it will become a global identifier used for the purposes of tracking a user and building a copy of their browsing history server side even if the user doesn't perform an onchain transaction. This could be as simple as an RPC service provider who's already got a large customer base of wallets and DApps taking this information and building a dataset to sell with it, or it could be a DApp or Wallet doing it directly themselves. Chainalysis has already been doing this for the purposes of correlating wallet addresses to users to sell to governments. What's to stop someone like them from entering into the web advertising business too because so much of the web3 space is leveraging them for compliance purposes?

Furthermore, once they've built this profile all future onchain transactions will be correlated to the shadow copy of the users browsing history (built in the same way they're built with 3P cookies) and economic activity (such as what they buy with stablecoins) to build deeper behavioral profiles to sell them more goods or serve them more personalized ads. In other words, we really shouldn't re-introduce this given all major web browser vendors have been moving towards phasing out 3P cookies. But if we can't share a wallet address how can we solve this problem?

### A paradigm beyond sharing a cross-origin globally unique identifier (wallet address)

The answer in my opinion here lies in going down the thick client approach rather than thick app approach. What I mean by "thick" is where the majority of application logic is handled. Today, much of the UX, unsigned transaction generation, and many other aspects are handled by the site. This is probably because the site has no way to request the wallet handles this for them and because the site has desires to build a brand recognition around their protocol using the UX from the site as an value differentiator.

However, we can imagine a world where the site casts an intent to the wallet, such that the wallet can display and generate the necessary information to display to the user. A toy example, I like to use here is through a very specific API designed for checking out and paying with Web3.

A wallet could enable the following API to perform a checkout operation without needing to share an address:

```
const checkoutTxn = await window.ethereum.request({
	"method": "wallet_checkout",
	"params": {
		"recipient": "eip155:1:0x1234abc", // an address to send to
		"amount": "100.01",
		"currency": ["eip155:1:0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", "eip155:1:0xdAC17F958D2ee523a2206206994597C13D831ec7"]
	}
});
```

In this you'll notice a different paradigm. First, the wallet doesn't need to send the wallet address to the site so it can generate the transaction, instead it will leave it up to the wallet to decide this. Second, the site communicates what it desires to the wallet and lets it decide how to handle it. So for example, it wants the user to send $100.01 worth of either USDC on Base L2 or USDT on mainnet which is communicated based on the currency contract address. If the user doesn't have USDC or USDT on the proper network the wallet can perform the underlying swaps and bridging to assist with completing the intended transaction so that the caller receives the money into the address they expect.

In summary, we shouldn't be looking to perpetuate the legacy antipatterns of web2 in Web3 like third party cookies. Instead, we should be looking to extend the web platform in ways that browsers aren't. In this way the value added capabilities we receive from Web3 for asset ownership become an extension of the web by enhancing it so that we can meet the land of web2 where they're at, rather than building a separate Web3 island and expecting everyone to come join us.
