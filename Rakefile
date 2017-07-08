require 'rugged'

task default: %w[build]

task :build do
  repo = Rugged::Repository.new('.')
  commit = repo.head.target
  parent = commit.parents.first
  paths = commit.diff(parent).deltas.map { |d| d.new_file[:path] }
  paths = paths.map { |p| Pathname.new(p).each_filename.to_a }
  # looking for packages/[package]/...
  packages = paths.map { |p| p[1] if p.length > 2 and p[0] == "packages" }
  packages = packages.flatten.uniq
  packages.each do |package|
    p `./scripts/run-docker.sh ./build-package.sh #{package}`
  end
end
