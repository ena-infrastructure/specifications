![Logo](images/ena-logo.png)

# Ena OAuth 2.0 User Authentication Best Practices

### Version: 1.0 - draft 01 - 2025-06-11

## Abstract

The OAuth 2.0 framework defines mechanisms that allow users (resource owners) to delegate access rights to a protected resource for an application they are using. Additionally, OAuth 2.0 protocols are often used without user involvement in service-to-service scenarios.

In many cases, a user is already logged in to a web service (which also acts as an OAuth 2.0 client) before the first request to the OAuth 2.0 authorization server is made. Since we want a smooth user experience, we do not want the user to have to authenticate again at the authorization server. This document provides best practices for how to integrate application-level user authentication with an OAuth 2.0 deployment.

## Table of Contents

1. [**Introduction**](#introduction)

    
9. [**References**](#references)

    9.1. [Normative References](#normative-references)

    9.2. [Informational References](#informational-references)


<a name="introduction"></a>
## 1. Introduction

When a resource owner (i.e., the user) is directed to the authorization server from a client (i.e., an application) in order to delegate certain rights to the client, the OAuth 2.0 protocol dictates that the authorization server must authenticate the user before proceeding with user consent and further actions aimed at issuing an access token for the client.

That the authorization server needs to know which user it should delegate rights for is obvious, but how this authentication is actually performed is out of scope for the OAuth 2.0 specifications.




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


