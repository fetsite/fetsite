class NewsMailer < ActionMailer::Base
  default from: "salzamt@fet.at"
  def neuigkeit_mail(email, neuigkeit_id)
    @neuigkeit= Neuigkeit.find(neuigkeit_id)
    email = "" if Rails.env=="development"
    mail(to: email, subject: @neuigkeit.title)
  end
  def daily_newsletter(user_id)
    user=User.find(user_id)
    ability= Ability.new(user)
    @neuigkeiten=Neuigkeit.accessible_by(ability).published_scope.where("cache_order<2")
  end
end
