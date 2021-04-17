# @summary configures the behaviour of platform assertions
# @param undeclared
#   Default action when a module does not declare requirements
# @param unsupported
#   Default action when available versions are not within the asserted version range
# @param broken
#   Default action when a module declares a version to be broken
# @param os_undeclared
#   Action when OS the module does not declare OS support in module metadata
# @param os_unsupported
#   Action when the OS major release is not among supported versions in module metadata.
#   Note that when a module declares an OS as supported but omits version information, all versions will be
#   considered supported.
# @param puppet_undeclared
#   Action when module metadata does not declare Puppet version requirements.
# @param puppet_unsupported
#   Action when the Puppet version is not within the version range defined in metadata
# @param softdep_missing
#   Action when a soft dependency is missing
# @param softdep_unsupported
#   Action when a soft dependecy exists, but its versions is not within the asserted range
# @param modules_with_broken_metadata
#   If a source name is found in this array, checks that attempt to read metadata will be disabled
# @param per_source_actions
#   Allows overriding actions per source
#   It is a Hash of source names to a hash of Platform_assert::Failure => Platform_assert::Action
#   Source names *should* correspond to module names, but this can't be enforced
# @note Modules making use of platform assertions must never directly instantiate this class, as it is intended for the user to configure. Modules must use the function API instead.
class platform_assert(
  # Actions
  Platform_assert::Action $undeclared                    = 'fail',
  Platform_assert::Action $unsupported                   = 'fail',
  Platform_assert::Action $broken                        = 'fail',
  Optional[Platform_assert::Action] $os_undeclared       = undef,
  Optional[Platform_assert::Action] $os_unsupported      = undef,
  Optional[Platform_assert::Action] $puppet_undeclared   = undef,
  Optional[Platform_assert::Action] $puppet_unsupported  = undef,
  Optional[Platform_assert::Action] $softdep_missing     = undef,
  Optional[Platform_assert::Action] $softdep_unsupported = undef,

  # Control general behaviour
  # Sometimes, metadata in a dependency is broken
  Array[String] $modules_with_broken_metadata            = [],
  Hash[String, Hash[Platform_assert::Failure, Platform_assert::Action]] $per_source_actions = {}
) {
  if versioncmp($facts['puppetversion'], '4.5.0') < 0 {
    fail("platform_assert can't be used with Puppet older than 4.5.0: SemVer types are missing.")
  }

  $actions = {
    'os_undeclared'       => pick($os_undeclared, $undeclared),
    'os_unsupported'      => pick($os_unsupported, $unsupported),

    'puppet_undeclared'   => pick($puppet_undeclared, $undeclared),
    'puppet_unsupported'  => pick($puppet_unsupported, $unsupported),   

    'softdep_unsupported' => pick($softdep_unsupported, $unsupported),
    'softdep_missing'     => pick($softdep_missing, $broken),

    'broken'              => $broken,
  }
}
