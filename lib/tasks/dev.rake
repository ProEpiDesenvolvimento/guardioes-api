namespace :dev do
  desc "TODO"
  task setup: :environment do
    puts "Configuring Development environment"

    show_spinner("Dropping db...") do 
      %x(rails db:drop)
    end
    
    show_spinner("Creating db...") do 
      %x(rails db:create)
    end
    
    show_spinner("Migrating db...") do 
      %x(rails db:migrate)
    end

    show_spinner("Creating App 'Guardiões da Saúde'...") do
      App.create!(
          app_name: "Guardiões da Saúde",
          owner_country: "Brazil"
      )
    end

    show_spinner("Creating 100 example users...") do
      100.times do |i|
        User.create!(
            user_name: Faker::Name.name,
            email: Faker::Internet.email,
            password: "12345678",
            birthdate: Faker::Date.birthday(18, 65),
            country: Faker::Address.country,
            gender: Faker::Gender.type,
            race: "human",
            is_professional: false,
            app: App.all.first
        )
    end
    end

    show_spinner("Inserting Kinships on created users...") do
      kinships = %w(Pai, Mãe, Filho, Conjuge)
    
      User.all.each do |user|
          3.times do
              household = Household.create!(
                  description: Faker::Name.name,
                  birthdate: Faker::Date.birthday(18, 65),
                  country: Faker::Address.country,
                  gender: ["male", "female"].sample,
                  race: "human",
                  kinship: kinships.sample
              )
              user.households << household
              user.save!
          end
      end
    end
   

    show_spinner("Creating 10 example content...") do
      10.times do |j|
        Content.create!(
            title: Faker::Movies::LordOfTheRings.character,
            content_type: Faker::Music.genre,
            body: Faker::Lorem.paragraph([1,2,3,4].sample, false, [1,2,3,4].sample),
            app: App.all.first
        )
      end
    end
  
    show_spinner("Creating 50 example Public Hospitals...") do
      50.times do |k|
        PublicHospital.create!(
            description:Faker::Company.name,
            latitude: Faker::Address.latitude ,
            longitude: Faker::Address.longitude,
            kind: Faker::Movies::StarWars.character,
            phone: Faker::PhoneNumber.phone_number,
            details: Faker::Lorem.paragraph([1,2].sample, false, [1,2].sample),
            app: App.all.first 
        )


      end
    end


    show_spinner("Creating survey...") do
        Survey.create!(
            user: User.all.first,
            latitude: 40.741934119747704,
            longitude: -73.98951017150449,
            symptom: ["febre", "dor no corpo"]
        )
    end
  end

  def show_spinner(start_msg, end_msg = "done")
    pastel = Pastel.new

    format = "[#{pastel.yellow(':spinner')}] " + pastel.yellow("#{start_msg}")
    
    spinner = TTY::Spinner.new(format, success_mark: pastel.green('+'))
    spinner.auto_spin
    
    yield
    spinner.success(pastel.green("#{end_msg}"))
  end
end