namespace :monitor do
  desc "Run an android monitor program"
  task :android do
    system "$ANDROID_HOME/tools/monitor"
  end
end
