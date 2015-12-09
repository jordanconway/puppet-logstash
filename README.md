# logstash

[![Build Status](https://travis-ci.org/jordanconway/puppet-logstash.png)](https://travis-ci.org/jordanconway/puppet-logstash)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with logstash](#setup)
    * [What logstash affects](#what-logstash-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with logstash](#beginning-with-logstash)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module will install and configure logstash (currently only forwarder) for
Redhat and CentOS 6.x and 7.x.
It is best managed with Puppet 3+ and hiera but should work without hiera.
OS/Puppet version it works with.

## Module Description

Currently installs and configures logstash-forwarder (eventually 
logstash-server maybe). Use in conjunction with an already configured
logstash server, or another module that provides logstash-server setup
but nothing for logstash-forwarder.

## Setup

### What logstash affects

* logstash rpm package (all)
* logstash-forwarder service (all)
* /etc/logstash-forwarder/logstash-forwarder.conf (ALL)
* /etc/sysconfig/logstash-forwarder (EL6)
* /etc/init.d/logstash-forwarder (EL6)
* /usr/lib/systemd/system/logstash-forwarder.service (EL7)

### Setup Requirements

You should already be running a logstash server, this module does not yet cover that.
I found that there were plenty of modules to setup logstash server, but very few to none
that covered logstash-forwarder so that's where I started with this one. Eventually I may
expand it to cover logstash-server.

### Beginning with logstash

Minimum required setup: For now I am only describing logstash::forwarder

Enable logstash::forwarder for the nodes you will be shipping logs from
This will either be done in roles/profiles or your ENC.

Variables to set: The variables that you should be setting depend on if you're using hiera or not.

####Without Hiera:

* $package
  _String_ - Defaults to 'https://download.elastic.co/logstash-forwarder/binaries/logstash-forwarder-0.4.0-1.x86_64.rpm'
  Check on the ElasticSearch site for the required package version for your instalation.
* $servers
  _Array_ - Defaults to ["logstash.${::domain}:${port}"]
  Assuming your logstash server is named logstash and in the same domain as the rest of the machine you're setting up.
* $port
  _Int_ - Defaults to 5000
  This is the listening port for your above logstash server(s).
* $timeout
  _Int_ - Defaults to 15
  This is the number of seconds logstash-forwarder waits to timeout trying to reach the server.
* $use_ssl
  _Bool_ - Defaults to false
  Set to true if you're going to use ssl
* $ssl_ca
  _String_ - Defaults to '/etc/pki/tls/certs/logstash-forwarder.crt'
  The CA used to authenticate your downstream server - ignored if $use_ssl is false
* $paths
  _Hash_ - Defaults to
```
{ 'paths' => ['/var/log/messages', '/var/log/secure'],
            'fields' => {
              'type' => 'syslog'
            }
}
```
  This is the meat and potatoes of your logstash-forwarder setup. You'll want to add a new hash
  stanza to it for each of the sets of files you're doing, it can take all of the normal
  logstash-forwarder fields/types etc depending on what you're doing with the files, just
  stick a new 'paths' stanza into the hash for each extra set of logs, like this:
```
{ 'paths' => ['/var/log/messages', '/var/log/secure'],
            'fields' => {
              'type' => 'syslog'
            },
  'paths' => ['/var/log/mail'],
            'fields' => {
              'type' => 'postfix'
            }
}
```

####With Hiera:
I think the setup with Hiera is much easier, there are two separate entries logstash::package
as above and logstash::config which is into one hash pulled from hiera. 
Here is an example of something you can throw into common.yaml
It is fairly close to an actual logstash config file, but yaml rather than json.
You can more or less run a json -> yaml converter on a working logstash-forwarder config to
get these values and clean them up a little bit.
```
logstash::package: 'http://download.elasticsearch.org/logstash-forwarder/packages/logstash-forwarder-0.3.1-1.x86_64.rpm'
logstash::config:
  network:
    servers:
      - 'logstash.yourdomain.tld:5000'
    timeout: 15
    ssl_ca: '/etc/pki/tls/certs/logstash-forwarder.crt'
  files:
    - paths:
        - '/var/log/messages'
        - '/var/log/secure'
      fields:
        type: syslog
    - paths:
        - '/var/log/httpd/access_log'
      fields:
        type: apache-access
    - paths:
        - '/var/log/httpd/error_log'
      fields:
        type: apache-error
    - paths:
        - '/var/log/haproxy.log'
      fields:
        type: haproxy-access
    - paths:
        - '/var/log/nginx/access.log'
        - '/var/log/nginx/*-access.log'
        - '/var/log/nginx/*.access.log'
        - '/var/log/nginx/*.ssl_access.log'
      fields:
        type: nginx-access
    - paths:
        - '/var/log/nginx/error.log'
      fields:
        type: nginx-error
    - paths:
        - '/var/log/nginx/*-cache.log'
      fields:
        type: nginx-cache
    - paths:
        - '/var/log/maillog'
      fields:
        type: postfix
    - paths:
        - '/var/log/yum.log'
      fields:
        type: yum
```

## Usage

As above, set your variables and add the logstash::forwarder class to the requires nodes.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Only does logstash-forwarder at the moment. Manually tested on CentOS 7 with hiera,
Automatic rspec tests for RedHat/Centos 6/7 have increasing coverage.

## Development

Pull requests welcome!

