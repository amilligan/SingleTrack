Pod::Spec.new do |s|
  s.name     = 'SingleTrack'
  s.version  = '0.1'
  s.license  = 'MIT'
  s.summary  = 'Helpers for testing asynchronous behavior with GCD queues'
  s.homepage = 'https://github.com/orchardadam/SingleTrack'
  s.social_media_url = 'https://www.orchardpie.com'
  s.authors  = { 'Adam Milligan' => 'adam@orchardpie.com' }
  s.source   = { git: 'https://github.com/orchardadam/SingleTrack', tag: "v0.1" }
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.default_subspec = 'Lib'

  s.subspec "Lib" do |sub|
    sub.public_header_files = 'SingleTrack/SingleTrack.h'
    sub.source_files = 'SingleTrack/SingleTrack.h', 'SingleTrack/Lib/*.{h,mm}'
  end

  s.subspec "SpecHelpers" do |sub|
    sub.dependency 'SingleTrack/Lib'
    sub.public_header_files = 'SingleTrack/SpecHelpers.h', 'SingleTrack/SpecHelpers/*.h'
    sub.source_files = 'SingleTrack/SpecHelpers.h', 'SingleTrack/SpecHelpers/*.{h,m,mm}'
  end
end

