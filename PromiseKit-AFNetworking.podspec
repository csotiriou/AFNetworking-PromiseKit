Pod::Spec.new do |s|

  s.name     = 'PromiseKit-AFNetworking'
  s.version  = '0.1.6' 
  s.summary  = 'PromiseKit extensions for AFNetworking'
  s.license  =  'MIT'
  s.homepage = 'https://github.com/csotiriou/AFNetworking-PromiseKit/'
  s.source = { :git => 'https://github.com/csotiriou/AFNetworking-PromiseKit.git', :tag => s.version }
  
  s.author   = { 'Christos Sotiriou' => 'csotiriou86@gmail.com' }  
  
  s.public_header_files = 'PromiseKit+AFNetworking/AFNetworking+PromiseKit.h'
  s.source_files = 'PromiseKit+AFNetworking/AFNetworking+PromiseKit.{h,m}'
  s.requires_arc  = true
  
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  
  s.dependency 'AFNetworking', '~> 2.0'
  s.dependency 'PromiseKit/Promise'
  s.dependency 'PromiseKit/When'
    
end
