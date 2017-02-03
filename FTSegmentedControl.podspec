Pod::Spec.new do |s|
  s.name             = 'FTSegmentedControl'
  s.version          = '0.1.1'
  s.summary          = 'Customizable Segmented control'

  s.description      = <<-DESC
Flexible and customizable Segmented control view
                       DESC
  s.homepage         = 'https://github.com/ftp27/FTSegmentedControl'
 # s.screenshots      = 'https://github.com/ftp27/FTSegmentedControl/raw/master/FTSegmentedControl.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aleksey Cherepanov' => 'ftp27host@gmail.com' }
  s.source           = { :git => 'https://github.com/ftp27/FTSegmentedControl.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ftp27host'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FTSegmentedControl/Classes/**/*'
end
