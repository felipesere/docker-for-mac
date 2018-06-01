#!/usr/bin/env ruby

require "tty-spinner"
require "timeout"

if ARGV.length != 1
  puts "Usage: docker-for-mac up|down|state"
  return
end

def launch_docker
  system("open --background -a Docker")
end

def quit_docker
  system("osascript -e 'quit app \"Docker\"\'")
end

def check_state
  system("docker system info > /dev/null 2>&1")
end

def wait_for_launch(time)
  begin
    Timeout::timeout(time) { launching() }
  rescue e
    puts "Took more than 60sec"
    puts "❌"
    exit 1
  end
end

def launching
  spinner = TTY::Spinner.new("[:spinner] 🐳 Launching...", format: :dots)
  spinner.auto_spin

  while !check_state 
    sleep 1
  end
  spinner.success
end


if ARGV.include?("up") || ARGV.include?("u")
  launch_docker()

  if !check_state()
    wait_for_launch(60)
  else
    puts
    puts "👍"
  end

end


if ARGV.include?("state") || ARGV.include?("status") || ARGV.include?("s")
  if check_state()
    puts "👍"
  else
    puts "❌"
  end
end

if ARGV.include?("down") || ARGV.include?("d")
  quit_docker()
end
