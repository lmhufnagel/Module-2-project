class Challenge < ApplicationRecord
  has_many :user_challenges
  has_many :restaurant_challenges
  has_many :users, through: :user_challenges
  has_many :restaurants, through: :restaurant_challenges

  def end_challenge
    # check timer
    if timer == false || fetch_reviews == 5
    #tally user reviews for the week
    find_winner
    #dsitribute points to winner
    distribute_points
    #destroy challenge
    self.destroy
  else
    "This challenge is still active."
  end

  end

  def timer
    @challenge = Challenge.last
    Time.now > @challenge.end
  end

  def fetch_reviews
    #fetches reviews and gives points to users
    self.users.each do |user|
      user.reviews.each do |review|
        user.weekly_points += 1
        user.save
      end
    end
  end

  def find_winner
    fetch_reviews.max_by do |user|
      user.weekly_points
    end
  end

  def reset_points
    self.users.each do |user|
      user.weekly_points = 0
    end
  end

  def distribute_points
    user = find_winner
    user.EXP += self.reward
    reset_points
    user.save
  end

end
