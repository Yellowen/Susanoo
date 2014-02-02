namespace :run do
  #require 'susanoo'
  [:android, :ios, "amazon-fireos", "ubuntu", "wp7", "wp8", "tizen"].each do |platform|
    desc "run application for #{platform} platform"
    task platform do
      Rake::Task["assets"].invoke
      system "cordova run #{platform}"
    end
  end
end
