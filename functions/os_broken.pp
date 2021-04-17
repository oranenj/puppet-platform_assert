function platform_assert::os_broken(
  String $source_module,
  String $os_name,
  Optional[String] $release,
) {
  require platform_assert
  if $facts['os']['name'] == $os_name {
    # If no release is specified, assume they all are broken
    if !$release or $facts['os']['release']['major'] == $release {
      platform_assert('broken', $source_module, 'This OS release is known to be broken with this module')
    }
  }
  
}
