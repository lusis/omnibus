#
# Cookbook Name:: omnibus
# Recipe:: ruby
#
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when "windows"

  include_recipe "omnibus::ruby_windows"

when "smartos"

  pkgin_package "ruby193"

  gem_package "bundler" do
    version "1.3.5"
    gem_binary "/opt/local/bin/gem"
    options "--bindir=/opt/local/bin"
  end

else

  # fix yaml and ensure ruby1.9 builds with openssl gem
  case node['platform_family']
  when 'debian'
    package "libtool"
    package "libyaml-dev"
    package "libssl-dev"
  when 'rhel'
    package "libtool"
    package "libyaml-devel"
    package "openssl-devel"
  end

  chef_gem "bundler" do
    version "1.3.5"
  end

  %w{ bundle fpm gem omnibus rake ruby }.each do |bin|

    link "/usr/local/bin/#{bin}" do
      to "/opt/chef/embedded/bin/#{bin}"
    end

  end
end
