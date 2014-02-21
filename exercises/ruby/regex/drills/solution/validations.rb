def valid_email?(email)
  email =~ /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
end

def valid_phone_number?(number)
  number =~ /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/
end

def valid_password?(password)
  password =~ /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$/
end

def valid_username?(username)
  username =~  /^[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*$/
end

def valid_credit_card_number?(number)
  number =~ /(^[3456])\d+/ && [13,15,16].include?(number.size)
end

def only_numbers?(number)
  number =~ /^\d+$/
end

def only_letters?(word)
  word =~ /^[a-zA-Z]+$/
end

def valid_social_security?(social)
  social =~ /^(\d){3}(-?\d{2})(-?\d{4})$/
end

def valid_zip_code?(zip)
  zip =~ /^\d{5}(?:-\d{4})?$/
end
