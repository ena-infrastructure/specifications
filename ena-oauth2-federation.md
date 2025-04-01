![Logo](images/ena-logo.png)

# Ena OAuth 2.0 Federation Interoperability Profile

### Version: 1.0 - draft 01 - 2025-03-31

## Abstract

The OAuth 2.0 framework defines mechanisms that allow users (resource owners) to delegate access rights to a protected resource for an application they are using. Additionally, OAuth 2.0 protocols are often used without user involvement in service-to-service scenarios.

Historically, OAuth 2.0 has been used in a non-federative way, where clients register with authorization servers either manually or via a registration protocol. As a result of the emergence of the [OpenID Federation](https://openid.net/specs/openid-federation-1_0.html), it will be possible to use OAuth 2.0 entities in a federative way, where client metadata may be resolved by an authorization server at runtime, or where an authorization server’s decisions may be based on metadata such as trust marks.

This document profiles how OAuth 2.0 entities should join and operate within a federation according to the [OpenID Federation](https://openid.net/specs/openid-federation-1_0.html) standard.

## Table of Contents

1. [**Introduction**](#introduction)

    1.1. [Requirements Notation and Conventions](#requirements-notation-and-conventions)
    
    1.2. [Terminology](#terminology)

    1.3. [Conformance](#conformance)

    1.4. [Limitations and Exclusions](#limitations-and-exclusions)
    
9. [**References**](#references)

    9.1. [Normative References](#normative-references)

    9.2. [Informational References](#informational-references)


<a name="introduction"></a>
## 1. Introduction

> TODO

<a name="requirements-notation-and-conventions"></a>
### 1.1. Requirements Notation and Conventions

The keywords “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” are to be interpreted as described in \[[RFC2119](#rfc2119)\].

These keywords are capitalized when used to unambiguously specify requirements over protocol features and behavior that affect the interoperability and security of implementations. When these words are not capitalized, they are meant in their natural-language sense.

<a name="terminology"></a>
### 1.2. Terminology

> TODO

<a name="conformance"></a>
### 1.3. Conformance

> TODO

<a name="limitations-and-exclusions"></a>
### 1.4. Limitations and Exclusions

> TODO

## TODO:s

- Requirements on resolvers - produce valid OAuth2 client registration data after filtering data

- Scopes should be globally unique

- Client metadata document

<a name="references"></a>
## 9. References

<a name="normative-references"></a>
### 9.1. Normative References

<a name="rfc2119"></a>
**\[RFC2119\]**
> [Bradner, S., "Key words for use in RFCs to Indicate Requirement Levels", March 1997](https://www.ietf.org/rfc/rfc2119.txt).

<a name="rfc3986"></a>
**\[RFC3986\]**
> [Berners-Lee, T., Fielding, R., and L. Masinter, "Uniform Resource Identifier (URI): Generic Syntax", STD 66, RFC 3986, DOI 10.17487/RFC3986, January 2005](https://www.rfc-editor.org/info/rfc3986).

<a name="rfc6749"></a>
**\[RFC6749\]**
> [Hardt, D., "The OAuth 2.0 Authorization Framework", RFC 6749, DOI 10.17487/RFC6749, October 2012](https://tools.ietf.org/html/rfc6749).

<a name="openid-federation"></a>
**\[OpenID.Federation\]**
> [Hedberg, R., Jones, M.B., Solberg, A.Å., Bradley, J., De Marco, G., Dzhuvinov, V., "OpenID Federation 1.0", March 2025](https://openid.net/specs/openid-federation-1_0.html).


<a name="informational-references"></a>
### 9.2. Informational References

<a name="rfc7591"></a>
**\[RFC7591\]**
> [Richer, J., Ed., Jones, M., Bradley, J., Machulak, M., and P. Hunt, "OAuth 2.0 Dynamic Client Registration Protocol", RFC 7591, DOI 10.17487/RFC7591, July 2015](https://www.rfc-editor.org/info/rfc7591).


