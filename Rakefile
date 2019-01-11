require 'rugged'
require 'pty'

task default: %w[build]

task :build_all do
  result = `scripts/buildorder.py`
  array = result.split("\n")
  array.each do |pkg|
    puts "Building #{pkg}"
    begin
      # Start blocking build loop
      PTY.spawn("./scripts/run-docker.sh ./build-package.sh -i -a aarch64 #{pkg} && docker kill termux-package-builder && docker system prune -f") do |stdout, stdin, pid|
        begin
          stdout.sync
          stdout.each { |line| print line }
        rescue Errno::EIO => e
          puts e
        ensure
          ::Process.wait pid
        end
      end
    rescue PTY::ChildExited => e
      puts e
      puts "Process exited"
    end
    # Exit if PTY return a non-zero code
    if $?.exitstatus != 0
      STDERR.puts("Error building #{pkg}")
      exit($?.exitstatus)
    end
  end
end

task :build, [:options] do |t, args|
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
      PTY.spawn("./scripts/run-docker.sh ./build-package.sh #{args[:options]} #{pkg}") do |stdout, stdin, pid|
        begin
          stdout.sync
          stdout.each { |line| print line }
        rescue Errno::EIO => e
          puts e
        ensure
          ::Process.wait pid
        end
      end
    rescue PTY::ChildExited => e
      puts e
      puts "Process exited"
    end
    # Exit if PTY return a non-zero code
    if $?.exitstatus != 0
      STDERR.puts("Error building #{pkg}")
      exit($?.exitstatus)
    end
  end
end
