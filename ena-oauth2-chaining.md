![Logo](images/ena-logo.png)

# Ena OAuth 2.0 Token Exchange Profile for Chaining Identity and Authorization

### Version: 1.0 - draft 01 - 2025-09-22

## Abstract

The OAuth 2.0 framework defines mechanisms that allow users (resource owners) to delegate access rights to protected resources for the applications they use.

This document specifies solutions for chaining OAuth 2.0 identity and authorization in scenarios where calls to protected resources trigger additional calls, or where calls cross domain boundaries.

## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)

2. [**Protected Resource Acting as an Client**](#protected-resource-acting-as-an-client)

    2.1. [Problem Statement](#2-1-problem-statement)
    
    2.2. [Solution Overview](#2-2-solution-overview)

    2.3. [Token Exchange Request](#2-3-token-exchange-request)

    2.3.1. [Processing Requirements](#2-3-1-processing-requirements)

    2.3.2. [Inbound Token Requirements](#2-3-2-inbound-token-requirements)

    2.4. [Token Exchange Response](#2-4-token-exchange-response)

    2.5. [Examples](#2-5-examples)

3. [**Accessing Protected Resources in Other Domains**](#accessing-protected-resources-in-other-domains)

    3.1. [Problem Statement](#3-1-problem-statement)

    3.2. [Solution Overview](#3-2-solution-overview)
    
    3.2.1. [Domain Trust Relationships](#domain-trust-relationships)

    3.3. [Token Exchange](#3-3-token-exchange)

    3.3.1. [Token Exchange Request](#3-3-1-token-exchange-request)

    3.3.2. [Processing Requirements](#3-3-2-processing-requirements)

    3.3.3. [Inbound Token Requirements](#3-3-3-inbound-token-requirements)

    3.3.4. [Token Exchange Response](#3-3-4-token-exchange-response)

    3.4. [Authorization Grant Requirements](#authorization-grant-requirements)

    3.4.1. [JWT Contents](#jwt-contents)

    3.4.2. [Access Token Request According to RFC7523](#access-token-request-according-to-rfc7523)

    3.4.3. [Processing of JWT Authorization Grant](#processing-of-jwt-authorization-grant)

    3.4.4. [Requirements for Issued Access Token](#requirements-for-issued-access-token)

    3.5. [Examples](#3-5-examples)

4. [**References**](#references)

    4.1. [Normative References](#normative-references)

    4.2. [Informational References](#informational-references)


----
    
<a name="introduction"></a>
## 1. Introduction

The "OAuth 2.0 Token Exchange" specification, \[[RFC8693](#rfc8693)\], defines a generic extension to OAuth 2.0 that allows an entity to call an OAuth 2.0 authorization server acting as a Security Token Service (STS) in order to exchange a token in its possession for another token. While token exchange is a powerful tool for addressing many OAuth 2.0-related challenges, a generic specification such as \[[RFC8693](#rfc8693)\] requires profiling to achieve interoperability and to avoid introducing security risks.

This specification profiles the use of OAuth 2.0 Token Exchange for two common use cases where a structured and secure method of applying OAuth 2.0 has not previously been defined.  

- [Protected Resource Acting as a Client](#protected-resource-acting-as-a-client) &ndash; A protected resource may, in order to fulfil a request, need to act as an OAuth 2.0 client and make another call that requires an access token. This use case is described in [Section 2](#protected-resource-acting-as-a-client).  

- [Accessing Protected Resources in Other Domains](#accessing-protected-resources-in-other-domains) &ndash; Entities may need to access resources outside their own domain, where a different authorization server and trust model apply, and in many cases, a different user authentication model is used. This use case is described in [Section 3](#accessing-protected-resources-in-other-domains).  

Common to both use cases is that each API, or protected resource, requires the presentation of a valid access token granted by the resource owner (user). In other words, the access token obtained must involve the user, for example through the authorization code grant, and it must carry the user’s identity so that this identity can be chained across subsequent calls.  

**Note:** The problem statements therefore do not include the use of the client credentials grant, where one service calls another without the involvement of a user or resource owner. Such usage is not affected by the chaining challenges described in this document and is therefore out of scope for this specification.  

<a name="requirements-notation-and-conventions"></a>
### 1.1. Requirements Notation and Conventions

The keywords “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” are to be interpreted as described in \[[RFC2119](#rfc2119)\].

These keywords are capitalized when used to unambiguously specify requirements over protocol features and behavior that affect the interoperability and security of implementations. When these words are not capitalized, they are meant in their natural-language sense.

<a name="protected-resource-acting-as-an-client"></a>
## 2. Protected Resource Acting as an Client

<a name="2-1-problem-statement"></a>
### 2.1. Problem Statement

The simple illustration below illustrates a typical use of the OAuth 2.0 authorization code grant, where an application (OAuth 2.0 client) requests an access token to access an API (protected resource). The user (resource owner) grants the request, and the authorization server issues an access token that the application presents when calling the API.

But what happens if the implementation of the API needs to make a backend call to a second API in order to construct a response to the API request?

![Pic](images/api-call.png)

In this scenario, the first API will act as an OAuth 2.0 client against the second API, but how will it acquire the access token to pass along in the call?

Firstly, let's determine why the access token it received in the call from the application cannot simply be forwarded:

- The audience for this access token is set to be the first API and according to access token processing rules (see Section 6.1 of \[[Ena.OAuth2.Profile](#ena-oauth2-profile)\]) the second API would reject this token since it is not intended for it.

- The `client_id` claim for the access token is set to the identifier of the client making the request which in our case is the application. 

- The scope(s) issued for the first access token may differ from the scope requirements of the second API.

- If the "Demonstrating Proof of Possession - DPoP", \[[RFC9449](#rfc9449)\], security feature is used within the OAuth-deployment, the first API cannot simply forward the DPoP-header to the second API since it is a one-time use header that is also bound to the exact URL of the (orginal) request.

Some deployments that do not use DPoP forward access tokens between services in a call chain. In such cases, the access token either contains multiple audience values or all invoked services are treated as the same entity. Furthermore, the initial client identifier is passed along the chain, which breaks traceability. Entities conformant with this profile MUST NOT rely on such shortcuts.

The following sections specify how OAuth 2.0 Token Exchange, as defined in \[[RFC8693](#rfc8693)\], can be used by a protected resource to obtain a new access token from a previously received one before acting as an OAuth 2.0 client to call another service.

<a name="2-2-solution-overview"></a>
### 2.2. Solution Overview

<a name="2-3-token-exchange-request"></a>
### 2.3. Token Exchange Request

<a name="2-3-1-processing-requirements"></a>
#### 2.3.1. Processing Requirements

<a name="2-3-2-inbound-token-requirements"></a>
#### 2.3.2. Inbound Token Requirements

<a name="2-4-token-exchange-response"></a>
### 2.4. Token Exchange Response

<a name="2-5-examples"></a>
### 2.5. Examples

<a name="accessing-protected-resources-in-other-domains"></a>
## 3. Accessing Protected Resources in Other Domains

<a name="3-1-problem-statement"></a>
### 3.1. Problem Statement

The previous section described the challenge of identity and authorization chaining for services within the same domain, i.e., where the same trust model and authorization server are used. However, applications may also need to access resources outside their own domain, where a different authorization server and trust model apply, and in many cases, a different user authentication model.

![Pic](images/api-call-domains.png)

Given this problem statement, the main challenges are:

- The user cannot simply be redirected to the authorization server in the second domain, since that server has no way of authenticating the user.  
- An access token issued by the authorization server in the first domain will not be accepted by protected resources in the second domain.

The solution to the above challenges requires establishing a trust relationship between the authorization servers in the respective domains. This trust enables the authorization server in the first domain to issue a statement intended for the authorization server in the second domain, allowing clients in the first domain to obtain access tokens that can be used in the second domain.

<a name="3-2-solution-overview"></a>
### 3.2. Solution Overview

<a name="domain-trust-relationships"></a>
#### 3.2.1. Domain Trust Relationships

<a name="3-3-token-exchange"></a>
### 3.3. Token Exchange

<a name="3-3-1-token-exchange-request"></a>
#### 3.3.1. Token Exchange Request

<a name="3-3-2-processing-requirements"></a>
#### 3.3.2. Processing Requirements

<a name="3-3-3-inbound-token-requirements"></a>
#### 3.3.3. Inbound Token Requirements

<a name="3-3-4-token-exchange-response"></a>
#### 3.3.4. Token Exchange Response

<a name="authorization-grant-requirements"></a>
### 3.4. Authorization Grant Requirements

<a name="jwt-contents"></a>
#### 3.4.1. JWT Contents

<a name="access-token-request-according-to-rfc7523"></a>
#### 3.4.2. Access Token Request According to RFC7523

<a name="processing-of-jwt-authorization-grant"></a>
#### 3.4.3. Processing of JWT Authorization Grant

<a name="requirements-for-issued-access-token"></a>
#### 3.4.4. Requirements for Issued Access Token

<a name="3-5-examples"></a>
### 3.5. Examples

<a name="references"></a>
## 4. References

<a name="normative-references"></a>
### 4.1. Normative References

<a name="rfc2119"></a>
**\[RFC2119\]**
> [Bradner, S., "Key words for use in RFCs to Indicate Requirement Levels", March 1997](https://www.ietf.org/rfc/rfc2119.txt).

<a name="rfc7523"></a>
**\[RFC7523\]**
> [Jones, M., Campbell, B., and C. Mortimore, "JSON Web Token (JWT) Profile for OAuth 2.0 Client Authentication and Authorization Grants", RFC 7523, DOI 10.17487/RFC7523, May 2015](https://datatracker.ietf.org/doc/html/rfc7523).

<a name="rfc8693"></a>
**\[RFC8693\]**
> [Jones, M., Campbell, B., and D. Waite, "OAuth 2.0 Token Exchange", RFC 8693, DOI 10.17487/RFC8693, January 2020](https://www.rfc-editor.org/info/rfc8693).

<a name="rfc9449"></a>
**\[RFC9449\]**
> [Fett, D., Campbell, B., Bradley, J., Lodderstedt, T., Jones, M., and D. Waite, "OAuth 2.0 Demonstrating Proof of Possession (DPoP)", RFC 9449, DOI 10.17487/RFC9449, September 2023](https://www.rfc-editor.org/info/rfc9449).

<a name="ena-oauth2-profile"></a>
**\[Ena.OAuth2.Profile\]**
> [Ena OAuth 2.0 Interoperability Profile](https://github.com/ena-infrastructure/specifications/blob/main/ena-oauth2-profile.md)

<a name="informational-references"></a>
### 4.2. Informational References

<a name="draft-id-chaining"></a>
**\[Draft.ID-Chaining\]**
> [Schwenkschuster, A., Kasselmann, P., Burgin, K., Jenkins, M., and B. Campbell, "OAuth Identity and Authorization Chaining Across Domains", draft-ietf-oauth-identity-chaining-06, September 2025](https://www.ietf.org/archive/id/draft-ietf-oauth-identity-chaining-06.html).