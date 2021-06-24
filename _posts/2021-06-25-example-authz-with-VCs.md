---
layout: thought
title: "Example Design of an Authorization System with Verifiable Credentials and the Tradeoffs"
date: 2021-06-22
excerpt: "I'll cover an example design which relies upon verifiable credentials for an authorization system and the tradeoffs faced."
tags:
    [
        Verifiable Credentials,
        VCs,
        DIDs,
        Decentralized Identifiers,
        Delegation,
        Attenuation,
        Attenuated Delegation,
        Authorization system,
        system design,
    ]
comments: true
---

# Example Design of an Authorization System with Verifiable Credentials and the Tradeoffs

## Problem summary

In this blog post, I'll cover an example design that relies upon verifiable credentials where a CFO is delegating access to their assistant to authorize purchases made by the company. The primary focus of this blog post is to highlight the different problems that are likely to occur when going down the path of building an authorization system with verifiable credentials. I'll be sure to keep things at a higher level so that anyone can understand these tradeoffs, but take you through the details that would be thought through by an architect designing the system. Enjoy, and feel free to leave comments or reach out to me for questions, suggested improvements, or other aspects I didn't fully consider.

## Use case description

In this use case, the issuer is an employer who wishes to provide an employee credential to their CFO. Now their CFO as a part of their job has a lot of capabilities afforded to them as a senior executive. Let's say this CFO has two abilities. They can sign off on quarterly reports and they can authorize purchases. Now let's say the employer issues them the following credential:

```json
{
 "@context": [
   "https://www.w3.org/2018/credentials/v1",
   {
    "@vocab": "https://example.com/employer/"
   }
  ],
  "id": "http://example.com/employer/credentials/123",
  "type": ["VerifiableCredential", "EmployerCredential"],
  "issuer": "https://example.com/employer",
  "issuanceDate": "2010-01-01T19:73:24Z",
  "credentialSubject": {
    "id": "did:example:cfo",
    "jobTitle": "Chief Financial Officer",
    "employeeNumber": 123,
  },
  "revocation": {
    "id": "http://example.gov/revocations/738",
    "type": "SimpleRevocationList2017"
  },
  "proof": {
      "type": "Ed25519Signature2020",
      "created": "2019-12-11T03:50:55Z",
      "proofValue": "....",
      "proofPurpose": "assertionMethod",
      "verificationMethod": "https://example.com/employer/key1"
    }
}
```

All is good and well, now the CFO can do their job. Now let's say the CFO has been bombarded with purchase authorization requests recently while trying to prepare the quarterly report and has asked their assistant to assist with the backlog of purchase requests as long as the requests are under $10,000. To do this, the CFO decides to delegate their employee credential to their assistant because the payment authorization system relies upon the jobTitle attribute to determine the capabilities.

So, the CFO delegates the following credential to their assistant and hands over their employee credential too:

```json
{
 "@context": [
   "https://www.w3.org/2018/credentials/v1",
   {
    "@vocab": "https://example.com/employer/"
   }
  ],
  "id": "http://example.com/employer/credentials/123",
  "type": ["VerifiableCredential", "EmployerCredential"],
  "issuer": "did:example:cfo",
  "issuanceDate": "2010-01-01T19:73:24Z",
  "credentialSubject": {
    "id": "did:example:assistant",
    "jobTitle": "Chief Financial Officer",
    "employeeNumber": 123,
  },
  "revocation": {
    "id": "http://example.gov/revocations/738",
    "type": "SimpleRevocationList2017"
  },
  "proof": {
      "type": "Ed25519Signature2020",
      "created": "2019-12-11T03:50:55Z",
      "proofValue": "....",
      "proofPurpose": "assertionMethod",
      "verificationMethod": "did:example:cfo#key1"
    }
}
```

> Side rhetorical consideration around the semantics of this VC as a standalone VC, why is the CFO declaring that their assistant has the jobTitle "Chief Financial Officer" now? This is what I mean when I say using verifiable credentials for authorization systems introduces bad semantics. To skirt around authorization systems we're bending the semantics of the claims in the credentials in ways that don't make sense. And that's ignoring the second and third-order effects that are inherently going to be introduced!

Great, so now the assistant can generate the following delegated verifiable Presentation to authorize payments:

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
   {
    "@vocab": "https://example.com/employer/"
   }
  ],
  "id": "http://example.com/employer/credentials/789",
  "type": ["VerifiablePresentation"],
  "verifiableCredential": [
    {
        "@context": [
            "https://www.w3.org/2018/credentials/v1",
            {
                "@vocab": "https://example.com/employer/"
            }
        ],
        "id": "http://example.com/employer/credentials/123",
        "type": ["VerifiableCredential", "EmployerCredential"],
        "issuer": "https://example.com/employer",
        "issuanceDate": "2010-01-01T19:73:24Z",
        "credentialSubject": {
            "id": "did:example:cfo",
            "jobTitle": "Chief Financial Officer",
            "employeeNumber": 123,
        },
        "revocation": {
            "id": "http://example.gov/revocations/738",
            "type": "SimpleRevocationList2017"
        },
        "proof": {
            "type": "Ed25519Signature2020",
            "created": "2019-12-11T03:50:55Z",
            "proofValue": "....",
            "proofPurpose": "assertionMethod",
            "verificationMethod": "https://example.com/employer/key1"
        }
    },
    {
        "@context": [
            "https://www.w3.org/2018/credentials/v1",
            {
                "@vocab": "https://example.com/employer/"
            }
        ],
        "id": "http://example.com/employer/credentials/456",
        "type": ["VerifiableCredential", "EmployerCredential"],
        "issuer": "did:example:cfo",
        "issuanceDate": "2010-01-01T19:73:24Z",
        "credentialSubject": {
            "id": "did:example:assistant",
            "jobTitle": "Chief Financial Officer",
            "employeeNumber": 123,
        },
        "proof": {
            "type": "Ed25519Signature2020",
            "created": "2019-12-11T03:50:55Z",
            "proofValue": "....",
            "proofPurpose": "assertionMethod",
            "verificationMethod": "did:example:cfo#key1"
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

Sweet, now the assistant can authorize payments! Let's review what the steps are for the payment authorization system now with this.

**VP Request checks**

1. Check that the verificationMethod is associated with the authentication proofPurpose for the assistant.
2. Check that the verificationMethod for the VP proof is associated with the delegation credential `credentialSubject.id`
3. Check that the proofValue is valid in the VP proof (the bottom one) based on the associated verificationMethod for the assistant
4. Check that the challenge matches the VP Request

**Delegation Credential checks** 

5. Check that the verificationMethod is associated with the assertionMethod proofPurpose for the CFO in the delegation credential 
6. Check that the verificationMethod in the delegation credential is associated with the issuer property of the delegation credential 
7. Check that the proofValue is valid in the delegation credential proof (the middle one) based on the associated verificationMethod for the CFO 
8. Check that the `credentialSubject.jobTitle` has "Chief Financial Officer" in the delegation credential 9. Check that the issuer property in the delegation credential matches the `credentialSubject.id` in the original credential

**Original Credential checks** 

10. Check that the verificationMethod is associated with the assertionMethod proofPurpose for the employer in the original credential 
11. Check that the verificationMethod in the original credential is associated with the issuer property of the original credential 
12. Check that the proofValue is valid in the original credential proof (the top one) based on the associated verificationMethod for the CFO 
13. Check that the `credentialSubject.jobTitle` has "Chief Financial Officer" in the original credential 
14. Check that the original credential isn't revoked

> Note to consider: If the credentials in the verifiable presentation are ordered incorrectly that's going to introduce some problems

But wait how did the authorization system know that the assistant has been attenuated with limited permission to only authorize payments below $10,000? Well, we've got a few different ways we could do that, let's take a look at the ways we can extend this simple delegation pattern.

## Extension 1: CFO adds a `maximumAuthorizationLimit` property to the delegation credential

So in this scenario, the CFO adds `maximumAuthorizationLimit` property like so:

```json
{
    "@context": [
        "https://www.w3.org/2018/credentials/v1",
        {
            "@vocab": "https://example.com/employer/"
        }
    ],
    "id": "http://example.com/employer/credentials/123",
    "type": ["VerifiableCredential", "EmployerCredential"],
    "issuer": "did:example:cfo",
    "issuanceDate": "2010-01-01T19:73:24Z",
    "credentialSubject": {
        "id": "did:example:assistant",
        "jobTitle": "Chief Financial Officer",
        "employeeNumber": 123,
        "maximumAuthorizationLimit": 10000
    },
    "proof": {
        "type": "Ed25519Signature2020",
        "created": "2019-12-11T03:50:55Z",
        "proofValue": "....",
        "proofPurpose": "assertionMethod",
        "verificationMethod": "did:example:cfo#key1"
    }
}
```

and the verifiable presentation would now look like this:

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
   {
    "@vocab": "https://example.com/employer/"
   }
  ],
  "id": "did:example:76e12ec21ebhyu1f712ebc6f1z2",
  "type": ["VerifiablePresentation"],
  "verifiableCredential": [
    {
        "@context": [
            "https://www.w3.org/2018/credentials/v1",
            {
                "@vocab": "https://example.com/employer/"
            }
        ],
        "id": "http://example.com/employer/credentials/123",
        "type": ["VerifiableCredential", "EmployerCredential"],
        "issuer": "https://example.com/employer",
        "issuanceDate": "2010-01-01T19:73:24Z",
        "credentialSubject": {
            "id": "did:example:cfo",
            "jobTitle": "Chief Financial Officer",
            "employeeNumber": 123,
        },
        "revocation": {
            "id": "http://example.gov/revocations/738",
            "type": "SimpleRevocationList2017"
        },
        "proof": {
            "type": "Ed25519Signature2020",
            "created": "2019-12-11T03:50:55Z",
            "proofValue": "....",
            "proofPurpose": "assertionMethod",
            "verificationMethod": "https://example.com/employer/key1"
        }
    },
    {
        "@context": [
            "https://www.w3.org/2018/credentials/v1",
            {
                "@vocab": "https://example.com/employer/"
            }
        ],
        "id": "http://example.com/employer/credentials/123",
        "type": ["VerifiableCredential", "EmployerCredential"],
        "issuer": "did:example:cfo",
        "issuanceDate": "2010-01-01T19:73:24Z",
        "credentialSubject": {
            "id": "did:example:assistant",
            "jobTitle": "Chief Financial Officer",
            "employeeNumber": 123,
            "maximumAuthorizationLimit": 10000
        },
        "proof": {
            "type": "Ed25519Signature2020",
            "created": "2019-12-11T03:50:55Z",
            "proofValue": "....",
            "proofPurpose": "assertionMethod",
            "verificationMethod": "did:example:cfo#key1"
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

Awesome, so now we have a verifiable presentation that attenuates the delegated capabilities of making authorization payments and limits the payments to $10000 for the assistant. This new property introduces some new checks though in our business logic.

15. Check that the `credentialSubject.maximumAuthorizationLimit` in the delegation credential is below the limit afforded to the `credentialSubject.jobTitle`
16. Check that the payment hasn't exceeded the `credentialSubject.maximumAuthorizationLimit`

But wait, when we delegated the ability for the assistant to authorize payments we also inadvertently allowed the assistant to sign off on the quarterly reports! Oh no! Now, we've got a legal liability issue on our hands.
We'll need to build on top of option 1 to make sure that the assistant isn't signing off on our quarterly reports too and so that we can adhere to the [principle of least authority](https://en.wikipedia.org/wiki/Principle_of_least_privilege). We'll cover that in option 2.

## Extension 2: limiting the assistant's abilities to only payment authorization capabilities

Since the CFO has two capabilities, we need to disable the one that would allow the assistant to also sign off on quarterly reports. We're going to go ahead and do this via the introduction of the `canSignQuartlyReports` claim.

So now the delegation credential looks like this:

```json
{
    "@context": [
        "https://www.w3.org/2018/credentials/v1",
        {
            "@vocab": "https://example.com/employer/"
        }
    ],
    "id": "http://example.com/employer/credentials/123",
    "type": ["VerifiableCredential", "EmployerCredential"],
    "issuer": "did:example:cfo",
    "issuanceDate": "2010-01-01T19:73:24Z",
    "credentialSubject": {
        "id": "did:example:assistant",
        "jobTitle": "Chief Financial Officer",
        "employeeNumber": 123,
        "maximumAuthorizationLimit": 10000,
        "canSignQuartlyReports": false
    },
    "proof": {
        "type": "Ed25519Signature2020",
        "created": "2019-12-11T03:50:55Z",
        "proofValue": "....",
        "proofPurpose": "assertionMethod",
        "verificationMethod": "did:example:cfo#key1"
    }
}
```

and the delegated verifiable presentation now looks like this:

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
   {
    "@vocab": "https://example.com/employer/"
   }
  ],
  "id": "did:example:76e12ec21ebhyu1f712ebc6f1z2",
  "type": ["VerifiablePresentation"],
  "verifiableCredential": [
    {
        "@context": [
            "https://www.w3.org/2018/credentials/v1",
            {
                "@vocab": "https://example.com/employer/"
            }
        ],
        "id": "http://example.com/employer/credentials/123",
        "type": ["VerifiableCredential", "EmployerCredential"],
        "issuer": "https://example.com/employer",
        "issuanceDate": "2010-01-01T19:73:24Z",
        "credentialSubject": {
            "id": "did:example:cfo",
            "jobTitle": "Chief Financial Officer",
            "employeeNumber": 123,
        },
        "revocation": {
            "id": "http://example.gov/revocations/738",
            "type": "SimpleRevocationList2017"
        },
        "proof": {
            "type": "Ed25519Signature2020",
            "created": "2019-12-11T03:50:55Z",
            "proofValue": "....",
            "proofPurpose": "assertionMethod",
            "verificationMethod": "https://example.com/employer/key1"
        }
    },
    {
        "@context": [
            "https://www.w3.org/2018/credentials/v1",
            {
                "@vocab": "https://example.com/employer/"
            }
        ],
        "id": "http://example.com/employer/credentials/123",
        "type": ["VerifiableCredential", "EmployerCredential"],
        "issuer": "did:example:cfo",
        "issuanceDate": "2010-01-01T19:73:24Z",
        "credentialSubject": {
            "id": "did:example:assistant",
            "jobTitle": "Chief Financial Officer",
            "employeeNumber": 123,
            "maximumAuthorizationLimit": 10000,
            "canSignQuartlyReports": false
        },
        "proof": {
            "type": "Ed25519Signature2020",
            "created": "2019-12-11T03:50:55Z",
            "proofValue": "....",
            "proofPurpose": "assertionMethod",
            "verificationMethod": "did:example:cfo#key1"
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

Finally, we've got a properly attenuated delegation verifiable credential to address our use case! So what's the issue with this? First off, we're using only a toy example here where the CFO has only two capabilities.
Most businesses aren't paying CFOs the big bucks to only handle those two things though (If they are let me know, I'm sure I can figure that job out 😊). This means that for every additional capability that we don't want to be delegated we have to add a permission property. By doing this we're effectively building a deny list with only one capability removed to enable a single capability. Why not build off of and allow list model instead? (Hint this is the approach ZCAP-LDs take)

So our delegation credential could end up looking something like this:

```json
{
    "@context": [
        "https://www.w3.org/2018/credentials/v1",
        {
            "@vocab": "https://example.com/employer/"
        }
    ],
    "id": "http://example.com/employer/credentials/123",
    "type": ["VerifiableCredential", "EmployerCredential"],
    "issuer": "did:example:cfo",
    "issuanceDate": "2010-01-01T19:73:24Z",
    "credentialSubject": {
        "id": "did:example:assistant",
        "jobTitle": "Chief Financial Officer",
        "employeeNumber": 123,
        "maximumAuthorizationLimit": 10000,
        "canSignQuartlyReports": false,
        "canDoXCapability": false,
        "canDoYCapability": false,
        "canDoZCapability": false,
        ...
    },
    "proof": {
        "type": "Ed25519Signature2020",
        "created": "2019-12-11T03:50:55Z",
        "proofValue": "....",
        "proofPurpose": "assertionMethod",
        "verificationMethod": "did:example:cfo#key1"
    }
}
```

## Tradeoffs with this design

Furthermore, the semantics of the claims in this new credential is quite odd. We've effectively combined a claims token and a permission token into a single verifiable Credential here. By doing this we're far more likely to be issuing and reissuing the same credential many times as access to the delegatee needs to be updated. This also has second-order effects on the maintainability and adaptability that are best described by the [principle of least knowledge](https://en.wikipedia.org/wiki/Law_of_Demeter).

It also just so happens, these types of deny lists are awesome things to get your hands on as well when you're performing the reconnaissance phase of a penetration test to break into a system. Now our system design is helping the attackers assuming they get ahold of one of the credentials, but none of the keys. If they get the keys, problems that are better left out of scope for this writeup occur.

Additionally, the fact that we need to perform 16 checks just to achieve our goal means that it's highly likely that one gets missed and an authorization bypass vulnerability is introduced. As is pointed out in the CCG mailing list though, this is mainly a byproduct of the fact we're performing delegation rather than the usage of VCs themselves. However, delegation is only complicated when done correctly. After all, when people are sharing their Netflix passwords they too are delegating and that is a simple implementation for the verifier. So the takeaway here is that the more we can reduce the number of checks when building transparent delegation the more resilient and secure the authorization system is likely to be.

## Conclusion

In conclusion, I stand by the opinion that utilizing verifiable credentials to build authorization systems is possible, but more work than is necessary. Hopefully, this walk-through helps to understand why I've come to this conclusion. However, just because I've decided I'm probably not going to use VCs in this way doesn't mean you shouldn't. Just like any technology, some tradeoffs occur when deciding how you approach your system design. It may be the case that this is the simplest method to achieve your use case. If that's true then by all means go for it. However, I suspect things can be simplified through the use of [ZCAP-LD](https://w3c-ccg.github.io/zcap-ld/). ZCAP-LD is built on the concept of an object capabilities model which is well suited for authorization systems (but not for making claims about a subject). I'll be writing up a follow-up blog on how the same use case described above could be designed with ZCAP-LD and show the differences between the two. Be on the lookout for that to come next!
