namespace :compile do
  #require 'susanoo'
  [:android, :ios, "amazon-fireos", "ubuntu", "wp7", "wp8", "tizen"].each do |platform|
    desc "compile application for #{platform} platform"
    task platform do
      Rake::Task["assets"].invoke
      system "cordova compile #{platform}"
    end
  end
end
