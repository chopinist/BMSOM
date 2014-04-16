class UserMailer < ActionMailer::Base
  default from: "\"BMSOM Rooms - Password Reset\" <bmsom.rooms@gmail.com>"

  def recover_password(user, locale)
    @user = user
    @locale = locale
    mail(to: @user.email, subject: t("recover_mail.subject"))
  end
end
