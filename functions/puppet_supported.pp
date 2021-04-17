function platform_assert::puppet_supported(
  String $source_module,
) {
  require platform_assert
  if !member($platform_assert::modules_with_broken_metadata, $source_module) {
    $metadata = load_module_metadata($source_module)
    $requirements = pick($metadata['requirements'], [])

    $puppet_reqs = $requirements.filter |$r| { $r['name'] == 'puppet' }

    if empty($puppet_reqs) {
      platform_assert::fail('puppet_undeclared', $source_module, 'Puppet requirements undeclared')
    }

    $range = SemVerRange($puppet_reqs[0]['version_requirement'])

    if SemVer($facts['puppetversion']) !~ $range {
      platform_assert::fail('puppet_unsupported', $source_module, "Puppet version ${puppetversion} is unsupported, wanted: ${range}")
    }
  }
}
