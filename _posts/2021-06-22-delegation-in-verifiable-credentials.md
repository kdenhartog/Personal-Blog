---
layout: thought
title: "Common Delegation Patterns in the Verifiable Credential Ecosystem"
date: 2021-06-22
excerpt: "Here's 3 ways you can utilize VCs and DIDs to enable delegation and attenuated delegation for more complex scenarios."
tags:
    [
        Verifiable Credentials,
        VCs,
        DIDs,
        Decentralized Identifiers,
        Developer Tutorial,
        Delegation,
        Attenuation,
        Attenuated Delegation
    ]
comments: true
---

# Common Delegation Patterns in the Verifiable Credential Ecosystem

It's commonly understood that verifiable credentials are a useful data model for expressing provenance and authority of data. In other words, they're great for solving the "who says what" problem in a digital ecosystem. However, did you know that there are three ways in which you can utilize VCs and DIDs to enable delegation and attenuated delegation for more complex scenarios? In this blog post, I'll cover the three patterns you can use with examples to help you figure out some of the more advanced capabilities of the VC data model. See below for more details!

## Terminology

Since it's quite common to see these terms within the IAM space, I figured it would be useful to first cover what each term means in simple term.

**Delegation:** This is the ability for someone to share their abilities with another user within the system. There's multiple ways this can be done all with different forms of tradeoffs. 
 
 1. A user who shares their password with another user is performing delegation, but not in a way that allows an authorization endpoint (often times called a "verifier") to be able to uniquely differentiate between the two users. This inability to differentiate at the authorization endpoint often leads to concerns around the [confused deputy problem](https://en.wikipedia.org/wiki/Confused_deputy_problem).
 
 2. This when the system has been designed to allow the user to share their abilities with another user. The most common way this shows up today is with google document links. When a user "allows anyone with this link to view/comment/edit" they're granting abilites to other users in a delegated way. The difference being the system can identify these unique users, which is commonly seen via the further delegation based upon an email address or organization.

**Attenuated delegation:** This is when the user opts to share only a portion of the abilities that they have. So looking at our options from delegation, option 1 would not allow this because the user is sharing all the same abilities that they have when logging into an account. So if an admin shares their password, the person they share the password with has admin abilities as well. One of the more common examples I can think of when attenuated delegation that is in use today is when a valet key is given to a valet. This key gives the valet access to drive the vehicle, but doesn't allow them to open a glovebox or trunk for example. In this case, the driver of the vehichle is able to share only a portion of their abilities (driving) without sharing all of their abilities (opening a glovebox or trunk). In almost every system I've seen, this has to be intentionally designed into the system.

## Delegation without attenuation by using DID Documents

As an example, let's say we have the two following DID Documents:

Alice's DID Document:

```json
{
    "@context": [
        "https://www.w3.org/ns/did/v1",
        "https://w3id.org/security/suites/ed25519-2020/v1"
    ],
    "id": "did:example:alice",
    "verificationMethod": [
        {
            "id": "did:example:alice#aliceKey1",
            "type": "Ed25519VerificationKey2020",
            "controller": "did:example:alice",
            "publicKeyMultibase": "zH3C2AVvLMv6gmMNam3uVAjZpfkcJCwDwnZn6z3wXmqPV"
        },
        {
            "id": "did:example:bob#bobKey1",
            "type": "Ed25519VerificationKey2020",
            "controller": "did:example:bob",
            "publicKeyMultibase": "z9hFgmPVfmBZwRvFEyniQDBkz9LmV7gDEqytWyGZLmDXE"
        }
    ],
    "assertionMethod": [
        "did:example:alice#aliceKey1",
        "did:example:bob#bobKey1"
    ]
}
```

Bob's DID Document:

```json
{
    "@context": [
        "https://www.w3.org/ns/did/v1",
        "https://w3id.org/security/suites/ed25519-2020/v1"
    ],
    "id": "did:example:bob",
    "verificationMethod": [
        {
            "id": "did:example:bob#bobKey1",
            "type": "Ed25519VerificationKey2020",
            "controller": "did:example:bob",
            "publicKeyMultibase": "z9hFgmPVfmBZwRvFEyniQDBkz9LmV7gDEqytWyGZLmDXE"
        }
    ],
    "assertionMethod": ["did:example:bob#bobKey1"]
}
```

In this example we can see that Alice has the capability to delegate to Bob the ability for him to assert on her behalf.
In the case of the following VC, bob could then create a valid verifiable presentation based on the following verifiable
credential that was delegated to him:

```json
{
    "@context": [
        "https://www.w3.org/2018/credentials/v1",
        "https://www.w3.org/2018/credentials/examples/v1"
    ],
    "id": "http://example.gov/credentials/3732",
    "type": ["VerifiableCredential", "UniversityDegreeCredential"],
    "issuer": {
        "id": "did:example:issuer"
    },
    "issuanceDate": "2020-03-10T04:24:12.164Z",
    "credentialSubject": {
        "id": "did:example:alice",
        "degree": {
            "type": "BachelorDegree",
            "name": "Bachelor of Science and Arts"
        }
    },
    "proof": {
        "type": "JsonWebSignature2020",
        "created": "2020-03-21T17:51:48Z",
        "verificationMethod": "did:example:issuer#credentialIssuanceKey",
        "proofPurpose": "assertionMethod",
        "jws": "eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFZERTQSJ9..OPxskX37SK0FhmYygDk-S4csY_gNhCUgSOAaXFXDTZx86CmI5nU9xkqtLWg-f4cqkigKDdMVdtIqWAvaYx2JBA"
    }
}
```

Where the verifiablePresentation looks like so:

```json
{
    "@context": [
        "https://www.w3.org/2018/credentials/v1",
        "https://example.com/credentials/latest"
    ],
    "type": ["VerifiablePresentation"],
    "verifiableCredential": [
        {
            "@context": [
                "https://www.w3.org/2018/credentials/v1",
                "https://www.w3.org/2018/credentials/examples/v1"
            ],
            "id": "http://example.gov/credentials/3732",
            "type": ["VerifiableCredential", "UniversityDegreeCredential"],
            "issuer": {
                "id": "did:example:issuer"
            },
            "issuanceDate": "2020-03-10T04:24:12.164Z",
            "credentialSubject": {
                "id": "did:example:alice",
                "degree": {
                    "type": "BachelorDegree",
                    "name": "Bachelor of Science and Arts"
                }
            },
            "proof": {
                "type": "JsonWebSignature2020",
                "created": "2020-03-21T17:51:48Z",
                "verificationMethod": "did:example:issuer#credentialIssuanceKey",
                "proofPurpose": "assertionMethod",
                "jws": "eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFZERTQSJ9..OPxskX37SK0FhmYygDk-S4csY_gNhCUgSOAaXFXDTZx86CmI5nU9xkqtLWg-f4cqkigKDdMVdtIqWAvaYx2JBA"
            }
        }
    ],
    "id": "ebc6f1c2",
    "holder": "did:example:alice",
    "proof": {
        "type": "Ed25519Signature2020",
        "created": "2019-12-11T03:50:55Z",
        "verificationMethod": "did:example:bob#bobKey1",
        "proofPurpose": "authentication",
        "challenge": "123",
        "proofValue": "z5LgJQhEvrLoNqXSbBzFR6mqmBnUefxX6dBjn2A4FYmmtB3EcWC41RmvHARgHwZyuMkR9xMbMCY7Ch4iRr9R8o1JffWY63FRfX3em8f3avb1CU6FaxiMjZdNegc"
    }
}
```

This effectively is a method to allow Alice to add bob's public key to her did document and giving him a copy of the verifiable credential to delegate him to act on her behalf. However, because this pattern relies on Alice granting Bob full authority to perform any action on her behalf, it lacks attenuation, but does have delegation.

## Delegation by VCs

Additionally, there's a well documented case to be able to establish delegation using just VCs without the ability to attenuate the data. See [Section Appendix C.5](https://w3c.github.io/vc-data-model/#subject-passes-a-verifiable-credential-to-someone-else) for more details on this pattern.

## Attenuated Delegation by VCs

Further, by combining the pattern described in [Section Appendix C.5](https://w3c.github.io/vc-data-model/#subject-passes-a-verifiable-credential-to-someone-else) and combining it with the usage of a selective disclosure scheme like BBS signatures, we can enable an attenuated delegation pattern.

This is done via modifying the type of proof used to sign the credential and then utilizing the selective disclosure to limit the data. Using the following original verifiable credential:

```json
{
    "@context": [
        "https://www.w3.org/2018/credentials/v1",
        "https://w3id.org/citizenship/v1",
        "https://w3id.org/security/bbs/v1"
    ],
    "id": "https://issuer.oidp.uscis.gov/credentials/83627465",
    "type": ["VerifiableCredential", "PermanentResidentCard"],
    "issuer": "did:example:issuer",
    "identifier": "83627465",
    "name": "Permanent Resident Card",
    "description": "Government of Example Permanent Resident Card.",
    "issuanceDate": "2019-12-03T12:19:52Z",
    "expirationDate": "2029-12-03T12:19:52Z",
    "credentialSubject": {
        "id": "did:example:b34ca6cd37bbf23",
        "type": ["PermanentResident", "Person"],
        "givenName": "Alice",
        "familyName": "SMITH",
        "gender": "Female",
        "image": "data:image/png;base64,iVBORw0KGgokJggg==",
        "residentSince": "2015-01-01",
        "lprCategory": "C09",
        "lprNumber": "999-999-999",
        "commuterClassification": "C1",
        "birthCountry": "Bahamas",
        "birthDate": "1958-07-17"
    },
    "proof": {
        "type": "BbsBlsSignature2020",
        "created": "2020-10-16T23:59:31Z",
        "proofPurpose": "assertionMethod",
        "proofValue": "kAkloZSlK79ARnlx54tPqmQyy6G7/36xU/LZgrdVmCqqI9M0muKLxkaHNsgVDBBvYp85VT3uouLFSXPMr7Stjgq62+OCunba7bNdGfhM/FUsx9zpfRtw7jeE182CN1cZakOoSVsQz61c16zQikXM3w==",
        "verificationMethod": "did:example:issuer#test"
    }
}
```

Then the following derived proof could be used to attenuate the data while also delegating the credential capabilities to a new holder:

```json
{
    "@context": [
        "https://www.w3.org/2018/credentials/v1",
        "https://www.w3.org/2018/credentials/examples/v1"
    ],
    "id": "did:example:76e12ec21ebhyu1f712ebc6f1z2",
    "type": ["VerifiablePresentation"],
    "verifiableCredential": [
        {
            "@context": [
                "https://www.w3.org/2018/credentials/v1",
                "https://w3id.org/citizenship/v1",
                "https://w3id.org/security/bbs/v1"
            ],
            "id": "https://issuer.oidp.uscis.gov/credentials/83627465",
            "type": ["PermanentResidentCard", "VerifiableCredential"],
            "description": "Government of Example Permanent Resident Card.",
            "identifier": "83627465",
            "name": "Permanent Resident Card",
            "credentialSubject": {
                "id": "did:example:alice",
                "type": ["Person", "PermanentResident"],
                "familyName": "SMITH",
                "gender": "Female",
                "givenName": "Alice"
            },
            "expirationDate": "2029-12-03T12:19:52Z",
            "issuanceDate": "2019-12-03T12:19:52Z",
            "issuer": "did:example:issuer",
            "proof": {
                "type": "BbsBlsSignatureProof2020",
                "nonce": "wrmPiSRm+iBqnGBXz+/37LLYRZWirGgIORKHIkrgWVnHtb4fDe/4ZPZaZ+/RwGVJYYY=",
                "proofValue": "ABkB/wbvt6213E9eJ+aRGbdG1IIQtx+IdAXALLNg2a5ENSGOIBxRGSoArKXwD/diieDWG6+0q8CWh7CViUqOOdEhYp/DonzmjoWbWECalE6x/qtyBeE7W9TJTXyK/yW6JKSKPz2ht4J0XLV84DZrxMF4HMrY7rFHvdE4xV7ULeC9vNmAmwYAqJfNwY94FG2erg2K2cg0AAAAdLfutjMuBO0JnrlRW6O6TheATv0xZZHP9kf1AYqPaxsYg0bq2XYzkp+tzMBq1rH3tgAAAAIDTzuPazvFHijdzuAgYg+Sg0ziF+Gw5Bz8r2cuvuSg1yKWqW1dM5GhGn6SZUpczTXuZuKGlo4cZrwbIg9wf4lBs3kQwWULRtQUXki9izmznt4Go98X/ElOguLLum4S78Gehe1ql6CXD1zS5PiDXjDzAAAACWz/sbigWpPmUqNA8YUczOuzBUvzmkpjVyL9aqf1e7rSZmN8CNa6dTGOzgKYgDGoIbSQR8EN8Ld7kpTIAdi4YvNZwEYlda/BR6oSrFCquafz7s/jeXyOYMsiVC53Zls9KEg64tG7n90XuZOyMk9RAdcxYRGligbFuG2Ap+rQ+rrELJaW7DWwFEI6cRnitZo6aS0hHmiOKKtJyA7KFbx27nBGd2y3JCvgYO6VUROQ//t3F4aRVI1U53e5N3MU+lt9GmFeL+Kv+2zV1WssScO0ZImDGDOvjDs1shnNSjIJ0RBNAo2YzhFKh3ExWd9WbiZ2/USSyomaSK4EzdTDqi2JCGdqS7IpooKSX/1Dp4K+d8HhPLGNLX4yfMoG9SnRfRQZZQ==",
                "verificationMethod": "did:example:issuer#test",
                "proofPurpose": "assertionMethod",
                "created": "2020-10-16T23:59:31Z"
            }
        },
        {
            "@context": [
                "https://www.w3.org/2018/credentials/v1",
                "https://w3id.org/citizenship/v1",
                "https://w3id.org/security/v3-unstable"
            ],
            "id": "https://issuer.oidp.uscis.gov/credentials/83627465",
            "type": ["PermanentResidentCard", "VerifiableCredential"],
            "description": "Government of Example Permanent Resident Card.",
            "identifier": "83627465",
            "name": "Permanent Resident Card",
            "credentialSubject": {
                "id": "did:example:bob",
                "type": ["Person", "PermanentResident"],
                "familyName": "SMITH",
                "gender": "Female",
                "givenName": "Alice"
            },
            "expirationDate": "2029-12-03T12:19:52Z",
            "issuanceDate": "2019-12-03T12:19:52Z",
            "issuer": "did:example:alice",
            "proof": {
                "type": "Ed25519Signature2020",
                "created": "2019-12-11T03:50:55Z",
                "proofValue": "z5LgmVhjjPTEzGL31k2eEde8bdr4MAzxQv87AmdHt5Usd1uGK1Ae88NoZ5jgTLKS6sJCZnQNthR3qAbyRMxvkqSkss2WtyKLa9rqhJmR6YEBkiuUtxawhrscWXm",
                "proofPurpose": "assertionMethod",
                "verificationMethod": "did:example:alice#aliceKey1"
            }
        }
    ],
    "proof": [
        {
            "type": "Ed25519Signature2020",
            "created": "2018-06-18T21:19:10Z",
            "proofPurpose": "assertionMethod",
            "verificationMethod": "did:example:bob#bobKey1",
            "challenge": "c0ae1c8e-c7e7-469f-b252-86e6a0e7387e",
            "jws": "BavEll0/I1..W3JT24="
        }
    ]
}
```

## Conclusion

So there's a few different take aways from this that should be highlighted. First and foremost VCs and DIDs have some really interesting capabilities that enable delegation and attenuated delegation. However, it's not always advantageous and requires through understanding of the use case that's trying to be built with DIDs and VCs and whether or not delegation needs to be enabled or disabled. Finally, it should be noted that while VCs are capable of being used for authorization systems, it's generally not a good idea to do so. This is because the complexity (based on the number of checks) of the authorization system is quite high and the semantics have not been designed in a way that align well with most authorization systems. If you're looking for these capabilities, I would recommend you look to the [ZCAP-LD data model](https://w3c-ccg.github.io/zcap-ld/) which is designed especially for this. And if you're still confused and would like some help please reach out and I can see how I can help.
