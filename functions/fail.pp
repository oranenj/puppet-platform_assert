# @api internal
function platform_assert::fail(
  Platform_assert::Failure $failure,
  String $source,
  String $reason,
) {
  require platform_assert

  $msg = "Platform assertion failure from ${source}: ${reason}"

  $source_overrides = pick($platform_assert::per_source_actions[$source], {})
  $action = pick($source_overrides[$failure], $platform_assert::actions[$failure])

  case $action {
    'fail':   { fail($msg) }
    'warn':   { warning($msg) }
    'notify': { notify { $msg: } }
    'ignore': { }
    default:  { fail("Bug in platform_assert module, invalid action: '${action}'!") }
  }
}
