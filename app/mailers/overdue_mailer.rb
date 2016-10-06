class OverdueMailer < ActionMailer::Base
  default from: "from@example.com"

  @last_sent = @last_sent || Date.new(2000,1,1)

  class << self
    attr_accessor :last_sent
  end

  def overdue_reminder(user)
    @user = user
    mail(to: @user.email, subject: 'Overdue Reminder')
  end
end
