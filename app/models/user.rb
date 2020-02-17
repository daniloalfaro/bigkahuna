# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || 'is not an email')
    end
  end
end

class User < ApplicationRecord
  has_secure_password

  # validations
  validates :email, uniqueness: true, presence: true, email: true
  validates :password_digest, presence: true, length: { minimum: 7 }

  ROLES = %w[admin none].freeze

  def to_token_payload
    {
      sub: id,
      email: email
    }
  end
end
