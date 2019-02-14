namespace :dev do
    desc "TODO"
    task setup: :environment do
      puts "Setando o ambiente"
  
      %x(rails db:drop db:create db:migrate)
  
      App.create!(
          app_name: "Guardiões da Saúde",
          owner_country: "Brazil"
      )
      puts "APP CRIADO"
  
      100.times do |i|
        User.create!(
            user_name: Faker::Name.name,
            email: Faker::Internet.email,
            password: "12345678",
            password_confirmation: "12345678",
            birthdate: Faker::Date.birthday(18, 65),
            country: Faker::Address.country,
            gender: Faker::Gender.type,
            race: "human",
            is_professional: false,
            app: App.all.first
        )
    end
    puts "USUARIOS CRIADOS"
  
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
    puts "HOUSEHOLDS CRIADOS"
     
  
    10.times do |j|
      Content.create!(
          title: Faker::Movies::LordOfTheRings.character,
          kind: Faker::Music.genre,
          body: Faker::Lorem.paragraph([1,2,3,4].sample, false, [1,2,3,4].sample),
          app: App.all.first
      )
    end
    
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
   puts "hora de criar o survey"
    Survey.create!(
        user: User.all.first,
        latitude: 40.741934119747704,
        longitude: -73.98951017150449,
        symptom: ["febre", "dor no corpo"]
    )
  
    end
  
  end
  