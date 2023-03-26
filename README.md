# Learn InSpec

This is a repository for personal learning [InSpec](https://docs.chef.io/inspec/),
 an open-source framework for testing and auditing applications and infrastructure.

## Why learn InSpec?

It is a beautiful framework for implementing Security/Compliance as a Code, which I wanted to try out long time ago.

It has a beautiful [DSL](https://en.wikipedia.org/wiki/Domain-specific_language), which is human-readable.

It uses [Ruby](https://www.ruby-lang.org/en/), which I'm learning and it helps to explore interesting Ruby projects.

## Project setup

I'm running the project on Windows in Visual Studio code with Ubuntu 22.04 WSL.

1. Install rvm and ruby # TODO: add reference to learn-ruby
1. Create project gemset with rvm:
   ```shell
   rvm gemset create learn-inspec
   rvm gemset use learn-inspec
   ```
1. Install inspec using bundler (see https://github.com/inspec/inspec#install-it-via-rubygemsorg)
   ```shell
   bundler
   ```

## Inspec Concepts

- Profiles
- [Resources](https://docs.chef.io/inspec/resources/)
- [Matchers](https://docs.chef.io/inspec/matchers/)


## Check inspec installation

```
inspec detect
```

## Check blog configuration

* Make sure DNS names sergray.me and blog.sergray.me are resolvable and reachable by TCP on ports 80 and 443
* Ensure HTTP redirections from HTTP to HTTPS and from sergray.me to blog.sergray.me
* Check SSL configuration and verify SSL certificate

[Built-in inspec resources](https://docs.chef.io/inspec/resources/) do not have ability to verify SSL certificate on a remote host. 

There's however a [ssl-certificate-profile](https://supermarket.chef.io/tools/ssl-certificate-profile) on Chef Supermarket, implementing `ssl_certificate` resource.

It can be added as a dependency to `inspec.yml` file, which requires changing the structure of directories to conform to profile structure described at https://docs.chef.io/inspec/profiles/#inspecyml and checked with:

```shell
inspec check .
```

Profile dependencies should be vendored with:

```shell
inspec vendor
```

Which downloads dependencies to the `vendor` directory. It is ignored by git for now to make management of the project simpler, but in production vendored libraries may worth keeping under source control.

Then the tests can be executed with:

```shell
inspec exec .
```

## Gotchas

### `require': cannot load such file -- win32/process (LoadError)

When running `inspec detect` in VCS WSL such error popped up.
There's a [Github issue](https://github.com/inspec/inspec/issues/4310) discussing varios workarounds.
My personal preference is to create a file `/etc/wsl.conf` in WSL:

```
[interop]
enabled = false
appendWindowsPath = false
```

and run in powershell on the host as an admin:

```powershell
Restart-Service LxssManager
```
