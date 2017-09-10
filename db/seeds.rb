# All times are stored in UTC, GMT00, no time zone!
#  Change local time to GMT 0 for views and data comparison

# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#  or just use rake db:reset ...

puts '-- Begining seed.rb script'

require 'csv'

@datamodels = %w(Theater
                 Product) # commented out for Heroku's 10k datalimit
# "Cabinet",
# "Performance",
# "Distributed",
# "Available",

@datamodels.each_with_index do |m, _i|
  tempfile = Rails.root.join('db', m + '.csv')

  if File.exist?(tempfile)
    puts '-- loading ' + tempfile.to_s

    myfile = File.open(tempfile)
    # Heroku needs to use #{RAILS_ROOT}/tmp/myfile_#{Process.pid} for file uploads

    mycsv = CSV.parse(File.read(myfile), headers: :first_row)
    records = 0
    mycsv.each do |data|
      myrowhash = data.to_hash
      myrowhash.delete(nil)
      eval(m).create(myrowhash)
      records += 1
    end

    puts '   -> ' + records.to_s + ' records'
  else
    puts '-- Did not find file ' + tempfile.to_s
  end # file exist
end

# First user is the placeholder
#  The login is not intended for use, so here its set to creator/admin without admin privilages
puts '--  Adding users'
User.create!(name: 'TBD',
             email: 'foobar@gmail.com',
             password: '2014notforlogingin',
             password_confirmation: '2014notforlogingin',
             phone: '7186785933',
             phonetype: 'boost',
             schedule: true,
             admin: false)
User.create!(name: 'Ted DOttavio',
             email: 'teddottavio@yahoo.com',
             password: 'foobar',
             password_confirmation: 'foobar',
             phone: '7186785933',
             phonetype: 'boost',
             schedule: true,
             admin: true)

# Language
# 0 Mix Board
# 1 iCaption
# 2 Description
# 3 Chinese
# 4 French
# 5 German
# 6 Japanese
# 7 Portugese
# 8 Spanish
# 9 Turkish
