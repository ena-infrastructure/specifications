![Logo](images/ena-logo.png)

# Ena Infrastructure OAuth 2.0 Profiles and Specifications 

This is the starting page for the OAuth 2.0 profiles and specifications developed by the Ena Infrastructure technical working group.

## Specifications

- [Ena OAuth 2.0 Interoperability Profile](https://ena-infrastructure.github.io/specifications/ena-oauth2-profile.html) &mdash; This document defines a profile for OAuth 2.0 to enhance interoperability, strengthen security, and enable more efficient and cost-effective deployments. While the profile is primarily intended for Swedish public and private services and organizations, it is not limited to them.

- [Ena OAuth 2.0 User Authentication Best Practices](https://ena-infrastructure.github.io/specifications/ena-oauth2-authn-bp.html) &mdash; In many cases, a user is already logged in to a web service (which also acts as an OAuth 2.0 client) before the first request to the OAuth 2.0 authorization server is made. Since we want a smooth user experience, we do not want the user to have to authenticate again at the authorization server. This document provides best practices for how to integrate application-level user authentication with an OAuth 2.0 deployment.

### Coming papers

Below is a listing of profiles and documents that will be produced by the Ena Infrastructure working group.

- **Ena OAuth 2.0 Cookbook** &mdash; An informational document that illustrates common OAuth 2.0 use cases with recipes for how to send requests, process responses, and handle access tokens.

- **Ena OAuth 2.0 Federation Interoperability Profile** &mdash; Historically, OAuth 2.0 has been used in a non-federative way, where clients register with authorization servers either manually or via a registration protocol. As a result of the emergence of the [OpenID Federation](https://openid.net/specs/openid-federation-1_0.html), it will be possible to use OAuth 2.0 entities in a federative way, where client metadata may be resolved by an authorization server at runtime, or where an authorization server’s decisions may be based on metadata such as trust marks.<br /><br />This document profiles how OAuth 2.0 entities should join and operate within a federation according to the [OpenID Federation](https://openid.net/specs/openid-federation-1_0.html) standard.

- **Ena OAuth 2.0 Token Exchange Interoperability Profile** &mdash; An OAuth 2.0 profile for how to use the [OAuth 2.0 Token Exchange](https://www.rfc-editor.org/rfc/rfc8693.html) standard for solving issues such as identity and authorization chaining across domains and the use of OAuth 2.0 access tokens in back-end services. 

## Feedback and Contributions

The work is performed on GitHub at <https://github.com/ena-infrastructure/specifications>.

Please give your feedback and comments by opening a [GitHub Issue](https://github.com/ena-infrastructure/specifications/issues).

