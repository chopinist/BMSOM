class User < ActiveRecord::Base

  before_save :titleize_name

  has_secure_password

  has_many :reservations
  has_many :remember_tokens
  has_many :password_recovery_tokens

  validates_uniqueness_of :username, :email
  validates :password, length: { in: 6..20 }, on: :create
  validates :username, length: { in: 6..30 }
  validates_format_of :email, :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  validates_format_of :username, :with => /[@.a-zA-Z0-9]/
  validates_presence_of :first_name,
                        :last_name,
                        :username
  validate :instruments_from_list_only

  def titleize_name
    self.first_name = self.first_name.downcase.titleize
    self.last_name = self.last_name.downcase.titleize
  end

  def to_hash;
   '{first_name: "' +
   self.first_name.to_s +
   '", last_name: "' +
   self.last_name.to_s +
   '", email: "' +
   self.email.to_s +
   '", instrument: "' +
   self.instrument.to_s +
   '", id: "' +
   self.id.to_s +
   '"}'
  end

  def instruments_from_list_only
    instruments = ['Piano', 'Strings', 'Wind', 'Singing', 'Other']
    unless instruments.include?(self.instrument)
      errors.add(:base,I18n.t("new_user.instrument_error"))
    end
  end
end
