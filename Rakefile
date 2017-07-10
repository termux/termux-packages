require 'rugged'
require 'pty'

task default: %w[build]

task :build do
  repo = Rugged::Repository.new('.')
  commit = repo.head.target
  parent = commit.parents.first
  pkgs = commit.diff(parent).deltas.map { |d| d.new_file[:path] }
  # Split paths into arrays
  pkgs.map! { |p| Pathname.new(p).each_filename.to_a }
  # looking for [disabled-]packages/(package_name)/...
  pkgs.select! { |p| p.length > 2 and p[0] =~ /(?<disabled->)packages/ }
  # Get package_name
  pkgs.map! { |p| p[1] }
  # Remove duplicate packages
  pkgs.uniq!
  pkgs.each do |pkg|
    puts "Building #{pkg}"
    begin
      # Start blocking build loop
      PTY.spawn("./scripts/run-docker.sh ./build-package.sh #{pkg}") do |stdout, stdin, pid|
        begin
          stdout.each { |line| print line }
        rescue Errno::EIO
        end
      end
    rescue PTY::ChildExited
      puts "Process exited"
    end
    # Exit if PTY return a non-zero code
    if $?.exitstatus != 0
      STDERR.puts("Error building #{pkg}")
      exit($?.exitstatus)
    end
  end
end
