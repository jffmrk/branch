#!/usr/bin/env ruby
##
## Bump the release version
##

VERSION_FILE = File.join(__dir__, "release.txt")

def read_version
  content = File.read(VERSION_FILE)
  match = content.match(/RELEASE_VERSION=(\d+)\.(\d+)\.(\d+)/)
  raise "Could not parse version from #{VERSION_FILE}" unless match

  {
    major: match[1].to_i,
    minor: match[2].to_i,
    patch: match[3].to_i
  }
end

def write_version(version)
  content = File.read(VERSION_FILE)
  new_version = "#{version[:major]}.#{version[:minor]}.#{version[:patch]}"
  updated = content.sub(/RELEASE_VERSION=\d+\.\d+\.\d+/, "RELEASE_VERSION=#{new_version}")
  File.write(VERSION_FILE, updated)
  new_version
end

def format_version(v)
  "#{v[:major]}.#{v[:minor]}.#{v[:patch]}"
end

version = read_version
puts "Current version: #{format_version(version)}"

choice = ARGV[0]&.downcase

unless choice
  puts
  puts "Which component would you like to increment?"
  puts "  [1] Major (#{version[:major] + 1}.0.0)"
  puts "  [2] Minor (#{version[:major]}.#{version[:minor] + 1}.0)"
  puts "  [3] Patch (#{version[:major]}.#{version[:minor]}.#{version[:patch] + 1})"
  puts "  [q] Quit"
  print "\nChoice: "

  choice = gets&.strip&.downcase
end

case choice
when "1", "major"
  version[:major] += 1
  version[:minor] = 0
  version[:patch] = 0
when "2", "minor"
  version[:minor] += 1
  version[:patch] = 0
when "3", "patch"
  version[:patch] += 1
when "q", "quit", nil
  puts "Aborted."
  exit 0
else
  puts "Invalid choice."
  puts ""
  puts "Usage: bump_version.rb [major|minor|patch|quit]"
  exit 1
end

new_version = write_version(version)
puts "Version updated to: #{new_version}"

