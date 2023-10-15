task sample_data: :environment do

  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end
  names = ["Alice", "Anna", "Bob", "Mary", "Lucy", "Kat", "Cindy", "Mindy", "Lisa", "Adam", "Jerry", "Dylan"]

  names.each do |name|
    
    User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name.downcase,
      private: [true, false].sample,
    )
  end

  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      next if first_user == second_user
      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.values.sample
        )
      end

      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.values.sample
        )
      end
    end
  end

  users.each do |user|
    rand(15).times do
      photo = user.own_photos.create(
        caption: Faker::Quote.famous_last_words,
        image: "https://robohash.org/#{rand(9999)}"
      )

      user.followers.each do |follower|
        if rand < 0.5
          photo.fans << follower
        end

        if rand < 0.25
          photo.comments.create(
            body: Faker::Quote.most_interesting_man_in_the_world,
            author: follower
          )
        end
      end
    end
  end

  p "Added #{User.count} users."
  p "Added #{FollowRequest.count} follow requests."
  p "Added #{Photo.count} photos."
  p "Added #{Like.count} likes."
  p "Added #{Comment.count} comments."
end
