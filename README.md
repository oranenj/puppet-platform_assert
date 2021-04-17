# platform_assert

This module contains functions that allow other modules to assert platform
support constraints without having to signal deprecations and removals
by incrementing the module's major version.

Since the module does not actually *do* anything when applied, it should work
on any operating system.

## Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Often, Puppet modules will want to remove support for EOL operating systems and
Puppet versions. This rarely actually means the code suddenly stops working or
that the API changes, but usually necessitates a major release so that people
will notice the deprecation.

The purpose of this module is to provide a means to signal to users that they're
using an unsupported platforms, and a way for users to signal to the module that it
should run anyway.

## Usage in modules

Module authors should use the functions included in this module. They must *never*
instantiate the main class.

The simplest usage in a module is to simply do:
```
  platform_assert::supported($module_name)
```
in a module's `init.pp`

## Usage by module users
Users of modules making use of platform assertions may use the main class to control what 
happens when an assertion fails, for example, to downgrade an error to a warning, or to 
suppress all warnings entirely.
The preferred way is to use automatic parameter lookup via hiera:

```
platform_assert::undeclared: 'fail'
platform_assert::per_source_override:
  mymodule:
    os_undeclared: ignore
```

## Limitations

Due to the way this module works, other modules must never directly instantiate the
main class as a resource, as doing so would prevent users from overriding its behaviour
in their node-specific profiles.

This module should work with Puppet 4.5.0 and newer, but only supported Puppet versions
will be tested.

## Development

After 1.0, this module shall never break its API.
