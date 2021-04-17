function platform_assert::supported(
  String $source_module,
) {
  platform_assert::os_supported($source_module)
  platform_assert::puppet_supported($source_module)
}
