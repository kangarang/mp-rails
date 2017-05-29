# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u1 = User.create(
    first_name: 'Barack',
    last_name: 'Obama',
    songkick_username: "kangarang1",
    gender: 'Male',
    location: 'Brooklyn',
    seeking: 'Female',
    height: "5ft 11in",
    ethnicity: 'Black',
    eth_pref: 'East Asian',
    body_type: "Normal",
    profession: 'Ex-POTUS',
    photo_url: "https://i.imgur.com/qJIU3fU.jpg",
    uid: "barack",
    age: 55,
    age_pref_low: 18,
    age_pref_high: 200,
    also_friends: true,
    just_friends: false
)

u2 = User.create(
    first_name: 'Donald',
    last_name: 'Trump',
    songkick_username: "kangarang2",
    gender: 'Male',
    location: 'Brooklyn',
    seeking: 'Female',
    height: "5ft 9in",
    ethnicity: 'White',
    eth_pref: 'East Asian',
    body_type: "Big n Beautiful",
    profession: 'Troll',
    photo_url: "https://i.imgur.com/p98Oc8I.jpg",
    uid: "donny",
    age: 70,
    age_pref_low: 18,
    age_pref_high: 200,
    also_friends: true,
    just_friends: false
)

u3 = User.create(
    first_name: 'Bernie',
    last_name: 'Sanders',
    songkick_username: "kangarang3",
    gender: 'Male',
    location: 'Brooklyn',
    seeking: 'Female',
    height: "5ft 6in",
    ethnicity: 'White',
    eth_pref: 'East Asian',
    body_type: "Skinny",
    profession: 'Senator',
    photo_url: "https://i.imgur.com/K1CSDNf.jpg",
    uid: "bernie",
    age: 65,
    age_pref_low: 18,
    age_pref_high: 200,
    also_friends: true,
    just_friends: false
)

u4 = User.create(
    first_name: 'Hillary',
    last_name: 'Clinton',
    songkick_username: "ikangarang",
    gender: 'Female',
    location: 'Brooklyn',
    seeking: 'Male',
    height: "5ft 3in",
    ethnicity: 'White',
    eth_pref: 'East Asian',
    body_type: "Normal",
    profession: 'Politician',
    photo_url: "https://i.imgur.com/EbK4o3t.jpg",
    uid: "hillary",
    age: 29,
    age_pref_low: 18,
    age_pref_high: 200,
    also_friends: true,
    just_friends: false
)

u5 = User.create(
    first_name: 'Isaac',
    last_name: 'Kang',
    songkick_username: "isaacjkang",
    gender: 'Male',
    location: 'Brooklyn',
    seeking: 'Female',
    height: "5ft 10in",
    ethnicity: 'East Asian',
    eth_pref: 'Any',
    body_type: "Normal",
    profession: 'Software Developer',
    photo_url: "https://i.imgur.com/pPMHNxp.jpg",
    uid: "isaac",
    age: 27,
    age_pref_low: 20,
    age_pref_high: 200,
    also_friends: true,
    just_friends: false
)

u6 = User.create(
    first_name: 'Liz',
    last_name: 'Warren',
    songkick_username: "monka-lee",
    gender: 'Female',
    location: 'Brooklyn',
    seeking: 'Male',
    height: "5ft 9in",
    ethnicity: 'White',
    eth_pref: 'Any',
    body_type: "Normal",
    profession: 'Demo user',
    photo_url: "https://i.imgur.com/kKtCdZw.jpg",
    uid: "lizzy",
    age: 27,
    age_pref_low: 20,
    age_pref_high: 200,
    also_friends: true,
    just_friends: false
)

# u1.matches << u4
# u4.matches << u1

# u2.matches << u4
# u4.matches << u2

# u3.matches << u4
# u4.matches << u3

# rm1 = Room.create(name: "demo13Ux6LHVGCKSDMMoSnHoQBbHmTRO2")
# rm2 = Room.create(name: "demo23Ux6LHVGCKSDMMoSnHoQBbHmTRO2")
# rm3 = Room.create(name: "demo33Ux6LHVGCKSDMMoSnHoQBbHmTRO2")

# rm1.users << u1
# rm1.users << u4

# rm2.users << u2
# rm2.users << u4

# rm3.users << u3
# rm3.users << u4
