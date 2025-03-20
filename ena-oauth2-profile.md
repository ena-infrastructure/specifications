![Logo](images/ena-logo.png)

# Ena OAuth 2.0 Interoperability Profile

### Version: 1.0 - draft 01 - 2025-03-20

## Abstract

The OAuth 2.0 framework defines mechanisms that allow users (resource owners) to delegate access rights to a protected resource for an application they are using. Additionally, OAuth 2.0 protocols are often used without user involvement in service-to-service scenarios.

Over the years, numerous extensions and features have been introduced, making “OAuth 2.0” an insufficient label to guarantee interoperability between parties. Therefore, this document defines a profile for OAuth 2.0 to enhance interoperability, strengthen security, and enable more efficient and cost-effective deployments. While the profile is primarily intended for Swedish public and private services and organizations, it is not limited to them.

## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)
    
    1.2. [Terminology](#terminology)

    1.3. [Conformance](#conformance)

    1.4. [Limitations and Exclusions](#limitations-and-exclusions)

2. [**Client Profile**](#client_profile)

    2.1. [Types of OAuth Clients](#types-of-oauth-clients)

3. [**Authorization Server Profile**](#authorization-server-profile)

4. [**Resource Server Profile**](#resource-server-profile)

5. [**Grant Types**](#grant-types)

    5.1. [Authorization Code Grant](#authorization-code-grant)

    5.1.1. [Authorization Requests](#authorization-requests)

    5.1.2. [Authorization Responses](#authorization-responses)

    5.1.3. [Token Endpoint](#acg-token-endpoint)

    5.2. [Refresh Token Grant](#refresh-token-grant)

    5.2.1. [Token Endpoint](#rtg-token-endpoint)

    5.2.2. [Refresh Token Requirements and Recommendations](#refresh-token-requirements-and-recommendations)

    5.3. [Client Credentials Grant](#client-credentials-grant)

    5.4. [Other Grant Types](#other-grant-types)

    5.5. [Prohibited Grant Types](#prohibited-grant-types)

6. [**Security Requirements and Considerations**](#security-requirements-and-considerations)

7. [**References**](#references)

    7.1. [Normative References](#normative-references)

    7.2. [Informational References](#informational-references)

---

<a name="introduction"></a>
## 1. Introduction

This document defines a profile for the OAuth 2.0 authorization framework, establishing a baseline for interoperability and security for Swedish services.

It does not specify any sector-specific extensions or profile existing OAuth 2.0 extensions, except where required by this profile. However, such extensions may be defined in separate profiles that reference this document.

<a name="requirements-notation-and-conventions"></a>
### 1.1. Requirements Notation and Conventions

The keywords “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” are to be interpreted as described in \[[RFC2119](#rfc2119)\].

These keywords are capitalized when used to unambiguously specify requirements over protocol features and behavior that affect the interoperability and security of implementations. When these words are not capitalized, they are meant in their natural-language sense.

<a name="terminology"></a>
### 1.2. Terminology

The OAuth 2.0 Authorization Framework, \[[RFC6749](#rfc6749)\], defines the following roles:

- Resource Owner (RO) – An entity that grants access to a protected resource. When the resource owner is a physical person, the terms End User or simply User may be used. In this document, we sometimes use the abbreviation "RO".

- Resource Server (RS) - A server that hosts a protected resource and requires a valid access token to grant access. In most practical cases, a protected resource is an API accessible over HTTP. In this document, we sometimes use the abbreviation "RS".

- Client - An application that makes requests to protected resources on behalf of a resource owner (user) with proper authorization. In some documentation concerning OAuth 2.0 and OpenID Connect, a client is sometimes referred to as a Relying Party.

- Authorization Server (AS) - A server responsible for issuing access tokens to a client after the resource owner (user) has been successfully authenticated and has granted the necessary authorization rights. In this document, we sometimes use the abbreviation "AS".

<a name="conformance"></a>
### 1.3. Conformance

The profile document defines requirements for OAuth 2.0 resource servers, authorization servers, and clients.

When an entity compliant with this profile interacts with other entities that also conform to this profile, in any valid combination, all entities MUST fully adhere to the features and requirements of this specification. Interactions with non-compliant entities are outside the scope of this specification.

<a name="limitations-and-exclusions"></a>
### 1.4. Limitations and Exclusions

* An OAuth 2.0 public client is a client application that cannot securely store credentials, such as a private key. This is because the client runs in an environment where the code and storage are accessible to end users, making it vulnerable to extraction or tampering. Typical examples of public clients are single-page applications running in a web browser or mobile apps with no backend service.<br /><br />This version of the profile focuses only on OAuth 2.0 confidential clients, i.e., client applications that can securely store credentials, such as web applications with a backend component. Future versions may specify requirements for public clients if the need arises.

* This profile does not impose specific requirements on end-user authentication at the authorization server. This is a policy matter and is out of scope for this document.

* This profile does not specify process requirements for registering an OAuth 2.0 entity. Such requirements should be defined in supplementary specifications or policies.


<a name="client_profile"></a>
## 2. Client Profile

<a name="types-of-oauth-clients"></a>
### 2.1. Types of OAuth Clients

<a name="authorization-server-profile"></a>
## 3. Authorization Server Profile

<a name="resource-server-profile"></a>
## 4. Resource Server Profile

<a name="grant-types"></a>
## 5. Grant Types

<a name="authorization-code-grant"></a>
### 5.1. Authorization Code Grant

<a name="authorization-requests"></a>
#### 5.1.1. Authorization Requests

<a name="authorization-responses"</a>
#### 5.1.2. Authorization Responses

<a name="acg-token-endpoint"></a>
#### 5.1.3. Token Endpoint

<a name="refresh-token-grant"></a>
### 5.2. Refresh Token Grant

<a name="rtg-token-endpoint"></a>
#### 5.2.1. Token Endpoint

<a name="refresh-token-requirements-and-recommendations"></a>
#### 5.2.2. Refresh Token Requirements and Recommendations

<a name="client-credentials-grant"></a>
### 5.3. Client Credentials Grant

<a name="other-grant-types"></a>
### 5.4. Other Grant Types

<a name="prohibited-grant-types"></a>
### 5.5. Prohibited Grant Types

This following grant types MUST NOT be used or supported by entities compliant with this profile:

- The Implicit Grant, as specified in section 4.2 of \[[RFC6749](#rfc6749)\].

- The Resource Owner Password Credentials Grant, as specified in section 4.3 of \[[RFC6749](#rfc6749)\].

<a name="security-requirements-and-considerations"></a>
## 6. Security Requirements and Considerations

- client authentication
- PKCE
- sender constrained tokens
- ...

<a name="references"></a>
## 7. References

<a name="normative-references"></a>
### 7.1. Normative References

<a name="rfc2119"></a>
**\[RFC2119\]**
> [Bradner, S., Key words for use in RFCs to Indicate Requirement Levels, March 1997](https://www.ietf.org/rfc/rfc2119.txt).

<a name="rfc6749"></a>
**\[RFC6749\]**
> [Hardt, D., "The OAuth 2.0 Authorization Framework", RFC 6749, DOI 10.17487/RFC6749, October 2012](https://tools.ietf.org/html/rfc6749).

<a name="informational-references"></a>
### 7.2. Informational References
