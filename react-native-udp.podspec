require 'json'
package_json = JSON.parse(File.read('package.json'))

Pod::Spec.new do |s|

  s.name           = package_json["name"]
  s.version        = package_json["version"]
  s.summary        = package_json["description"]
  s.homepage       = package_json["homepage"]
  s.license        = package_json["license"]
  s.author         = { package_json["author"] => package_json["author"] }
  s.platform       = :ios, "9.0"
  s.source         = { :git => package_json["repository"]["url"], :tag => "v#{s.version}" }
  s.source_files   = 'ios/**/*.{h,m,mm}'
  s.dependency 'CocoaAsyncSocket'

  # New Architecture / TurboModule support.
  #
  # On RN 0.71+ `install_modules_dependencies` is the canonical helper: it wires
  # up React-Core, the new-arch turbomodule dependencies, and codegen (driven by
  # the `codegenConfig` block in package.json) in a version-robust way. The old
  # `use_react_native_codegen!` helper used here previously was removed in newer
  # React Native and breaks `pod install` on RN 0.81 / Expo 54
  # ("undefined method 'use_react_native_codegen!'").
  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
    # Fallback for pre-0.71 React Native.
    s.dependency 'React-Core'
    if ENV['RCT_NEW_ARCH_ENABLED'] == '1' then
      s.dependency 'ReactCommon/turbomodule/core'
    end
  end
end
