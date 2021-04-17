function platform_assert::puppet_broken(
  String $source_module,
  SemVerRange $version_range,
) {
  require platform_assert

  if $facts['puppetversion'] =~ $version_range {
    platform_assert::fail('broken', "Puppet versions within ${version_range} are known to be broken with this module")
  }
}
