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

# First user is the placeholder for unassigned representatives
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
User.create!(name: 'SA Staff',
             email: 'infrared@soundassociates.com',
             password: 'distribution',
             password_confirmation: 'distribution',
             phone: '7186785933',
             phonetype: 'boost',
             schedule: false,
             admin: true)
# why did this work with 'distributeds?'
User.create!(name: 'Joe The Test Account',
             email: 'joe@gmail.com',
             password: 'sa-joe',
             password_confirmation: 'sa-joe',
             phone: '7186785933',
             phonetype: 'boost',
             schedule: true,
             admin: false)
User.create!(name: 'Anne Tramon',
             email: 'annetramon@prodigy.net',
             password: 'distribution',
             password_confirmation: 'distribution',
             phone: '9147602063',
             phonetype: 'at&t',
             schedule: false,
             admin: true)
User.create!(name: 'Carl Anthony Tramon',
             email: 'carlanthonytramon7@prodigy.net',
             password: 'foobar',
             password_confirmation: 'foobar',
             phone: '7737936585',
             phonetype: 'at&t',
             schedule: false,
             admin: true)
User.create!(name: 'Wambui',
             email: 'wambui@wambui.com',
             password: 'sa-wambui',
             password_confirmation: 'sa-wambui',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Adam Shonkwiler',
             email: 'adamshonkwiler@gmail.com',
             password: 'sa-adamshonkwiler',
             password_confirmation: 'sa-adamshonkwiler',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Anna Lively',
             email: 'anna@annalively.com',
             password: 'sa-anna',
             password_confirmation: 'sa-anna',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Anthony Raus',
             email: 'anthonyraus@gmail.com',
             password: 'sa-anthonyraus',
             password_confirmation: 'sa-anthonyraus',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Anya Aliferis',
             email: 'anya.aliferis@gmail.com',
             password: 'sa-anya.aliferis',
             password_confirmation: 'sa-anya.aliferis',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Ashley Griffin',
             email: 'faeriebleue@aol.com',
             password: 'sa-faeriebleue',
             password_confirmation: 'sa-faeriebleue',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Beth Anne Sacks',
             email: 'bethannesacks@gmail.com',
             password: 'sa-bethannesacks',
             password_confirmation: 'sa-bethannesacks',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Beth Naji',
             email: 'bnajishow@aol.com',
             password: 'sa-bnajishow',
             password_confirmation: 'sa-bnajishow',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Bobby Matteau',
             email: 'bobby.matteau@gmail.com',
             password: 'sa-bobby.matteau',
             password_confirmation: 'sa-bobby.matteau',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'C K Browne',
             email: 'ckendallbrowne@gmail.com',
             password: 'sa-ckendallbrowne',
             password_confirmation: 'sa-ckendallbrowne',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Camron Gran',
             email: 'camrongran@hotmail.com',
             password: 'sa-camrongran',
             password_confirmation: 'sa-camrongran',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Carla Cherry',
             email: 'carlaremy@gmail.com',
             password: 'sa-carlaremy',
             password_confirmation: 'sa-carlaremy',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Cathleen Wright',
             email: 'cathleen@cathleenwright.com',
             password: 'sa-cathleen',
             password_confirmation: 'sa-cathleen',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Cindy',
             email: 'cinshee@aol.com',
             password: 'sa-cinshee',
             password_confirmation: 'sa-cinshee',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Cynthia Ladopoulos',
             email: 'nycindytours@gmail.com',
             password: 'sa-nycindytours',
             password_confirmation: 'sa-nycindytours',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'D. Levy',
             email: 'levdm5@gmail.com',
             password: 'sa-levdm5',
             password_confirmation: 'sa-levdm5',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Dakota DeFelice',
             email: 'dakotadefelice@gmail.com',
             password: 'sa-dakotadefelice',
             password_confirmation: 'sa-dakotadefelice',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Dani Marcus',
             email: 'danimarcus2002@yahoo.com',
             password: 'sa-danimarcus2002',
             password_confirmation: 'sa-danimarcus2002',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'David Kellner',
             email: 'david_kellner7@hotmail.com',
             password: 'sa-david_kellner7',
             password_confirmation: 'sa-david_kellner7',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Denise Bourcier',
             email: 'dabourcier@gmail.com',
             password: 'sa-dabourcier',
             password_confirmation: 'sa-dabourcier',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Devin Vogel',
             email: 'devin.i.vogel@gmail.com',
             password: 'sa-devin.i.vogel',
             password_confirmation: 'sa-devin.i.vogel',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Edward Batchelor',
             email: 'ebatchelor72@gmail.com',
             password: 'sa-ebatchelor72',
             password_confirmation: 'sa-ebatchelor72',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Eileen F. Dougherty',
             email: 'efdoughert@aol.com',
             password: 'sa-efdoughert',
             password_confirmation: 'sa-efdoughert',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Emily Adamo',
             email: 'emilyeadamo@gmail.com',
             password: 'sa-emilyeadamo',
             password_confirmation: 'sa-emilyeadamo',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Emily Rhein',
             email: 'emily.rhein@gmail.com',
             password: 'sa-emily.rhein',
             password_confirmation: 'sa-emily.rhein',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Erika Jenko',
             email: 'onceuponareality@gmail.com',
             password: 'sa-onceuponareality',
             password_confirmation: 'sa-onceuponareality',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Gigi Soriano',
             email: 'gigisoriano811@gmail.com',
             password: 'sa-gigisoriano811',
             password_confirmation: 'sa-gigisoriano811',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Gregory Bertolini',
             email: 'gregbertolini@yahoo.com',
             password: 'sa-gregbertolini',
             password_confirmation: 'sa-gregbertolini',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Jacqueline Keeley',
             email: 'jackiekeeley@gmail.com',
             password: 'sa-jackiekeeley',
             password_confirmation: 'sa-jackiekeeley',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Jane Moore',
             email: 'jmoore1@gm.slc.edu',
             password: 'sa-jmoore1',
             password_confirmation: 'sa-jmoore1',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Jane Van Gelder',
             email: 'janevangelder@yahoo.com',
             password: 'sa-janevangelder',
             password_confirmation: 'sa-janevangelder',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Jelissa Mercado',
             email: 'jelissam21@gmail.com',
             password: 'sa-jelissam21',
             password_confirmation: 'sa-jelissam21',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Jennifer Cooper',
             email: 'jenlizcooper@gmail.com',
             password: 'sa-jenlizcooper',
             password_confirmation: 'sa-jenlizcooper',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Jennifer Menter',
             email: 'jennifer.menter@gmail.com',
             password: 'sa-jennifer.menter',
             password_confirmation: 'sa-jennifer.menter',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Julien Braun',
             email: 'julienbraun@icloud.com',
             password: 'sa-julienbraun',
             password_confirmation: 'sa-julienbraun',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Kelsey Matta',
             email: 'kelseymatta@gmail.com',
             password: 'sa-kelseymatta',
             password_confirmation: 'sa-kelseymatta',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Kingsley Leggs',
             email: 'kingsleyleggs@gmail.com',
             password: 'sa-kingsleyleggs',
             password_confirmation: 'sa-kingsleyleggs',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Kristy Lee',
             email: 'kristylee118@aol.com',
             password: 'sa-kristylee118',
             password_confirmation: 'sa-kristylee118',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Krystal Sobaskie',
             email: 'krystal.sobaskie@gmail.com',
             password: 'sa-krystal.sobaskie',
             password_confirmation: 'sa-krystal.sobaskie',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Kurt Perry',
             email: 'kurt.perry41@gmail.com',
             password: 'sa-kurt.perry41',
             password_confirmation: 'sa-kurt.perry41',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Larissa Laurel',
             email: 'larissalaurel@gmail.com',
             password: 'sa-larissalaurel',
             password_confirmation: 'sa-larissalaurel',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Lotte de Roy',
             email: 'lottederoy@hotmail.com',
             password: 'sa-lottederoy',
             password_confirmation: 'sa-lottederoy',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Melvin Abston',
             email: 'melvin.abston@gmail.com',
             password: 'sa-melvin.abston',
             password_confirmation: 'sa-melvin.abston',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Nancy Swiezy',
             email: 'nancyswiezyevents@gmail.com',
             password: 'sa-nancyswiezyevents',
             password_confirmation: 'sa-nancyswiezyevents',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Nikki Stephenson',
             email: 'nikkistephenson12@gmail.com',
             password: 'sa-nikkistephenson12',
             password_confirmation: 'sa-nikkistephenson12',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Patricia Einstein',
             email: 'yespatriciaeinstein@yahoo.com',
             password: 'sa-yespatriciaeinstein',
             password_confirmation: 'sa-yespatriciaeinstein',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Paul Bolter',
             email: 'pbolter1@gmail.com',
             password: 'sa-pbolter1',
             password_confirmation: 'sa-pbolter1',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Peter Gulczewski',
             email: 'pgulczewski@gmail.com',
             password: 'sa-pgulczewski',
             password_confirmation: 'sa-pgulczewski',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Rachel Leighson',
             email: 'rsmithweinstein@gmail.com',
             password: 'sa-rsmithweinstein',
             password_confirmation: 'sa-rsmithweinstein',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Rita Rehn',
             email: 'ritarehn@aol.com',
             password: 'sa-ritarehn',
             password_confirmation: 'sa-ritarehn',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Robert Matteau',
             email: 'bobby.matteau@icloud.com',
             password: 'sa-bobby.matteau',
             password_confirmation: 'sa-bobby.matteau',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Saundra Addison',
             email: 'saundra_addison@yahoo.com',
             password: 'sa-saundra_addison',
             password_confirmation: 'sa-saundra_addison',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Standley McCray',
             email: 'standley.mccray@gmail.com',
             password: 'sa-standley.mccray',
             password_confirmation: 'sa-standley.mccray',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Star Soriano',
             email: 'starsoriano@gmail.com',
             password: 'sa-starsoriano',
             password_confirmation: 'sa-starsoriano',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Stephanie Serfecz',
             email: 'stephanieserfecz@gmail.com',
             password: 'sa-stephanieserfecz',
             password_confirmation: 'sa-stephanieserfecz',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Triston John',
             email: 'trisjohn@gmail.com',
             password: 'sa-trisjohn',
             password_confirmation: 'sa-trisjohn',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Vanessa Dawson',
             email: 'vanessagdawson@gmail.com',
             password: 'sa-vanessagdawson',
             password_confirmation: 'sa-vanessagdawson',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Hy Chait',
             email: 'hychait@nomail.com',
             password: 'sa-hychait',
             password_confirmation: 'sa-hychait',
             phone: '',
             phonetype: '',
             schedule: true,
             admin: false)
User.create!(name: 'Kaz',
             email: 'teddottavio@yahoo.com',
             password: 'sa-kaz',
             password_confirmation: 'sa-kaz',
             phone: '',
             phonetype: '',
             schedule: false,
             admin: false)
User.create!(name: 'Yoav Levin',
             email: 'teddottavio@yahoo.com',
             password: 'sa-yoav',
             password_confirmation: 'sa-yoav',
             phone: '',
             phonetype: '',
             schedule: false,
             admin: false)

# use FactoryGirl to make a few more users
# (0..20).each do |u|
# fakename = Faker::Name.name
# fakeemail = fakename + u + "@gmail.com"
#  User.create!(name: Faker::Name.name,
#                 email: Faker::Internet.email,
#                 password: "foobar",
#                 password_confirmation: "foobar",
#                 phone: Faker::PhoneNumber.phone_number,
#                 phonetype: "",
#                 schedule: true,
#                 admin: false)
# end
# JUST IN CASE
# Factory girl might mess up heroku deployment:
#  http://stackoverflow.com/questions/12423273/factorygirl-screws-up-rake-dbmigrate-process

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
