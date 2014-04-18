platform :osx, '10.9'

pod 'SingleTrack', path: '.'

target 'AsyncApp' do
  platform :ios, 6.0
  pod 'SingleTrack', path: '.'
end

target 'Specs', exclusive: true do
  pod 'Cedar', git: 'https://github.com/orchardpie/cedar'
  pod 'SingleTrack/SpecHelpers', path: '.'
end

