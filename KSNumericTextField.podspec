Pod::Spec.new do |s|
  s.name             = 'KSNumericTextField'
  s.version          = '1.0.0'
  s.summary          = 'text field that only accept numeric value.'

  s.description      = 'KSNumericTextField is a simple to use text field that only accept numeric value. You can also specify the maximum number of integer digits and faction digits using storyboard or code.'

  s.homepage         = 'https://github.com/LeeKahSeng/KSNumericTextField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lee Kah Seng' => 'kahseng.lee123@gmail.com' }
  s.source           = { 
    :git => 'https://github.com/LeeKahSeng/KSNumericTextField.git', 
    :tag => s.version.to_s,
    :branch => 'master'
  }

  s.swift_version = '4.2'
  s.ios.deployment_target = '11.2'
  s.source_files = 'KSNumericTextField/KSNumericTextField/Sources/*.swift'

end