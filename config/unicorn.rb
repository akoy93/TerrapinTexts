root = "/home/rails/apps/texts4terps/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.texts4terps.sock"
worker_processes 2
timeout 30
