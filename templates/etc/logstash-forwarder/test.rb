#!/usr/bin/ruby
require 'json'
require 'yaml'

value = {
  "network": {
  "servers": [ "<%= server %>:<%= port %>" ],
    "timeout": 15,
    "ssl ca": "/etc/pki/tls/certs/logstash-forwarder.crt"
  },
  "files": [
    {
      "paths": [
        "/var/log/messages",
        "/var/log/secure"
       ],
      "fields": { "type": "syslog" }
    },
    {
      "paths": [
        "/var/log/httpd/access_log"
      ],
      "fields": { "type": "apache-access" }
    },
    {
      "paths": [
        "/var/log/httpd/error_log"
      ],
      "fields": { "type": "apache-error" }
    },
    {
      "paths": [
        "/var/log/haproxy.log"
      ],
      "fields": { "type": "haproxy-access" }
    },
    {
      "paths": [
        "/var/log/nginx/access.log",
        "/var/log/nginx/*-access.log",
        "/var/log/nginx/*.access.log",
        "/var/log/nginx/*.ssl_access.log",                                                                                                                                      
        "/var/log/nginx/*-upstream.log"                                                                                                                                         
      ],
      "fields": { "type": "nginx-access" }
    },
    {
      "paths": [
        "/var/log/nginx/error.log"
      ],
      "fields": { "type": "nginx-error" }
    },
    {
      "paths": [
        "/var/log/nginx/*-cache.log"
      ],
      "fields": { "type": "nginx-cache" }
    },
    {
      "paths": [
        "/var/log/maillog"
      ],
      "fields": { "type": "postfix" }
    },
    {
      "paths": [
        "/var/log/sanlock.log"
      ],
      "fields": { "type": "sanlock" }
    },
    {
      "paths": [
        "/var/log/yum.log"
      ],
      "fields": { "type": "yum" }
    }
  ]
}

puts JSON.parse(value.to_json).to_yaml

