# Core Components

## About

Spring Security authentication consists of several key components that work together to authenticate users and manage security contexts. Below are the core components -

<table data-full-width="false"><thead><tr><th width="222">Component</th><th>Description</th></tr></thead><tbody><tr><td><strong>Security Filter Chain</strong></td><td>Handles security filters like authentication and authorization.</td></tr><tr><td><strong>AuthenticationManager</strong></td><td>Central component for handling authentication.</td></tr><tr><td><strong>AuthenticationProvider</strong></td><td>Validates authentication requests.</td></tr><tr><td><strong>UserDetailsService</strong></td><td>Loads user information from the database.</td></tr><tr><td><strong>UserDetails</strong></td><td>Represents authenticated user details.</td></tr><tr><td><strong>PasswordEncoder</strong></td><td>Hashes and validates passwords.</td></tr><tr><td><strong>SecurityContextHolder</strong></td><td>Stores authentication details of the current user.</td></tr><tr><td><strong>GrantedAuthority</strong></td><td>Represents roles and permissions.</td></tr><tr><td><strong>Authentication Token</strong></td><td>Stores authentication requests or responses.</td></tr><tr><td><strong>Security Configuration</strong></td><td>Defines security rules and authentication mechanisms.</td></tr></tbody></table>







