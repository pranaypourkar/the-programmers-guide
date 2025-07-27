---
hidden: true
---

# SAML

3rd party website that uses SAML2 for SSO for testing free



Yes, there are third-party websites that provide testing environments for SAML2 Single Sign-On (SSO) integration. Here are a few popular options:

1. OneLogin SAML Test Connector (https://www.onelogin.com/saml-tester): OneLogin offers a free SAML test connector that allows you to test SAML SSO configurations without needing your own application. You can use it to simulate SAML requests and responses for testing and troubleshooting purposes.
2. Okta SAML Test App (https://www.okta.com/resources/saml-test-app/): Okta provides a SAML test application that enables you to test SAML SSO configurations. It allows you to initiate SAML flows and receive SAML responses for testing different scenarios.
3. SSO Circle (https://www.ssocircle.com/en/): SSO Circle offers a free online identity provider that supports SAML SSO. You can use their platform to set up and test SAML integrations with your applications.

These platforms provide test environments where you can configure SAML settings and test the SSO flow without the need for your own application or infrastructure. They are useful for validating your SAML configurations, troubleshooting issues, and ensuring seamless SSO integration.



I have my keycloak IdP and an app. I want to establish SSO from my app to a 3rd party webiste which supports SAML2.0 . Can I get 3rd party demo env online?



Yes, there are third-party demo environments available online that can help you test and establish SSO between your Keycloak Identity Provider (IdP) and a third-party website that supports SAML 2.0. Here are a few options you can explore:

1. Shibboleth Identity Provider Test Drive ([https://www.testshib.org/](https://www.testshib.org/)): TestShib is a free service that provides a demo environment for testing SAML 2.0 integration. It allows you to configure your Keycloak IdP and establish SSO with the test service provider. This can help you validate your SAML configuration and ensure smooth integration.
2. miniOrange SAML IdP Playground (https://idp.miniorange.com/moas/idp): miniOrange offers an online SAML IdP playground where you can simulate your Keycloak IdP and establish SSO with various test service providers. It provides a user-friendly interface for configuring SAML settings and testing the SSO flow.
3. Auth0 SAML IdP Sandbox (https://auth0.com/docs/protocols/saml-protocol/saml-20-identity-provider-sandbox): Auth0 provides a sandbox environment for testing SAML 2.0 integrations as an Identity Provider. Although Auth0 is primarily focused on identity and access management, you can utilize their sandbox to test your Keycloak IdP integration with third-party websites supporting SAML 2.0.

These demo environments allow you to configure your Keycloak IdP settings, generate test user accounts, and establish SSO with a third-party website that supports SAML 2.0. They provide a controlled environment for testing and validating your SSO integration without requiring you to set up your own infrastructure or relying on a production environment.



third-party website that supports SAML 2.0 means third-party has IdP which supports SAML 2.0. Can you explain?



Apologies for the confusion. You are correct that in the context of SAML 2.0, a third-party website acting as the service provider (SP) typically expects the identity provider (IdP) to support SAML 2.0.

To clarify further, let's define the roles involved in SAML-based SSO:

1. Identity Provider (IdP): This is the entity responsible for authenticating users and providing identity information to service providers. In the SAML context, the IdP asserts the user's identity by issuing SAML assertions containing user attributes and authentication statements.
2. Service Provider (SP): The SP is the web application or service that wants to authenticate users based on the information provided by the IdP. The SP relies on the SAML assertions received from the IdP to establish trust and grant access to the user.

In the scenario you mentioned, where you have your own Keycloak IdP and want to establish SSO with a third-party website that supports SAML 2.0, it implies that the third-party website is acting as the SP and expects the Keycloak IdP to act as the IdP and provide SAML-based authentication.

Therefore, in order to establish SSO between your app (Keycloak IdP) and the third-party website, you need to configure Keycloak as the IdP and ensure that it supports SAML 2.0. You will then need to provide the necessary SAML configuration details from your Keycloak IdP to the third-party website, allowing them to set up their SP to accept SAML assertions from your IdP.

Please note that it's the third-party website's responsibility to provide the necessary SAML 2.0 configuration options and details for you to configure your Keycloak IdP accordingly. It is recommended to consult the documentation or support resources of the third-party website to obtain the specific instructions for integrating with their SAML 2.0-based service as an IdP.



Is this contradicting? You will then need to provide the necessary SAML configuration details from your Keycloak IdP to the third-party website, allowing them to set up their SP to accept SAML assertions from your IdP. Please note that it's the third-party website's responsibility to provide the necessary SAML 2.0 configuration options and details for you to configure your Keycloak IdP accordingly.

Apologies for the confusion in my previous response. I apologize for the contradiction. Let me clarify:

In a typical SAML 2.0 SSO setup, the responsibility for configuring SAML settings lies with both the identity provider (IdP) and the service provider (SP).

To establish SSO between your Keycloak IdP and a third-party website acting as the SP, you need to exchange SAML configuration details and perform the following steps:

1. IdP Configuration (Keycloak): You will configure your Keycloak IdP to generate SAML assertions and provide the necessary SAML configuration details to the third-party website. This includes information such as the IdP entity ID, IdP metadata URL, and certificate details.
2. SP Configuration (Third-Party Website): The third-party website acting as the SP will need to configure their SP settings to accept SAML assertions from your Keycloak IdP. They will provide you with the necessary SAML configuration details, such as the SP entity ID, ACS (Assertion Consumer Service) URL, and their metadata or certificate details.

In summary, both the IdP (Keycloak) and the SP (third-party website) need to exchange and configure the required SAML details to establish SSO. The IdP provides the necessary configuration details to the SP, allowing them to set up their SP to accept SAML assertions from your IdP.

I apologize for the confusion caused by the contradictory statements in my previous response.

Ok. Suggest me some free SP that i can use in my project?

Certainly! Here are a few free Service Providers (SPs) that you can consider using in your project:

1. SimpleSAMLphp ([https://simplesamlphp.org/](https://simplesamlphp.org/)): SimpleSAMLphp is an open-source PHP-based framework for implementing SAML-based SSO. It provides a comprehensive set of features for both IdP and SP functionality. You can use SimpleSAMLphp as an SP in your project, allowing you to handle SAML-based authentication and integrate with various IdPs.
2. Shibboleth ([https://www.shibboleth.net/](https://www.shibboleth.net/)): Shibboleth is an open-source software package widely used for federated identity management and SAML-based SSO. It offers a robust SP implementation, allowing you to integrate with different IdPs. Shibboleth is primarily written in Java and is commonly used in higher education and research institutions.
3. Spring Security SAML Extension ([https://docs.spring.io/spring-security-saml/docs/2.0.x/reference/htmlsingle/](https://docs.spring.io/spring-security-saml/docs/2.0.x/reference/htmlsingle/)): If you're using Java and the Spring Framework in your project, you can leverage the Spring Security SAML Extension as your SP. It provides a comprehensive set of tools and features for implementing SAML-based SSO using Spring Security.
4. Gluu ([https://www.gluu.org/](https://www.gluu.org/)): Gluu is an open-source identity and access management platform that supports SAML-based SSO. It offers a free community edition that includes SP functionality. Gluu provides a user-friendly interface and allows you to manage SAML configurations and integrate with various IdPs.

These SP options provide robust features, extensive documentation, and community support. You can choose the one that aligns best with your project requirements, programming language preferences, and existing technology stack.
