---
layout: thought
title: "Comparing VCs to ZCAP-LD"
date: 2021-09-25
excerpt: "Verifiable Credentials are well suited for provenanced statements. ZCAP-LD are great for distributed authorization systems."
tags:
    [
        Verifiable Credentials,
        Authorization Capabilities,
        zCaps,
        VCs,
        DIDs,
        Delegation,
        Attenuated Delegation,
        Authorization system,
        system design
    ]
comments: true
---

A few months back, I wrote about some of the edge points of the verifiable credentials data model and briefly mentioned that the authorization capabilites for linked data (ZCAP-LD) data model were a useful technology for addressing these edges for building better distributed authz systems. So what is the differences between these two data models and why am I advocating for the separation of concerns for the two of them? The three main points I want to highlight are the conceptual differences in usages and how the data models assist with the enforcing those concepts. Then I'll highlight the differences in the data models and finally, I'll connect it all together to show how these difference makes a difference when build distributed authz systems.

So conceptually verifiable credentials exists to make provenanced assertions. What does this really mean though? Basically a verifiable credential is a way to know who is making the claims, what the claims are, and who the claims are about and it's done in a standard way so that all parties who issue, hold, and verify the provenance of the claims can do so without having to pre-coordinate their software design. On the other hand, authorization capabilties (ZCAPs) are designed around removing the concept of who the statements are about and rather building around the concept of an "invoker". And it's this difference that allows for an emergence of a different authorization system called object capabilities authorization systems. It's my personal opinion that object capability systems are better for most security models being designed today due to the simplicity for relying parties, but we'll have to save that discussion for a later post.

What's the difference between a subject and an invoker then? The difference is all in the practicality of pairing the claims with the entity. In the verifiable credential by tying all the claims to a subject there's an inherent coupling of the claims to an identity by the issuer. In technical terms it's actually being paired to an identifier which is the "credentialSubject.id" property which means that the claims that are made should really only be extended to a single entity which is the subject of the claims. Anything which extends beyond the original claims made by the issuer is actually a new credential which needs to be evaluated independently of the original veracity of the claims made by the first issuer.

For example, let's look at a proof of assets credential:

```jsonc
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    {
        "@vocab": "https://bank.com/vocab#"
    }
  ],
  "id": "http://example.edu/credentials/1872",
  "type": ["VerifiableCredential", "ProofOfAssetsCredential"],
  "issuer": "did:web:bank.com:branch:id:565049",
  "issuanceDate": "2021-06-04T20:50:09Z",
  "credentialSubject": {
    "id": "did:example:bankAccountOwner",
    "TotalAccountValueInUSD": 4156.62,
  },
  "proof": {
    "type": "Ed25519Signature2020",
    "created": "2021-06-04T20:50:29Z",
    "verificationMethod": "did:example:bankAccountOwner#key-0",
    "proofPurpose": "authentication",
    "proofValue": "..."
  }
}
```

In this example we can see that a bank branch is asserting on behalf of the bank that the bank account owner has a total account value with this bank of $4156.62. Now, let's say the bank account owner has decided to chain their credential to their child so that their child can spend up to $50:

```jsonc
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    {
        "@vocab": "https://bank.com/vocab#"
    }
  ],
  "id": "http://example.edu/credentials/1872",
  "type": ["VerifiableCredential", "ProofOfAssetsCredential"],
  "issuer": "did:example:bankAccountOwner",
  "issuanceDate": "2010-01-01T20:54:24Z",
  "credentialSubject": {
    "id": "did:example:child",
    "TotalAccountValueInUSD": 50.00,
  },
  "proof": {
    "type": "Ed25519Signature2020",
    "created": "2017-06-18T21:19:10Z",
    "proofPurpose": "assertionMethod",
    "verificationMethod": "did:example:bankAccountOwner#key1",
    "proofValue": "..."
  }
}
```

and with this the child is now able to create a verifiable presentation like this:

```jsonc
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
   {
    "@vocab": "https://bank.com/vocab"
   }
  ],
  "id": "did:example:76e12ec21ebhyu1f712ebc6f1z2",
  "type": ["VerifiablePresentation"],
  "verifiableCredential": [
    {
        "@context": [
            "https://www.w3.org/2018/credentials/v1",
            {
                "@vocab": "https://bank.com/vocab#"
            }
        ],
        "id": "http://example.edu/credentials/1872",
        "type": ["VerifiableCredential", "ProofOfAssetsCredential"],
        "issuer": "did:web:bank.com:branch:id:565049",
        "issuanceDate": "2021-06-04T20:50:09Z",
        "credentialSubject": {
            "id": "did:example:bankAccountOwner",
            "TotalAccountValueInUSD": 4156.62,
        },
        "proof": {
            "type": "Ed25519Signature2020",
            "created": "2021-06-04T20:50:29Z",
            "verificationMethod": "did:example:bankAccountOwner#key-0",
            "proofPurpose": "authentication",
            "proofValue": "..."
        }
    },
    {
        "@context": [
            "https://www.w3.org/2018/credentials/v1",
            {
                "@vocab": "https://bank.com/vocab#"
            }
        ],
        "id": "http://example.edu/credentials/1872",
        "type": ["VerifiableCredential", "ProofOfAssetsCredential"],
        "issuer": "did:example:bankAccountOwner",
        "issuanceDate": "2010-01-01T20:54:24Z",
        "credentialSubject": {
            "id": "did:example:child",
            "TotalAccountValueInUSD": 50.00,
        },
        "proof": {
            "type": "Ed25519Signature2020",
            "created": "2017-06-18T21:19:10Z",
            "proofPurpose": "assertionMethod",
            "verificationMethod": "did:example:bankAccountOwner#key1",
            "proofValue": "..."
        }
    }],
    "proof": {
        "type": "Ed25519Signature2020",
        "created": "2019-12-11T03:50:55Z",
        "proofValue": "....",
        "challenge": "c0ae1c8e-c7e7-469f-b252-86e6a0e7387e",
        "proofPurpose": "authentication",
        "verificationMethod": "did:example:assistant#key1"
    }
}
```

Let's break down what is actually being asserted here, who the verifier needs to trust, and how the verifier would go about processing this verifiable presentation. From what we can see here, the bank is asserting that the bank account owner has a total account value of $4156.62, the bank account owner is asserting that their child is authorized to spend $50.00. Seems to make sense, right? Yeah, but the problem here is how is the verifier supposed to be able to trust that the bank account owner verified the child has that money as well, but why should the verifier trust the bank account owner? From their perspective there's two problems here. First, they don't trust any random person to make assertions about the amount of many in another persons bank account. Second, the verifier is unable to correlate the relationship between the bank account owner and the child. From their perspective, the `credentialSubject.id` should be expected to be two opaque identifiers assuming all they've received is this verifiable presentation. So, the problem here is that the verifier is expected to infer knowledge about what is actually being stated here which presents risks in the business processes being encoded into software. Are they to assume that they'll be paid by the bank account owner if the child doesn't pay? The reality is the verifier shouldn't rely upon this verifiable presentation because there's no way to chain the trust and figure out the capabilities that the child should have based only on this verifiable presentation. Sure, they could manage some state about the relationships of the identifiers and coordinate with the bank to know that they'll make sure someone pays, but that leads to bespoke authorization systems built specifically to the business logic which is unlikely to scale to the size of the internet today within a reasonable time frame. Coordination costs are incredibly expensive (look at how long it takes to make a standard) and managing state makes it nearly impossible to generalize the system outside the particular business process it's designed for.

How do ZCAPs address this problem then? First off, it's important to recognize that the model of capabilities lends itself to different statements being made. In the verifiable credential model, traditional I've seen most people making claims about what the subject are. Where as with ZCAPs I've seen the focus of the statements on what the invoker can do. This slight shift combined with the change from a subject to an invoker changes the focus of the verifier to simplify what needs to be checked and makes it more explicit what they're actually checking.

Let's take a look at an example to see what I mean by this:

```jsonc
{
  "@context": ["https://w3id.org/security/v2",
  {
      "@vocab": "https://bank.com/vocab#"
  }],

  // The identifier of this specific zcap object
  "id": "https://example.com/zcap/id/1",

  // Since this is the first delegated capability, the parentCapability
  // points to the target this capability will operate against
  // (in this case, a payment gateway)
  "parentCapability": "https://example.com/paymentGateway",
  
  // the bank account owner is only allowed to spend the amount in their account
  "caveat": [{
       "type": "MaxPayment",
        "maxPaymentValue": 4156.62
  }],

  // We are granting authority to any of bankAccountOwner's verification methods
  "invoker": "did:example:bankAccountOwner",
  
  // Finally we sign this object with cryptographic material from
  // Alyssa's Car's capabilityDelegation field, and using the
  // capabilityDelegation proofPurpose.
  "proof": {
    "type": "Ed25519Signature2018",
    "created": "2018-02-13T21:26:08Z",
    "capabilityChain": [
      "https://example.com/paymentGateway"
    ],
    "proofValue": "...",
    "proofPurpose": "capabilityDelegation",
    "verificationMethod": "did:web:bank.com:branch:id:565049#key1"
  }
}
```

Now for the bank account owner to authorize their child to spend $50.00 they need to produce the following delegated capability:

```jsonc
{
    "@context": ["https://w3id.org/security/v2",
    {
        "@vocab": "https://bank.com/vocab#"
    }],

    // The identifier of this specific delegated zcap object
    "id": "https://example.com/zcap/id/2",

    // Pointing up the chain at the capability from
    // which the bank Account Owner was initially 
    // granted authority by their bank
    "parentCapability": "https://example.com/zcap/id/1",

    // Bank account owner adds a caveat:
    // child can spend a maximum of 50.00
    "caveat": [{
       "type": "MaxPayment",
        "maxPaymentValue": 50.00
    }],

    // bank account owner grants authority to any
    // verification method of their child's DID
    "invoker": "did:example:child",

    // Finally the bank account owner signs this 
    // object with the key she was granted the 
    // authority with
    "proof": {
        "type": "Ed25519Signature2020",
        "proofPurpose": "capabilityDelegation",
        "created": "2018-02-13T21:26:08Z",
        "creator": "did:example:bankAccountOwner#key1",
        "signatureValue": "..."
    }
}
```

Now for the zcap to be invoked by the child at the payment gateway to spend $50 they need to produce a zcap that looks like the following:

```jsonc
{
    "@context": ["https://w3id.org/security/v2",
    {
        "@vocab": "https://bank.com/vocab#"
    }],

    // The identifier of this specific delegated zcap object
    "id": "https://example.com/zcap/id/3",

    // Pointing up the chain at the capability from
    // which the bank Account Owner was initially 
    // granted authority by their bank
    "parentCapability": "https://example.com/zcap/id/2",

    // bank account owner grants authority to any
    // verification method of their child's DID
    "invoker": "did:example:child",

    // the chain of capabilities from the trusted entity
    // making the intial authorization to the current 
    // capability being invoked 
    "capabilityChain": [{
        "@context": ["https://w3id.org/security/v2",
        {
            "@vocab": "https://bank.com/vocab#"
        }],
        "id": "https://example.com/zcap/id/1",
        "parentCapability": "https://example.com/paymentGateway",
        "caveat": [{
            "type": "MaxPayment",
                "maxPaymentValue": 4156.62
        }],
        "invoker": "did:example:bankAccountOwner",
        "proof": {
            "type": "Ed25519Signature2018",
            "created": "2018-02-13T21:26:08Z",
            "capabilityChain": [
            "https://example.com/paymentGateway"
            ],
            "proofValue": "...",
            "proofPurpose": "capabilityDelegation",
            "verificationMethod": "did:web:bank.com:branch:id:565049#key1"
        }
    },
    {
        "@context": ["https://w3id.org/security/v2",
        {
            "@vocab": "https://bank.com/vocab#"
        }],
        "id": "https://example.com/zcap/id/2",
        "parentCapability": "https://example.com/zcap/id/1",
        "caveat": [{
            "type": "MaxPayment",
            "maxPaymentValue": 50.00
        }],
        "invoker": "did:example:child",
        "proof": {
            "type": "Ed25519Signature2020",
            "proofPurpose": "capabilityDelegation",
            "created": "2018-02-13T21:26:08Z",
            "creator": "did:example:bankAccountOwner#key1",
            "signatureValue": "..."
        }
    }],
    "proof": {
        "type": "Ed25519Signature2020",
        "proofPurpose": "capabilityInvocation",
        "created": "2018-02-13T21:27:09Z",
        "creator": "did:example:child#key1",
        "signatureValue": "..."
    }
}
```

To verify this zcap, the payment gateway verifier needs to do the following:

1. verify the proof of the original capability
2. verify the original invoker is authorized to delegate the original capability on behalf of the payment gateway
3. verify the original capability meets or exceeds the authorities necessary to perform the request
4. verify the proof that the bankAccountOwner delegated the original capability to the invoker
5. verify the caveats allow the delegated capability to still meet or exceed the authorities necessary to perform the request
6. verify the proof in the capability invoked by the child

So this is a bit simpler for the payment gateway verifying the chain and makes it explicit what's actually being delegated through the different parties. The question of the relationship between the different parties has now been eliminated which means that the payment gateway can operate in a stateless method. Additionally, there's less coordination between the original delegator and the payment gateway verifier. In the object capabilities model the authorization semantics are all predetermined by what is possible to be authorized which keeps the claims tightly scoped to the purpose of the capabilities being invoked.

The difference here is that the basis of all authority stems from the verifier rather than building off the statements that already exist from Issuers who may not have designed the original claims for the purposes of an authorization systems. And this key difference is what allows for the simplicity of the verifier system to exist. It moves the model back to having the sole authority set by the verifier rather than the verifier having to adapt and potentially misinterpret the original veracity and the chained veracity of the claims.

So what are the drawbacks of the object capability paradigm and more specifically of the ZCAP-LD data model. Well first and foremost, ZCAPs are fit for purpose for building object capability authorization models and are unlikely to be reapplicable beyond that intended scope. For me that's alright because I like the idea of designing a technology to do one thing well. Especially when dealing with security and access control. Whereas the verifiable credentials data model allows for generic statements to be made which are far more useful for verifiable data ecosystems to emerge. Additionally, it's worth mentioning that the ZCAPs data model is a relatively immature draft report at the credentials community group where as the verifiable credentials data model has a much more stable recommendation having completed the process to become an international standard recommended by the W3C. This means there's far more likely to be interoperability between verifiable credential processors than there would be between ZCAPs.

Why make the investment then to put the time and effort into ZCAPs when we've already got VCs? Simply put because security is hard and trying to push square pegs into round holes often times leads to bugs which are elevated to mission critical authentication/authorization bypass vulnerabilities. By designing around a fit for purpose data model with a well defined problem being solved it allows for us to be much more precise about where we believe extensibility is important versus where normative statements should be made to simplify the processing of the data models. By extension this leads to a simpler security model and likely a much more robust design with fewer vulnerabilities.