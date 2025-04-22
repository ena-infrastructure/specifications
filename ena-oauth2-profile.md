![Logo](images/ena-logo.png)

# Ena OAuth 2.0 Interoperability Profile

### Version: 1.0 - draft 01 - 2025-04-17

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

    2.2. [Client Metadata and Registration](#client-metadata-and-registration)
    
    2.2.1. [Client Identifiers](#client-identifiers)

    2.2.2. [Client Registration Metadata](#client-registration-metadata)

    2.3. [Connections to Protected Resources](#connections-to-protected-resources)

3. [**Authorization Server Profile**](#authorization-server-profile)

4. [**Protected Resource Profile**](#protected-resource-profile)

    4.1. [Validation of Access Tokens](#validation-of-access-tokens)

    4.2. [Resource Server Error Responses](#resource-server-error-responses)

    4.3. [Protected Resource Identity and Registration](#protected-resource-identity-and-registration)
    
    4.4. [Protected Resource Access Requirements Modelling](#protected-resource-access-requirements-modelling)

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

6. [**Tokens**](#tokens)

    6.1. [Access Tokens](#access-tokens)

7. [**Security Requirements and Considerations**](#security-requirements-and-considerations)

    7.1. [General Security Requirements](#general-security-requirements)

    7.2. [Cryptographic Algorithms](#cryptographic-algorithms)

    7.3. [Client Authentication](#client-authentication)
    
    7.3.1. [Signed JWT for Client Authentication](#signed-jwt-for-client-authentication)

    7.3.2. [Mutual TLS for Client Authentication](#mutual-tls-for-client-authentication)

    7.4. [OAuth 2.0 Security Mechanisms](#oauth-20-security-mechanisms)

    7.5. [Threats and Countermeasures](#threats-and-countermeasures)

8. [**Requirements for Interoperability**](#requirements-for-interoperability)

    8.1. [Defining and Using Scopes](#defining-and-using-scopes)

9. [**References**](#references)

    9.1. [Normative References](#normative-references)

    9.2. [Informational References](#informational-references)

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

- Resource Server (RS) - A server hosting protected resources, capable of accepting and responding to protected resource requests using access tokens. In this document, we sometimes use the abbreviation "RS".

- Client - An application that makes requests to protected resources on behalf of a resource owner (user) with proper authorization. In some documentation concerning OAuth 2.0 and OpenID Connect, a client is sometimes referred to as a Relying Party.

- Authorization Server (AS) - A server responsible for issuing access tokens to a client after the resource owner (user) has been successfully authenticated and has granted the necessary authorization rights. In this document, we sometimes use the abbreviation "AS".

The OAuth 2.0 Authorization Framework: Bearer Token Usage, \[[RFC6750](#rfc6750)\], defines:

- Protected Resource (PR) - A resource (for example, an HTTP service), which is protected by OAuth 2.0 and requires a valid access token for access. In this document, we sometimes use the abbreviation "PR".

Clarification on the distinction between a Resource Server and a Protected Resource:

Some of the early OAuth 2.0 specifications used only the term Resource Server to denote the entity to which access is delegated. More recent specifications use the term Protected Resource, which is a more accurate and appropriate designation. This profile adopts the term Protected Resource when referring to the resource being protected and its access rules, and reserves the term Resource Server specifically for the server that hosts the Protected Resource, and is capable of accepting and processing access tokens.

<a name="conformance"></a>
### 1.3. Conformance

The profile document defines requirements for OAuth 2.0 protected resources, authorization servers, and clients.

When an entity compliant with this profile interacts with other entities that also conform to this profile, in any valid combination, all entities MUST fully adhere to the features and requirements of this specification. Interactions with non-compliant entities are outside the scope of this specification.

<a name="limitations-and-exclusions"></a>
### 1.4. Limitations and Exclusions

* An OAuth 2.0 public client is a client application that cannot securely store credentials, such as a private key. This is because the client runs in an environment where the code and storage are accessible to end users, making it vulnerable to extraction or tampering. Typical examples of public clients are single-page applications running in a web browser or mobile apps with no backend service.<br /><br />This version of the profile focuses only on OAuth 2.0 confidential clients, i.e., client applications that can securely store credentials, such as web applications with a backend component. Future versions may specify requirements for public clients if the need arises.

* This profile does not impose specific requirements on end-user authentication at the authorization server. This is a policy matter and is out of scope for this document.

* This profile does not specify process requirements for registering an OAuth 2.0 entity. Such requirements should be defined in supplementary specifications or policies.

* This profile does not define any requirements for using OAuth 2.0 in a federative context, as such requirements are out of scope. For guidance on this topic, refer to the "Ena OAuth 2.0 Federation Interoperability Profile", \[[ENA.Federation](#ena-federation)\].

* OAuth 2.0 Token Introspection, as specified in [RFC7662](https://datatracker.ietf.org/doc/html/rfc7662), is not covered in this document. However, an entity using this feature may still comply with this profile, provided that none of its requirements are violated.

* OAuth 2.0 Token Revocation, as specified in [RFC7009](https://datatracker.ietf.org/doc/html/rfc7009), is not covered in this document. However, an entity using this feature may still comply with this profile, provided that none of its requirements are violated.

<a name="client_profile"></a>
## 2. Client Profile

<a name="types-of-oauth-clients"></a>
### 2.1. Types of OAuth Clients

Within OAuth 2.0, there are two main types of clients: confidential clients and public clients. Confidential clients can securely store credentials registered with an authorization server, whereas public clients cannot store credentials securely. As pointed out in [1.4](#limitations-and-exclusions), [Limitations and Exclusions](#limitations-and-exclusions), above, this profile applies only to confidential clients. An OAuth 2.0 public client is not compliant with this profile.

Note: This does not mean that mobile apps and JavaScript web applications are disqualified. However, to be regarded as confidential, such applications must securely store credentials, for example, in a backend component.

Since this profile only handles confidential clients, we also distinguish between different subtypes of confidential clients. There are two main subtypes:

* **Client with user delegation** – A confidential client that acts on behalf of a resource owner (user) and requires delegation of the user’s authority to access a protected resource.

* **Machine-to-machine client without user delegation** – A confidential client that makes calls to a protected resource without the involvement of a resource owner (user).

These client subtypes correspond to the implementations of the [Authorization Code Flow](#authorization-code-grant) and [Client Credentials Flow](#client-credentials-grant), respectively.

<a name="client-metadata-and-registration"></a>
### 2.2. Client Metadata and Registration

This profile does not specify how an OAuth 2.0 client is registered with an authorization server or within a federation. This is out of scope for this profile.

However, for interoperability reasons, the requirements stated in the subsections below apply.

<a name="client-identifiers"></a>
#### 2.2.1. Client Identifiers

Every client compliant with the profile MUST be identified by a globally unique URL. This URL MUST use the HTTPS scheme and include a host component. It MUST NOT contain query or fragment components.

\[[RFC6749](#rfc6749)\] and \[[RFC7591](#rfc7591)\] state that a client identifier is simply a unique string. However, since this profile also focuses on the use of OAuth 2.0 across security domains and within federations, the requirements for “Entity Identifiers” as defined in \[[OpenID.Federation](#openid-federation)\] also apply to this profile.

A client registered with multiple authorization servers MUST use the same client identifier (`client_id`) for all registrations. This implies that an authorization server compliant with this profile MUST support clients with client identifiers issued by external parties.

<a name="client-registration-metadata"></a>
#### 2.2.2. Client Registration Metadata

Section 2 of "OAuth 2.0 Dynamic Client Registration Protocol", \[[RFC7591](#rfc7591)\], lists client metadata claims, and entities compliant with this profile MUST adhere to the requirements in that section, with the extensions and clarifications stated in the subsections below.

Within a pure OAuth 2.0 context, there is no concept of a "client metadata document". The OAuth 2.0 specifications address how a client is registered with an authorization server, and if a client is registered with multiple authorization servers, the registration data may vary between them. Thus, the claims in Section 2 of \[[RFC7591](#rfc7591)\] should be regarded as client registration metadata for a particular registration, rather than as a client metadata document.

> \[[ENA.Federation](#ena-federation)\] specifies requirements for a client producing a metadata document for use within a federation.

<a name="redirect-uris"></a>
##### 2.2.2.1. Redirect URIs

**Metadata claim:** `redirect_uris`

The `redirect_uris` claim is REQUIRED if the client is registered for the `authorization_code` grant type (or any other custom redirect-based flow). If set, at least one URI MUST be provided.

The redirect URIs provided MUST be absolute URIs, as defined in Section 4.3 of \[[RFC3986](#rfc3986)\], to prevent mix-up attacks involving clients. See Section 4.1.1 of \[[RFC9700](#rfc9700)\] for further details.

Redirect URIs MUST be one of the following:

- An HTTPS URL,

- a client-specific URI scheme (provided the requirements for confidential clients apply to a mobile app and that the scheme identifies a protocol that is not for remote access),

- and, for testing purposes, a URI that is hosted on the local domain of the client (e.g., `http://localhost:8080`).

If more than one redirect URI is provided, different domains SHOULD NOT be used.

> TODO: Add reference to security chapter where attacks concerning redirects are listed.

<a name="token-endpoint-authentication-method"></a>
##### 2.2.2.2. Token Endpoint Authentication Method

**Metadata claim:** `token_endpoint_auth_method`

The `token_endpoint_auth_method` claim is REQUIRED for the client metadata. It gives the client authentication method for accessing the authorization server token endpoint.

Section [7.3](#client-authentication), [Client Authentication](#client-authentication), gives the requirements for how a client authenticates against the authorization server token endpoint. Thus, for clients compliant with this profile the `token_endpoint_auth_method` can be any of the following values:

- `private_key_jwt` - See [7.3.1](#signed-jwt-for-client-authentication), [Signed JWT for Client Authentication](#signed-jwt-for-client-authentication), below.

- `tls_client_auth` or `self_signed_tls_client_auth` - See [7.3.2](#mutual-tls-for-client-authentication), [Mutual TLS for Client Authentication](#mutual-tls-for-client-authentication), below.<br /><br />If `tls_client_auth` is used, additional claims according to section 2.1.2 of \[[RFC8705](#rfc8705)\] MUST be provided.

> A client operating in a federated context may use different methods for different authorization servers. This is out of scope for this profile and is addressed in \[[ENA.Federation](#ena-federation)\].

<a name="token-endpoint-grant-types"></a>
##### 2.2.2.3. Token Endpoint Grant Types

**Metadata claim:** `grant_types`

The `grant_types` claim is an array of grant type strings that the client can use at the token endpoint of an authorization server. The claim is OPTIONAL, and if not present, the `authorization_code` grant type MUST be assumed. 

The client metadata MUST NOT include the `implicit` and `password` grant types among the `grant_types` values. See section [5.5](#prohibited-grant-types), [Prohibited Grant Types](#prohibited-grant-types), below.

<a name="json-web-key-set"></a>
##### 2.2.2.4. JSON Web Key Set

**Metadata claim:** `jwks` or `jwks_uri`

The client's JSON Web Key Set \[[RFC7517](#rfc7517)\] document, passed by value or reference (URI).

If the client has registered the `private_key_jwt` token endpoint authentication method, or if the client produces signatures in other circumstances, one, but not both, of the `jwks` and `jwks_uri` claims is REQUIRED.

To facilitate a smooth key rollover, each JWK of the referenced document SHOULD include a `kid` parameter.

The JWKs provided in the key set MUST adhere to the requirements put in section [7.2](#cryptographic-algorithms), [Cryptographic Algorithms](#cryptographic-algorithms), below.

<a name="human-readable-client-metadata"></a>
##### 2.2.2.5. Human-readable Client Metadata

Client metadata values intended for human consumption, either directly or via reference (URIs), SHOULD be provided in both English and Swedish using language tags according to BCP 47, \[[RFC5646](#rfc5646)\].

For maximum interoperability, it is RECOMMENDED to also include claim values without language tags. This profile does not specify which language should be used as the default.

Examples:

```
{
  "client_name" : "Example client",
  "client_name#sv" : "Exampelklienten",
  "client_name#en" : "Example client",
  ...
  "policy_uri" : "https://www.example.com/policy",
  "policy_uri#sv" : "https://www.example.com/policy/sv",
  "policy_uri#sv" : "https://www.example.com/policy",
  ...
```  

For further requirements see section 2.2 of \[[RFC7591](#rfc7591)\].

<a name="connections-to-protected-resources"></a>
### 2.3. Connections to Protected Resources

An OAuth 2.0 client accesses a protected resource by including an access token in its request to the resource server. This section outlines the requirements for how a client compliant with this profile should present an access token in requests to the resource server.

All authorized requests from a client to a resource server MUST be protected by TLS according to section [7.1](#general-security-requirements), [General Security Requirements](#general-security-requirements), below.

Clients adhering to this profile SHOULD send the access token in the `Authorization` header using the `Bearer` scheme according to section 2.1 of \[[RFC6750](#rfc6750)\].

Example:

```
GET /data HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3 \
ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.tyhVfuz \
IxCyGYDlkBA7DfyjrqmSHu6pQ2hoZuFqUSLPNY2N0mpHb3nk5K17HWP_3cYHBw7AhHale5wky6-sVA
```

Clients MAY send the access token in an HTTP request by including it as a form-encoded content parameter named `access_token`, as defined by section 2.2 of \[[RFC6750](#rfc6750)\].

Clients MUST NOT include the access token as a URI query parameter (section 2.3 of \[[RFC6750](#rfc6750)\]). The reason is that the access token would be visible in the URL and could be stolen by attackers, for example, from the web browser history. Consequently, a resource server compliant with this profile MUST NOT accept an access token transmitted in a query parameter.

Clients MUST support and be able to process the `WWW-Authenticate` response header field as specified by section 3 of [[RFC6750](#rfc6750)\].

<a name="authorization-server-profile"></a>
## 3. Authorization Server Profile

> Should be able to handle clients registered elsewhere

> Should support rfc9101?

> https://www.iana.org/assignments/oauth-parameters/oauth-parameters.xhtml

<a name="protected-resource-profile"></a>
## 4. Protected Resource Profile

An OAuth 2.0 resource server hosting a protected resource grants access to clients if they present a valid access token with the appropriate scope. The resource server trusts an authorization server to authenticate users and, optionally, obtain their consent before issuing an access token to a client. This section outlines the interoperability and security requirements for OAuth 2.0 protected resources and resource servers.

A resource server compliant with this profile MUST accept access tokens passed in the `Authorization` header as a bearer token, as specified in section 2.1 of \[[RFC6750](#rfc6750)\], and access tokens passed as form-encoded content parameters, as specified in section 2.2 of \[[RFC6750](#rfc6750)\].

Resource servers MUST NOT accept access tokens passed in a URI query parameter (section 2.3 of \[[RFC6750](#rfc6750)\]).

Depending on how a resource server services a request, it MAY also act as an OAuth 2.0 client when it needs to invoke underlying protected resources as part of its processing. This pattern may involve features such as "token exchange", which is not covered in this profile. 

> *TODO: Include pointer to informational reference.*

<a name="validation-of-access-tokens"></a>
### 4.1. Validation of Access Tokens

This profile specifies access tokens only in the form of JWT bearer tokens. This section outlines the requirements for resource servers to validate such access tokens.

Note: This section does not specify any requirements regarding "Token introspection", \[[RFC7662](https://datatracker.ietf.org/doc/html/rfc7662)\], as it is out of scope for this profile.

Resource servers compliant with this profile MUST validate JWT access tokens as specified in section 4 of \[[RFC9068](#rfc9068)\], with the following modifications and clarifications:

* An access token that is not signed according to the requirements specified in section [6.1](#access-tokens) below, MUST be rejected.

* Reuse of access tokens across multiple authorized requests MAY be allowed, provided the token remains valid and the protected resource does not enforce single-use semantics. Resource servers that require high assurance or non-repudiation may choose to enforce non-reusability of tokens using the `jti` claim as part of a replay detection strategy.<br /><br />If a protected resource does not permit reuse of access tokens, the resource server MUST maintain a cache of previously received JWT IDs (`jti`). If an access token’s `jti` claim is found in the cache and has not expired, the access token MUST be rejected. See Section 4.1.7 of \[[RFC7519](#rfc7519)\] for the definition of the `jti` claim.

    - A resource server deployed across multiple instances MUST share a common replay cache.
    
    - A cached `jti` value is considered expired when the JWT from which it was extracted is no longer valid, based on its `exp` claim.
    
* If a protected resource's access rules are based on scopes, the JWT MUST include the `scope` claim (see section 2.2.3 of \[[RFC9068](#rfc9068)\]) with an appropriate scope value. Otherwise, the access token MUST be rejected.

<a name="resource-server-error-responses"></a>
### 4.2. Resource Server Error Responses

If a request to the resource server fails or is rejected, the resource server MUST inform the client of the error as specified in Section 3 of \[[RFC6750](#rfc6750)\].

A typical example might look like this:

```
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer realm="example",
                  error="invalid_token",
                  error_description="The access token has expired"
```

To ensure interoperability, a resource server compliant with this profile SHOULD NOT use any error codes other than those specified in section 3.1 of \[[RFC6750](#rfc6750)\].

If an access token is rejected due to insufficient scope(s), it is RECOMMENDED to include the scope attribute in the `WWW-Authenticate` header of the error response. This attribute MUST specify the required scope(s) for accessing the protected resource.

Example:

```
HTTP/1.1 403 Forbidden
WWW-Authenticate: Bearer realm="example",
                  scope="read write"
                  error="insufficient_scope",
                  error_description="Scopes 'read' or 'write' are required"
```

<a name="protected-resource-identity-and-registration"></a>
### 4.3. Protected Resource Identity and Registration

A protected resource compliant with this profile MUST have a Resource Identifier assigned. This identifier MUST be a URL using the HTTPS schema and including a host component. It SHOULD NOT include a query component, and MUST NOT include a fragment component.

If the protected resource is functioning in a multi-domain, or federative, context, its identifier MUST be globally unique.

A protected resource MAY support publication of its metadata according to the draft "OAuth 2.0 Protected Resource Metadata", \[[Protected.Resource.Metadata](#protected-resource-metadata)\].

It is RECOMMENDED that a protected resource be assigned a resource identifier that corresponds to the URL at which it exposes its service.

Furthermore, if a resource server hosts multiple resources that do not share the same access rules, it is RECOMMENDED that these resources be treated as separate protected resources, and thus be represented with their own resource identifiers.

**Example:**

Assume there are two different servers, server1 and server2, as shown in the illustration below.

![Resource Servers](images/resource-servers.png)

The endpoints on server1 do not share the same access rules and should therefore be treated as two separate protected resources: `https://server1.example.com/api` and `https://server1.example.com/admin`. In contrast, the endpoints exposed by server2 have the same access rules and can therefore be represented by a single protected resource: `https://server2.example.com`.

> Note: In the example below, access rules are illustrated solely through scope requirements. In a real-world scenario, additional rules—such as requiring a specific level of end-user authentication—may also apply.

<a name="protected-resource-access-requirements-modelling"></a>
### 4.4. Protected Resource Access Requirements Modelling

- TODO: Rules and recommendations concerning required scopes (and additional information).

> TODO: Describe both the policy/requirements at the authorization server as well as checks made at the protected resource.

> TODO: Recommendations so that most of the access check can be made by the AS. An PR/RS should only check that subject corresponds to data that is asked for (in case a user's data is requested).

<a name="grant-types"></a>
## 5. Grant Types

<a name="authorization-code-grant"></a>
### 5.1. Authorization Code Grant

<a name="authorization-requests"></a>
#### 5.1.1. Authorization Requests

> TODO: Note about multiple `redirect_uris`. See 2.3.2 of OAuth2.1

> Recommend using JAR, (JWT-Secured Authorization Requests), according to RFC9101, if sensible data is transferred in the authorization request.

<a name="authorization-responses"></a>
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

<a name="tokens"></a>
## 6. Tokens

<a name="access-tokens"></a>
### 6.1. Access Tokens

> TODO: Specify JWT access token format

> If an authorization request includes a scope parameter, the corresponding issued JWT access token MUST include a `scope` claim. Section 2.2.3 of \[[RFC9068](#rfc9068)\].

- `azp`?

<a name="security-requirements-and-considerations"></a>
## 7. Security Requirements and Considerations

<a name="general-security-requirements"></a>
### 7.1. General Security Requirements

All transactions MUST be protected in transit by TLS as described in \[[NIST.800-52.Rev2](#nist800-52)\].

A party acting as a client in a TLS handshake MUST successfully validate the TLS certificate chain up to a trusted root before proceeding with the transaction.

All parties compliant with this profile MUST conform to applicable recommendations in section 16, "Security Considerations" of \[[RFC6749](#rfc6749)\] and those found in "Best Current Practice for OAuth 2.0 Security", \[[RFC9700](#rfc9700)\].

<a name="cryptographic-algorithms"></a>
### 7.2. Cryptographic Algorithms

This section lists the requirements for cryptographic algorithm support for being compliant with
this profile.

All entities compliant with this profile MUST follow the guidelines in \[[NIST.800-131A.Rev2](#nist800-131)\] regarding use of algorithms and key lengths. Specifically, for signature and encryption keys the following requirements apply:

- RSA public keys MUST be at least 2048 bits in length.
- EC public keys MUST be at least 256 bits in length (signature only). The curve NIST Curve P-256 MUST be supported (\[[RFC5480](#rfc5480)\]), and NIST Curve P-384 and NIST Curve P-521 SHOULD be supported.

Entities conforming to this profile MUST support algorithms according to "JSON Web Algorithms (JWA)", 
\[[RFC7518](#rfc7518)\], with the following additions:

- `RS256`, RSASSA-PKCS1-v1_5 using SHA-256, is listed as recommended in \[[RFC7518](#rfc7518)\], but is
REQUIRED to support by this profile.

- `RS384`, RSASSA-PKCS1-v1_5 using SHA-384, is listed as optional in \[[RFC7518](#rfc7518)\],
but is RECOMMENDED to support by this profile.

- `RS512`, RSASSA-PKCS1-v1_5 using SHA-512, is listed as optional in \[[RFC7518](#rfc7518)\],
but is RECOMMENDED to support by this profile.

- `ES256`, ECDSA using P-256 and SHA-256, is listed as recommended in \[[RFC7518](#rfc7518)\], but
is REQUIRED to support by this profile.

- `ES384`, ECDSA using P-384 and SHA-384, is listed as optional in \[[RFC7518](#rfc7518)\], but is 
RECOMMENDED to support by this profile.

- `ES512`, ECDSA using P-521 and SHA-512, is listed as optional in \[[RFC7518](#rfc7518)\], but is
RECOMMENDED to support by this profile.

The sender of a secure message MUST NOT use an algorithm that is not set as REQUIRED in \[[RFC7518](#rfc7518)\] or in the listing above, unless it is explicitly declared by the peer in its metadata or registration data.

**Note:** \[[NIST.800-131A.Rev2](#nist800-131)\] contains a listing of algorithms that must not be used. However, there is a need to explicitly point out that the commonly used algorithm SHA-1 for digests is considered broken and MUST NOT be used or accepted.

<a name="client-authentication"></a>
### 7.2. Client Authentication

<a name="signed-jwt-for-client-authentication"></a>
#### 7.2.1. Signed JWT for Client Authentication

> `private_key_jwt`, RFC7523

<a name="mutual-tls-for-client-authentication"></a>
#### 7.2.2. Mutual TLS for Client Authentication

> RFC8705

`tls_client_auth` or `self_signed_tls_client_auth`.

<a name="oauth-20-security-mechanisms"></a>
### 7.4. OAuth 2.0 Security Mechanisms

- PKCE
- sender constrained tokens
- ...

> Sub-chapter about redirects. Open redirector, etc.

<a name="threats-and-countermeasures"></a>
### 7.5. Threats and Countermeasures

<a name="requirements-for-interoperability"></a>
## 8. Requirements for Interoperability 

<a name="defining-and-using-scopes"></a>
### 8.1. Defining and Using Scopes

An OAuth 2.0 scope is a mechanism for defining and limiting access to protected resources. It tells the authorization server what level of access the client is requesting, and tells the resource server what access the client has been granted.

In the early days of OAuth 2.0, a typical deployment involved a single authorization server configured to protect a single protected resource. In such cases, when a client requested an access token for a given scope, it was clear to the authorization server which protected resource was being referred to and how to apply its processing logic. Scopes such as `read` and `write` were commonly used and worked well in this context. Their meaning was unambiguous, since the authorization server was configured to protect only one resource.

However, when an authorization server protects multiple resources, how can it determine which resource is being requested based solely on a requested scope?

If generic scopes such as `read` and `write` are used, the authorization server cannot deduce which protected resource the client is requesting access to. To address this limitation, there are two possible solutions:

- Use the `resource` parameter. By using the `resource` parameter as specified in \[[RFC8707](#rfc8707)\], the combination of the indicated protected resource and a (generic) scope provides the authorization server with enough information to process the request and issue an access token.

- Define and use non-generic scopes. By defining scopes that are valid only for a specific use case (e.g., a particular protected resource), the authorization server can determine which resource the client is requesting access to based solely on the requested scope.

It may be tempting to choose the first solution and require that all authorization requests include the `resource` parameter, but there are several issues with this approach that make it less desirable:

- Support for the resource parameter, as defined in \[[RFC8707](#rfc8707)\], is not yet widely implemented in standard software.

- The authorization server metadata claim `scopes_supported` (defined in Section 2 of \[[RFC8414](#rfc8414)\]) loses its usefulness, as there is no information indicating which scope maps to which protected resource. Furthermore, if the authorization server is used in a federated context as described in \[[OpenID.Federation](#openid-federation)\], filtering the authorization server metadata according to policy becomes impossible with respect to the `scopes_supported` claim.

Therefore, this profile specifies the following recommendations and requirements:

An authorization server that either protects multiple protected resources or publishes its metadata in a federation (as defined in \[[OpenID.Federation](#openid-federation)\]) SHOULD use scopes that are unique for a given purpose.

If the authorization server operates within a federation, a defined scope values MUST be unique within that federation.

A scope value MAY be defined to map to a set of protected resources, provided they support the same function and access policy. In such cases, the authorization server MAY accept a `resource` parameter to uniquely identify a specific protected resource, or it may issue an access token with multiple audiences (i.e., valid for all protected resources associated with that scope).

It is RECOMMENDED that scope values follow the format: a URL prefix followed by the access right.

It is RECOMMENDED that scope values unique to a single protected resource be constructed using the resource’s identifier followed by the specific access right.

**Example:**

> Suppose the protected resource identified by `https://server.example.com/api` supports two distinct access rights: read and write. 

> The scopes `https://server.example.com/api/read` and `https://server.example.com/api/write` would then uniquely identify the read and write permissions for that protected resource.

An authorization server MAY choose to map a unique scope to a different scope value when including scopes in an access token. This can be useful, for example, when the protected resource is a legacy system with hardcoded scope definitions. Referring to the example above, if a client requests the `https://server.example.com/api/read` scope, the resulting JWT access token could instead contain the scope `read`.

However, if the protected resource implements “OAuth 2.0 Protected Resource Metadata”, [[Protected.Resource.Metadata](#protected-resource-metadata)\], scope mapping in the authorization server SHOULD NOT be performed. In such cases, the `scopes_supported` claim in the protected resource metadata would not align with the actual scopes used by clients, leading to inconsistency and potential interoperability issues.

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

<a name="rfc5646"></a>
**\[RFC5646\]**
> [Phillips, A., Ed. and M. Davis, Ed., "Tags for Identifying Languages", BCP 47, RFC 5646, DOI 10.17487/RFC5646, September 2009](http://www.rfc-editor.org/info/rfc5646).

<a name="rfc6749"></a>
**\[RFC6749\]**
> [Hardt, D., "The OAuth 2.0 Authorization Framework", RFC 6749, DOI 10.17487/RFC6749, October 2012](https://tools.ietf.org/html/rfc6749).

<a name="rfc6750"></a>
**\[RFC6750\]**
> [Jones, M. and D. Hardt, "The OAuth 2.0 Authorization Framework: Bearer Token Usage", RFC 6750, DOI 10.17487/RFC6750, October 2012](http://www.rfc-editor.org/info/rfc6750).

<a name="rfc7518"></a>
**\[RFC7518\]**
> [Jones, M., "JSON Web Algorithms (JWA)", May 2015](https://www.rfc-editor.org/rfc/rfc7518).

<a name="rfc7591"></a>
**\[RFC7591\]**
> [Richer, J., Ed., Jones, M., Bradley, J., Machulak, M., and P. Hunt, "OAuth 2.0 Dynamic Client Registration Protocol", RFC 7591, DOI 10.17487/RFC7591, July 2015](https://www.rfc-editor.org/info/rfc7591).

<a name="rfc7517"></a>
**\[RFC7517\]**
> [Jones, M., "JSON Web Key (JWK)", RFC 7517, DOI 10.17487/RFC7517, May 2015](http://www.rfc-editor.org/info/rfc7517).

<a name="rfc7519"></a>
**\[RFC7519\]**
> [Jones, M., Bradley, J., and N. Sakimura, "JSON Web Token (JWT)", RFC 7519, DOI 10.17487/RFC7519, May 2015](https://datatracker.ietf.org/doc/html/rfc7519).

<a name="rfc8414"></a>
**\[RFC8414\]**
> [Jones, M., Sakimura, N., and J. Bradley, "OAuth 2.0 Authorization Server Metadata", RFC 8414, DOI 10.17487/RFC8414, June 2018](https://datatracker.ietf.org/doc/html/rfc8414).

<a name="rfc8705"></a>
**\[RFC8705\]**
> [Campbell, B., Bradley, J., Sakimura, N., and T. Lodderstedt, "OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens", RFC 8705, DOI 10.17487/RFC8705, February 2020](https://www.rfc-editor.org/info/rfc8705).

<a name="rfc8707"></a>
**\[RFC8707\]**
> [Campbell, B., Bradley, J., and H. Tschofenig, "Resource Indicators for OAuth 2.0", RFC 8707, DOI 10.17487/RFC8707, February 2020](https://datatracker.ietf.org/doc/html/rfc8707).

<a name="rfc9068"></a>
**\[RFC9068\]**
> [Bertocci, V., "JSON Web Token (JWT) Profile for OAuth 2.0 Access Tokens", RFC 9068, October 2021](https://datatracker.ietf.org/doc/html/rfc9068).

<a name="rfc9700"></a>
**\[RFC9700\]**
> [Lodderstedt, T., Bradley, J., Labunets, A., Fett, D., "Best Current Practice for OAuth 2.0 Security", RFC 9700, January 2025](https://datatracker.ietf.org/doc/html/rfc9700).

<a name="nist800-52"></a>
**\[NIST.800-52.Rev2\]**
> [NIST Special Publication 800-52, Revision 2, "Guidelines for the Selection, Configuration, and Use of Transport Layer Security (TLS) Implementations"](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-52r2.pdf). 

<a name="nist800-131"></a>
**\[NIST.800-131A.Rev2\]**
> [NIST Special Publication 800-131A Revision 2, "Transitioning the Use of Cryptographic Algorithms and Key Lengths"](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-131Ar2.pdf)

<a name="informational-references"></a>
### 9.2. Informational References

<a name="openid-federation"></a>
**\[OpenID.Federation\]**
> [Hedberg, R., Jones, M.B., Solberg, A.Å., Bradley, J., De Marco, G., Dzhuvinov, V., "OpenID Federation 1.0", March 2025](https://openid.net/specs/openid-federation-1_0.html).

<a name="ena-federation"></a>
**\[ENA.Federation\]**
> [Ena OAuth 2.0 Federation Interoperability Profile](ena-oauth2-federation.md).

<a name="protected-resource-metadata"></a>
**\[Protected.Resource.Metadata\]**
> [Jones, M.B., Hunt, P., Parecki, A., draft-ietf-oauth-resource-metadata-13, October 2024, "OAuth 2.0 Protected Resource Metadata"](https://datatracker.ietf.org/doc/draft-ietf-oauth-resource-metadata/).
 

