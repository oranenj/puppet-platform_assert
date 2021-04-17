function platform_assert::os_supported(
  String $source_module,
) {
  require platform_assert
  if !member($platform_assert::modules_with_broken_metadata, $source_module) {
    $metadata = load_module_metadata($source_module)
    $_os = $facts['os']['name']
    $_majrel = $facts['os']['release']['major']

    if !$metadata['operatingsystem_support'] {
      platform_assert::fail('os_undeclared', $source_module, 'OS support undeclared')
    } else {
      $os_spec = $metadata['operatingsystem_support'].filter |$item| {
        $_os == $item['operatingsystem']
      }
      if empty($os_spec) {
        platform_assert::fail('os_undeclared', $source_module, 'OS support undeclared')
      } else {
        $releases = $os_spec[0]['operatingsystemrelease']
        # If no operating systems releases are specified, assume that they are all supported
        if $releases and !$releases.any |$rel| { versioncmp($_majrel, $rel) == 0 } {
          platform_assert::fail('os_unsupported', $source_module, "OS release ${_majrel} is not supported: ${releases.join(', ')}")
        }
      }
    }
  }
}
