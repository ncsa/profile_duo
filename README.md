# profile_duo

![pdk-validate](https://github.com/ncsa/puppet-profile_duo/workflows/pdk-validate/badge.svg)
![yamllint](https://github.com/ncsa/puppet-profile_duo/workflows/yamllint/badge.svg)

NCSA Common Puppet Profiles - configure Duo for Two-Factor Authentication for SSH with PAM Support (pam_duo)

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with profile_duo](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Dependencies](#dependencies)
1. [Reference](#reference)


## Description

This puppet profile customizes a host to install and configure Duo 2FA

See https://duo.com/docs/duounix

Note: This module is highly based off the no longer supported module from Duo:
- [duosecurity/duo_unix](https://forge.puppet.com/modules/duosecurity/duo_unix)


## Setup

Include profile_duo in a puppet profile file:
```
include ::profile_duo
```


## Usage

The following parameters will need to be set via Hiera (preferably the keys should come from Vault):
```
profile_duo::host: "duo_host_obtained_from_duo_admins"
profile_duo::ikey: "ikey_obtained_from_duo_admins"   # STORE IN VAULT INSTEAD OF YAML
profile_duo::skey: "skey_obtained_from_duo_admins"   # STORE IN VAULT INSTEAD OF YAML
sshd::config:
  AuthenticationMethods: "gssapi-with-mic,keyboard-interactive:pam password,keyboard-interactive:pam"
  ChallengeResponseAuthentication: "yes"
  GSSAPIStrictAcceptorCheck: "no"
  KerberosAuthentication: "yes"
```

See [Protecting your system or application with NCSA Duo](https://wiki.ncsa.illinois.edu/display/cybersec/Duo+at+NCSA#DuoatNCSA-ProtectingyoursystemorapplicationwithNCSADuo) for instructions on obtaining keys for your specific host(s).

If making use of [ncsa/profile_allow_ssh_from_bastion](https://github.com/ncsa/puppet-profile_allow_ssh_from_bastion) or similar profiles, you will want to set the following in hiera:
```
profile_allow_ssh_from_bastion::custom_cfg:
  AuthenticationMethods: "gssapi-with-mic,keyboard-interactive:pam password,keyboard-interactive:pam"  ## NOT NEEDED IN sshd::config HASH
  DisableForwarding: "no"
  GSSAPIAuthentication: "yes"
  KerberosAuthentication: "yes"  ## NOT NEEDED IN sshd::config HASH
  MaxAuthTries: "6"
  PasswordAuthentication: "yes"  
  PubkeyAuthentication: "no"
``` 

If you want GSSAPI authentication to work with Kerberos tickets, you need to make sure that you have a Kerberos host principal in the default keytab file that matches the fully qualified domain name of the hostname that users log into.

## Dependencies

- [herculesteam/augeasproviders_pam](https://forge.puppet.com/modules/herculesteam/augeasproviders_pam)


## Reference

See: [REFERENCE.md](REFERENCE.md)

