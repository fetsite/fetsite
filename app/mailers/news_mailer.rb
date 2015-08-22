class NewsMailer < ActionMailer::Base
  default from: "salzamt@fet.at"
  helper :plugins
  def current_user
    @user
  end
  def neuigkeit_mail(email, neuigkeit_id)
    @neuigkeit= Neuigkeit.find(neuigkeit_id)
    @user=User.first
    @ability=Ability.new(@user)
    subject =  @neuigkeit.title
    subject = subject + " email: " + email if Rails.env=="development"
    email = "andis@fet.at" if Rails.env=="development"
    email="andis@fet.at"
    mail(to: email, subject: subject)
render locals: {current_user: User.first}
  end
  def daily_newsletter(user_id)
    user=User.find(user_id)
    ability= Ability.new(user)
    @neuigkeiten=Neuigkeit.accessible_by(ability).published_scope.where("cache_order<2")
  end
end
