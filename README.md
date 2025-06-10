![Logo](images/ena-logo.png)

# Ena Infrastructure OAuth 2.0 Profiles and Specifications 

This repository contains OAuth 2.0 profiles and specifications developed by the Ena Infrastructure technical working group.

## Specifications

- [Ena OAuth 2.0 Interoperability Profile](ena-oauth2-profile.md) &mdash; This document defines a profile for OAuth 2.0 to enhance interoperability, strengthen security, and enable more efficient and cost-effective deployments. While the profile is primarily intended for Swedish public and private services and organizations, it is not limited to them.

### Coming papers

Below is a listing of profiles and documents that will be produced by the Ena Infrastructure working group.

- Ena OAuth 2.0 Cookbook &mdash; An informational document that illustrates common OAuth 2.0 use cases with recipes for how to send requests, process responses, and handle access tokens.

- [Ena OAuth 2.0 Federation Interoperability Profile](ena-oauth2-federation.md) &mdash; Historically, OAuth 2.0 has been used in a non-federative way, where clients register with authorization servers either manually or via a registration protocol. As a result of the emergence of the [OpenID Federation](https://openid.net/specs/openid-federation-1_0.html), it will be possible to use OAuth 2.0 entities in a federative way, where client metadata may be resolved by an authorization server at runtime, or where an authorization server’s decisions may be based on metadata such as trust marks.<br /><br />This document profiles how OAuth 2.0 entities should join and operate within a federation according to the [OpenID Federation](https://openid.net/specs/openid-federation-1_0.html) standard.

- Ena OAuth 2.0 Token Exchange Interoperability Profile &mdash; An OAuth 2.0 profile for how to use the [OAuth 2.0 Token Exchange](https://www.rfc-editor.org/rfc/rfc8693.html) standard for solving issues such as identity and authorization chaining across domains and the use of OAuth 2.0 access tokens in back-end services. 


