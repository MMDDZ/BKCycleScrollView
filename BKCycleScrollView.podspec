Pod::Spec.new do |s|

s.name                  = 'BKCycleScrollView'
s.version               = '2.0.4'
s.summary               = '无限滚动视图'
s.homepage              = 'https://github.com/MMDDZ/BKCycleScrollView'
s.license               = { :type => 'MIT', :file => 'LICENSE' }
s.author                = { 'MMDDZ' => '694092596@qq.com' }
s.source                = { :git => 'https://github.com/MMDDZ/BKCycleScrollView.git', :tag => s.version.to_s }
s.ios.deployment_target = '8.0'
s.requires_arc          = true
s.source_files          = 'BKCycleScrollView/Classes/*.{h,m}'
s.resources             = "BKCycleScrollView/Assets/BKCycleScrollView.bundle"
s.framework             = "UIKit"
s.dependency 'BKTimer', '>= 1.0.0'
s.dependency 'SDWebImage', '>= 5.0.0'

end
