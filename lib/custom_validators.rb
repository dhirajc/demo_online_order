module CustomValidators

  class Emails
    # please refer to : http://stackoverflow.com/questions/703060/valid-email-address-regular-expression
    def self.email_validator
      /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i
    end
  end

  class Numbers
    def self.phone_number_validator
      #/\A\d?(?:(?:[\+]?(?:[\d]{1,3}(?:[ ]+|[\-.])))?[(]?(?:[\d]{3})[\-)]?(?:[ ]+)?)?(?:[a-zA-Z2-9][a-zA-Z0-9 \-.]{6,})(?:(?:[ ]+|[xX]|(i:ext[\.]?)){1,2}(?:[\d]{1,5}))?\z/
      /(?:\+?|\b)[0-9]{10}\b/
    end
    def self.us_and_canda_zipcode_validator
      /(\A\d{5}(-\d{4})?\z)|(\A[ABCEGHJKLMNPRSTVXYabceghjklmnprstvxy]{1}\d{1}[A-Za-z]{1} *\d{1}[A-Za-z]{1}\d{1}\z)/
    end

    def self.usps_tracking_number_validator
      /\b(91\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d|91\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d ?\d\d\d\d)\b/i
    end

    def self.fedex_tracking_number_validator
      /\A([0-9]{15}|4[0-9]{11})\z/
    end

    def self.ups_tracking_number_validator
      #/\b(1Z ?[0-9A-Z]{3} ?[0-9A-Z]{3} ?[0-9A-Z]{2} ?[0-9A-Z]{4} ?[0-9A-Z]{3} ?[0-9A-Z]|[\dT]\d\d\d ?\d\d\d\d ?\d\d\d)\b/i
      /\A(1Z\s*\d{3}\s*\d{3}\s*\d{2}\s*\d{4}\s*\d{3}\s*\d|[0-35-9]\d{3}\s*\d{4}\s*\d{4}|T\d{3}\s*\d{4}\s*\d{3})\z/
    end
  end

  class Names
    def self.name_validator
      #/([a-zA-Z-’'` ].+)/ \A and \z
      #/^([a-z])+([\\']|[']|[\.]|[\s]|[-]|)+([a-z]|[\.])+$/i
      #/^([a-z]|[\\']|[']|[\.]|[\s]|[-]|)+([a-z]|[\.])+$/i
      /\A([[:alpha:]]|[\\']|[']|[\.]|[\s]|[-]|)+([[:alpha:]]|[\.])+\z/i
    end
  end

  def validates_ssn(*attr_names)
    attr_names.each do |attr_name|
      validates_format_of attr_name,
        :with => /\A[\d]{3}-[\d]{2}-[\d]{4}\z/,
        :message => "must be of format ###-##-####"
    end
  end


end
