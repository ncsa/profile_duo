# @summary Install and manage Duo auth for SSH with PAM
#
# @param accept_env_factor,
#   Duo configuration for 'accept_env_factor'
#
# @param autopush,
#   Duo configuration for 'autopush'
#
# @param failmode,
#   Duo configuration for 'failmode'
#
# @param fallback_local_ip,
#   Duo configuration for 'fallback_local_ip', defaults to 'no'
#
# @param group,
#   Duo configuration for 'groups' Group restriction
#
# @param http_proxy,
#   Duo configuration for 'http_proxy' HTTP proxy setting
#
# @param host,
#   Duo API host
#
# @param ikey,
#   Duo integration key
#
# @param motd,
#   Duo configuration for 'motd' MOTD display (only applies if $usage = 'login')
#
# @param package,
#
# @param pam_config,
#   pam resource parameters for setting up duo pam configurations
#
# @param prompts,
#   Duo configuration for 'prompts'
#
# @param pushinfo,
#   Duo configuration for 'pushinfo'
#
# @param skey,
#   Duo secret key
#
# @param usage,
#   Duo usage method - defaults to 'pam'
#
# @param yumrepo_baseurl
#   baseurl of yumrepo used to install duo_unix package
#
# @param yumrepo_description
#   description of yumrepo used to install duo_unix package
#
# @param yumrepo_gpgkey
#   gpgkey of yumrepo used to install duo_unix package
#
# @param yumrepo_name
#   name of yumrepo used to install duo_unix package
#
class profile_duo (
  String $accept_env_factor,
  String $autopush,
  String $failmode,
  String $fallback_local_ip,
  String $group,
  String $http_proxy,
  String $host,
  String $ikey,
  String $motd,
  String $package,
  Hash   $pam_config,
  String $prompts,
  String $pushinfo,
  String $skey,
  String $usage,
  String $yumrepo_baseurl,
  String $yumrepo_description,
  String $yumrepo_gpgkey,
  String $yumrepo_name,
) {

  if $ikey == '' or $skey == '' or $host == '' {
    fail('ikey, skey, and host must all be defined.')
  }

  ## install Yum repo for Duo
  yumrepo { $yumrepo_name:
    ensure   => 'present',
    enabled  => 1,
    descr    => $yumrepo_description,
    baseurl  => $yumrepo_baseurl,
    gpgcheck => 1,
    gpgkey   => $yumrepo_gpgkey,
    priority => 1,
  }

  ## INSTALL $package
  package {  $package:
    ensure  => 'installed',
    require => [
      Yumrepo[$yumrepo_name],
    ],
  }

  file { '/usr/sbin/login_duo':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package[$package];
  }

  if $usage == 'pam' {
    ## CONFIGURE pam_duo
    file { '/etc/duo/pam_duo.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => template('profile_duo/duo.conf.erb'),
      require => Package[$package];
    }

    # CONFIGURE PAM STACK (BORROWED FROM LSST: stdcfg::access)
    ## The duo_unix module does NOT manage the PAM stack correctly.
    ## We do it our own way, based on what is documented by Duo Security:
    ##    https://duo.com/docs/duounix
    each($pam_config) |String[1] $key, Hash $value| {
      pam { $key:
        * => $value,
      }
    }
  }
  else
  {
    ## $usage == 'login'
    fail('usage = \'login\' is not supported.')

    #file { '/etc/duo/login_duo.conf':
    #  ensure  => present,
    #  owner   => 'root',
    #  group   => 'root',
    #  mode    => '0600',
    #  content => template('duo_unix/duo.conf.erb'),
    #  require => Package[$package];
    #}

  }

}
