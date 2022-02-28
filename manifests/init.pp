# @summary Install and manage Duo auth for SSH with PAM
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
# @param pam_config
#   pam resource parameters for setting up duo pam configurations
#
class profile_duo (
  String $yumrepo_baseurl,
  String $yumrepo_description,
  String $yumrepo_gpgkey,
  String $yumrepo_name,
  Hash   $pam_config,
) {

  ## install Pakrat Yum repo for Duo
  yumrepo { $yumrepo_name:
    ensure   => 'present',
    enabled  => 1,
    descr    => $yumrepo_description,
    baseurl  => $yumrepo_baseurl,
    gpgcheck => 1,
    gpgkey   => $yumrepo_gpgkey,
  }

  include ::duo_unix

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
