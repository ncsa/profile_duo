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


## Setup

Include profile_duo in a puppet profile file:
```
include ::profile_duo
```


## Usage

The following parameters will need to be set via Hiera (preferably via Vault):
```
duo_unix::ikey: "ikey_obtained_from_duo_admins"
duo_unix::skey: "skey_obtained_from_duo_admins"
```
See [Protecting your system or application with NCSA Duo](https://wiki.ncsa.illinois.edu/display/cybersec/Duo+at+NCSA#DuoatNCSA-ProtectingyoursystemorapplicationwithNCSADuo) for instructions on obtaining keys for your specific host(s).


## Dependencies

- [duosecurity/duo_unix](https://forge.puppet.com/modules/duosecurity/duo_unix)
- [herculesteam/augeasproviders_pam](https://forge.puppet.com/modules/herculesteam/augeasproviders_pam)
- [ncsa/pam_access](https://github.com/ncsa/puppet-pam_access)


## Reference

See: [REFERENCE.md](REFERENCE.md)

