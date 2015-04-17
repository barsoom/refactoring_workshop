require "digest"
require "attr_extras"

# NOTE: "three-letter prefix" is not guaranteed to be 3.

module XYZ
  class Namer
    RANDOM_DIGITS_LENGTH = 8
    TITLE_MAX_LENGTH = 10

    static_facade :xyz_filename, :target

    def xyz_filename
      [                   # Example:
        day_of_month,     # 07
        category_prefix,  # abc
        kind,             # magic_unicorn
        age_if_personal,  # _042
        divider,          # _
        target.id,        # 1337
        divider,          # _
        random_chars,     # 123abc78
        divider,          # _
        title_prefix,     # helloworld
        extension,        # .jpg
      ].compact.join
    end

    private

    def day_of_month
      zeropad(target.publish_on.day, 2)
    end

    def category_prefix
      target.xyz_category_prefix
    end

    def kind
      target.kind.delete(divider)
    end

    def age_if_personal
      if target.personal?
        [ divider, zeropad(age, 3) ].join
      else
        nil
      end
    end

    def divider
      "_"
    end

    def random_chars
      Digest::SHA1.hexdigest(rand(10_000).to_s)[0, RANDOM_DIGITS_LENGTH]
    end

    def title_prefix
      clean_title = target.title.gsub(/[^a-z\[\]]/i, "").downcase
      clean_title[0, TITLE_MAX_LENGTH]
    end

    def extension
      ".jpg"
    end

    def age
      target.age || 0
    end

    def zeropad(number, length)
      number.to_s.rjust(length, "0")
    end
  end
end
