cask 'santa' do
  version '0.9.9'
  sha256 '618f8d70715771de5651f0b2a57e98e20e8d272009fafbdc0968d9e022fae8d7'

  url "https://github.com/google/santa/releases/download/#{version}/santa-#{version}.dmg"
  name 'Santa'
  homepage 'https://github.com/google/santa/'
  license :apache

  pkg 'santa-0.9.9.pkg'

  uninstall launchctl: [
                        'com.google.santad',
                        'com.google.santagui',
                       ],   

            kext: 'com.google.santa-driver',
            pkgutil: 'com.google.santa.*'

                        
end
