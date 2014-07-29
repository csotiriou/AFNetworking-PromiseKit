Pod::Spec.new do |s|

  s.name     = 'PromiseKit-AFNetworking'
  s.version  = '0.0.1' 
  s.summary  = 'PromiseKit extensions for AFNetworking'
  s.license  =  'MIT'
  s.source = { :git => 'https://github.com/csotiriou/PromiseKit-AFNetworking.git', :tag => s.version }
  
  s.author   = { 'Christos Sotiriou' => '' }  

  s.public_header_files = 'PromiseKit+AFNetworking/AFNetworking+Promises.h'
  s.source_files = 'PromiseKit+AFNetworking/AFNetworking+Promises.{h,m}'
  s.requires_arc  = true
  
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
  
  s.dependency 'AFNetworking', '~>2.0.0'
  s.dependency 'PromiseKit', '~> 0.9.13'
    
end
