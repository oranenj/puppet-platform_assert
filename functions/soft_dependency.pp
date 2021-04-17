function platform_assert::soft_dependency(
  String $source_module,
  String $dependency,
  Variant['any', SemVerRange] $required_version,
  String $reason,
) {
  require platform_assert
  if !member($platform_assert::modules_with_broken_metadata, $dependency) {
    $dep_metadata = load_module_metadata($dependency)

    if !$dep_metadata {
      platform_assert::fail('softdep_missing', $source_module, "Soft dependency on ${dependency} is missing (wanted for: ${reason})")
    } else {
      if $required_version != 'any' {
        # If metadata is invalid, we can't check, so fail
        $v = SemVer($dep_metadata['version'])
        if $v !~  $required_version {
          platform_assert::fail('softdep_unsupported', $source_module, "Soft dependency on ${dependency} is unsupported: ${required_version} (wanted for: ${reason})")
        }
      }
    }
  }
}
